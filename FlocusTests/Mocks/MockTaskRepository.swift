//
//  MockTaskRepository.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 10.05.2026.
//

import Foundation
@testable import Flocus

class MockTaskRepository: TaskRepositoryProtocol {
    var tasks: [TaskModel] = []
    var shouldThrow: Bool = false

    func fetchAll() throws -> [TaskModel] {
        if shouldThrow { throw NSError(domain: "test", code: 0) }
        return tasks
    }
    func add(_ task: TaskModel) throws { tasks.append(task) }
    func delete(_ task: TaskModel) throws { tasks.remove(at: tasks.firstIndex(of: task)!) }
    func save() throws { }
    func deleteAll() { tasks = [] }
}
