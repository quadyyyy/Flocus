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
    func add(_ task: TaskModel) throws
    func delete(_ task: TaskModel) throws
    func save() throws
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
    
    func add(_ task: TaskModel) throws {
        context.insert(task)
        try context.save()
    }
    
    func delete(_ task: TaskModel) throws {
        context.delete(task)
        try context.save()
    }

    func save() throws {
        try context.save()
    }
    
    func deleteAll() {
        try? context.delete(model: TaskModel.self)
        try? context.save()
    }
}
