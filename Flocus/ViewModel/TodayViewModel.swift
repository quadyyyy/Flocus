//
//  TodayViewModel.swift
//  Flocus
//
//  Created by Куприянов Тимофей on 18.04.2026.
//

import Foundation
import Combine
import SwiftData

class TodayViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    private var repository: TaskRepositoryProtocol?

    init() {}

    func setup(repository: TaskRepositoryProtocol) {
        self.repository = repository
        reload()
    }

    func addTask(_ task: TaskModel) {
        repository?.add(task)
        reload()
    }

    func deleteTask(_ task: TaskModel) {
        repository?.delete(task)
        reload()
    }

    private func reload() {
        let all = (try? repository?.fetchAll()) ?? []
        tasks = all.filter(isVisibleToday)
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
