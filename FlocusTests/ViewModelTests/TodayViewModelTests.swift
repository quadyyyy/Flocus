//
//  TodayViewModelTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 10.05.2026.
//

import Foundation
import Testing
@testable import Flocus

@Suite("TodayViewModel Tests")
@MainActor
struct TodayViewModelTests {

    @Test func todayTask_isVisible() {
        // Given
        let taskRepo = MockTaskRepository()
        let todayTask = TaskModel(title: "Task", details: "", dueDate: .now)
        taskRepo.tasks = [todayTask]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.count == 1)
    }

    @Test func futureTask_isNotVisible() {
        // Given
        let taskRepo = MockTaskRepository()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: tomorrow)]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func overdueIncompleteTask_isVisible() {
        // Given
        let taskRepo = MockTaskRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: yesterday, isCompleted: false)]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.count == 1)
    }

    @Test func overdueCompletedTask_isNotVisible() {
        // Given
        let taskRepo = MockTaskRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: yesterday, isCompleted: true)]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func streak_noDates_isZero() {
        // Given
        let statsRepo = MockStatsRepository()
        statsRepo.streakDates = []
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 0)
    }

    @Test func streak_onlyToday_isOne() {
        // Given
        let statsRepo = MockStatsRepository()
        statsRepo.streakDates = [Calendar.current.dateComponents([.year, .month, .day], from: .now)]
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 1)
    }

    @Test func streak_yesterdayAndToday_isTwo() {
        // Given
        let statsRepo = MockStatsRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        statsRepo.streakDates = [
            Calendar.current.dateComponents([.year, .month, .day], from: yesterday),
            Calendar.current.dateComponents([.year, .month, .day], from: .now)
        ]
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 2)
    }

    @Test func streak_onlyYesterday_isOne() {
        // Given
        let statsRepo = MockStatsRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        statsRepo.streakDates = [Calendar.current.dateComponents([.year, .month, .day], from: yesterday)]
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 1)
    }

    @Test func streak_gapInDates_countsOnlyContinuous() {
        // Given
        let statsRepo = MockStatsRepository()
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        statsRepo.streakDates = [
            Calendar.current.dateComponents([.year, .month, .day], from: threeDaysAgo),
            Calendar.current.dateComponents([.year, .month, .day], from: yesterday),
            Calendar.current.dateComponents([.year, .month, .day], from: .now)
        ]
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then: gap at -2, streak is 2 (yesterday + today)
        #expect(vm.streak == 2)
    }

    @Test func addTask_appearsInTasks() {
        // Given
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())

        // When
        vm.addTask(TaskModel(title: "New Task", details: "", dueDate: .now))

        // Then
        #expect(vm.tasks.count == 1)
    }


    @Test func deleteTask_removedFromTasks() {
        // Given
        let taskRepo = MockTaskRepository()
        let task = TaskModel(title: "Task", details: "", dueDate: .now)
        taskRepo.tasks = [task]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // When
        vm.deleteTask(task)

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func toggleTask_complete_incrementsStats() {
        // Given
        let taskRepo = MockTaskRepository()
        let statsRepo = MockStatsRepository()
        let task = TaskModel(title: "Task", details: "", dueDate: .now, isCompleted: false)
        taskRepo.tasks = [task]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: statsRepo)

        // When
        vm.toggleTask(task)

        // Then
        #expect(statsRepo.completedCount == 1)
    }

    @Test func toggleTask_uncomplete_decrementsStats() {
        // Given
        let taskRepo = MockTaskRepository()
        let statsRepo = MockStatsRepository()
        let task = TaskModel(title: "Task", details: "", dueDate: .now, isCompleted: true)
        taskRepo.tasks = [task]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: statsRepo)

        // When
        vm.toggleTask(task)

        // Then
        #expect(statsRepo.completedCount == -1)
    }

    @Test func toggleTask_complete_addsStreakDate() {
        // Given
        let taskRepo = MockTaskRepository()
        let statsRepo = MockStatsRepository()
        let task = TaskModel(title: "Task", details: "", dueDate: .now, isCompleted: false)
        taskRepo.tasks = [task]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: statsRepo)

        // When
        vm.toggleTask(task)

        // Then
        #expect(!statsRepo.streakDates.isEmpty)
    }

    @Test func fetchAll_throws_setsErrorMessage() {
        // Given
        let taskRepo = MockTaskRepository()
        taskRepo.shouldThrow = true
        let vm = TodayViewModel()

        // When
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.errorMessage != nil)
    }
}
