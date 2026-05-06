//
//  SelectedDateViewModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 28.04.2026.
//

import Foundation
import Combine
import SwiftData

class SelectedDateViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var errorMessage: String? = nil
    private var repository: TaskRepositoryProtocol?
    private var statsRepository: StatsRepositoryProtocol?
    private var date: Date = .now

    init() {}

    func setup(repository: TaskRepositoryProtocol, statsRepository: StatsRepositoryProtocol, date: Date) {
        self.repository = repository
        self.statsRepository = statsRepository
        self.date = date
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
            tasks = all.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
        } catch {
            errorMessage = "Failed to reload data"
        }
    }
}
