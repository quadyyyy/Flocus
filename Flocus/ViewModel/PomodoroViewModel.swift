//
//  PomodoroViewModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 23.04.2026.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

enum PomodoroPhase {
    case focus
    case shortBreak
    case longBreak

    var duration: Int {
        switch self {
        case .focus: return 25 * 60
        case .shortBreak: return 5 * 60
        case .longBreak: return 15 * 60
        }
    }

    var label: String {
        switch self {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
}

@MainActor
class PomodoroViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var streak: Int = 0
    @Published var errorMessage: String? = nil
    private var repository: TaskRepositoryProtocol?
    private var statsRepository: StatsRepositoryProtocol?
    @Published var timeRemaining: Int = PomodoroPhase.focus.duration
    @Published var phase: PomodoroPhase = PomodoroPhase.focus
    @Published var isRunning: Bool = false
    @Published var completedSessions: Int = 0
    private let tickInterval: UInt64

    init(tickInterval: UInt64 = 1_000_000_000) {
        self.tickInterval = tickInterval
    }

    func setup(repository: TaskRepositoryProtocol, statsRepository: StatsRepositoryProtocol) {
        self.repository = repository
        self.statsRepository = statsRepository
        reload()
    }

    func addTask(_ task: TaskModel) {
        do {
            try repository?.add(task)
        } catch {
            errorMessage = "Failed to add task"
        }
        reload()
    }

    func deleteTask(_ task: TaskModel) {
        do {
            try repository?.delete(task)
        } catch {
            errorMessage = "Failed to delete task"
        }
        reload()
    }

    func toggleTask(_ task: TaskModel) {
        task.isCompleted.toggle()
        do {
            try repository?.save()
            if task.isCompleted {
                statsRepository?.incrementCompletedTask()
                statsRepository?.addToArray(Calendar.current.dateComponents([.year, .month, .day], from: Date()))
            } else {
                statsRepository?.decrementCompletedTask()
            }
        } catch {
            errorMessage = "Failed to save task data"
        }
        reload()
    }

    private func reload() {
        guard errorMessage == nil else { return }
        do {
            let all = (try repository?.fetchAll()) ?? []
            tasks = all.filter(isVisibleToday)
        } catch {
            errorMessage = "Failed to reload data"
        }
    }


    private func isVisibleToday(_ task: TaskModel) -> Bool {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        let isToday = task.dueDate >= startOfToday && task.dueDate < startOfTomorrow
        let isOverdue = task.dueDate < startOfToday && !task.isCompleted

        return isToday || isOverdue
    }

    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: Double {
        1.0 - Double(timeRemaining) / Double(phase.duration)
    }

    private var timerTask: Task<Void, Never>?

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timerTask = Task {
            while timeRemaining > 0 {
                do {
                    try await Task.sleep(nanoseconds: tickInterval)
                } catch {
                    return
                }

                timeRemaining -= 1
            }
            if phase == .focus {
                statsRepository?.incrementFocusSession()
            }

            advance()
        }
    }

    func pause() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }

    func reset() {
        pause()
        timeRemaining = phase.duration
    }

    private func advance() {
        switch phase {
        case .focus:
            completedSessions += 1
            phase = completedSessions % 4 == 0 ? .longBreak : .shortBreak
        case .shortBreak, .longBreak:
            phase = .focus
        }
        timeRemaining = phase.duration
        isRunning = false
    }

    // MARK: - UI methods
    func phaseColor() -> Color {
        switch phase {
        case  .focus: return .blue
        case .shortBreak: return .green
        case .longBreak: return .yellow
        }
    }
}
