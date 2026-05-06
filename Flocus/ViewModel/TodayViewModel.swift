//
//  TodayViewModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 18.04.2026.
//

import Foundation
import Combine
import SwiftData

class TodayViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var errorMessage: String? = nil
    private var repository: TaskRepositoryProtocol?
    private var statsRepository: StatsRepositoryProtocol?

    init() {}

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
}

