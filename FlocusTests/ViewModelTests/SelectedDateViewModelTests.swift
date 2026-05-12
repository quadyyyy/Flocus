//
//  SelectedDateViewModelTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 10.05.2026.
//

import Foundation
import Testing
@testable import Flocus

@Suite("SelectedDateViewModel Tests")
@MainActor
struct SelectedDateViewModelTests {

    @Test func selected_date_task_visible() {
        // given
        let taskRepo = MockTaskRepository()
        let selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "test", details: "test", dueDate: selectedDate)]
        let vm = SelectedDateViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository(), date: selectedDate)
        
        // then
        #expect(vm.tasks.count == 1)
    }
    
    @Test func not_selected_date_task_not_visible() {
        // given
        let taskRepo = MockTaskRepository()
        let notSelectedDate = Calendar.current.date(byAdding: .day, value: 2, to: .now)!
        taskRepo.tasks = [TaskModel(title: "test", details: "test", dueDate: notSelectedDate)]
        let vm = SelectedDateViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository(), date: Date())
        
        // then
        #expect(vm.tasks.isEmpty)
    }
    
    @Test func add_task_for_selected_date_appears() {
        // given
        let taskRepo = MockTaskRepository()
        let vm = SelectedDateViewModel()
        let selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository(), date: selectedDate)

        // when
        vm.addTask(TaskModel(title: "New Task", details: "", dueDate: selectedDate))

        // then
        #expect(vm.tasks.count == 1)
    }

}
