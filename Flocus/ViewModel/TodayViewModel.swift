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
        tasks = (try? repository.fetchAll()) ?? []
    }
    
    func addTask(_ task: TaskModel) {
        repository?.add(task)
        tasks = (try? repository?.fetchAll()) ?? []
    }

    func deleteTask(_ task: TaskModel) {
        repository?.delete(task)
        tasks = (try? repository?.fetchAll()) ?? []
    }
}
