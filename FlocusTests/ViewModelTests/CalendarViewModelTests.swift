//
//  CalendarViewModelTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 11.05.2026.
//

import Foundation
import Testing
@testable import Flocus

@Suite("CalendarViewModel tests")
@MainActor
struct CalendarViewModelTests {

    @Test func test_reload_tasks_groups_by_date() async throws {
        // given
        let vm = CalendarViewModel()
        let date = Date.now
        let task = TaskModel(title: "test", details: "test", dueDate: date)
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        // when
        vm.reloadTasks([task])
        
        // then
        #expect(vm.tasks(for: comps).count == 1)
    }
    
    @Test func test_tasks_noTasksForDate_returnsEmpty() {
        // given
        let vm = CalendarViewModel()
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        // when
        vm.reloadTasks([])
        
        // then
        #expect(vm.tasks(for: comps).isEmpty)
    }
    
    @Test func test_reloadTasks_differentDates_separateGroups() {
        // given
        let vm = CalendarViewModel()
        let date1 = Date.now
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
        let tasks = [
            TaskModel(title: "title1", details: "test", dueDate: date1),
            TaskModel(title: "title2", details: "test", dueDate: date2)
        ]
        let date1Comps = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let date2Comps = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        
        // when
        vm.reloadTasks(tasks)
        
        // then
        #expect(vm.tasks(for: date1Comps).count == 1)
        #expect(vm.tasks(for: date2Comps).count == 1)
    }

}
