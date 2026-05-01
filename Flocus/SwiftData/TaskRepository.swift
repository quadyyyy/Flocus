//
//  TaskRepository.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 18.04.2026.
//

import Foundation
import SwiftData

protocol TaskRepositoryProtocol {
    func fetchAll() throws -> [TaskModel]
    func add(_ task: TaskModel)
    func delete(_ task: TaskModel)
    func save()
    func deleteAll()
}

class TaskRepository: TaskRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAll() throws -> [TaskModel] {
        let descriptor = FetchDescriptor<TaskModel>(sortBy: [SortDescriptor(\.dueDate)])
        return try context.fetch(descriptor)
    }
    
    func add(_ task: TaskModel) {
        context.insert(task)
        try? context.save()
    }
    
    func delete(_ task: TaskModel) {
        context.delete(task)
        try? context.save()
    }

    func save() {
        try? context.save()
    }
    
    func deleteAll() {
        try? context.delete(model: TaskModel.self)
        try? context.save()
    }
}
