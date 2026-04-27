//
//  PomodoroViewModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 23.04.2026.
//

import Foundation
import Combine
import SwiftUI

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
    @Published var timeRemaining: Int = PomodoroPhase.focus.duration
    @Published var phase: PomodoroPhase = PomodoroPhase.focus
    @Published var isRunning: Bool = false
    @Published var completedSessions: Int = 0
    
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
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                } catch {
                    return
                }
                
                timeRemaining -= 1
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
