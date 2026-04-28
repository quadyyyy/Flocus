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
    private var repository: TaskRepositoryProtocol?
    private var date: Date = .now

    init() {}

    func setup(repository: TaskRepositoryProtocol, date: Date) {
        self.repository = repository
        self.date = date
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
        tasks = all.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
    }
}
