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

    @Test func test_todayTask_is_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let todayTask = TaskModel(title: "Task", details: "", dueDate: .now)
        taskRepo.tasks = [todayTask]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.count == 1)
    }

    @Test func test_futureTask_is_not_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: tomorrow)]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func test_overdue_incomplet_task_is_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: yesterday, isCompleted: false)]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.count == 1)
    }

    @Test func test_overdueCompletedTask_is_not_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: yesterday, isCompleted: true)]
        let vm = TodayViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func test_streak_no_dates_is_zero() {
        // Given
        let statsRepo = MockStatsRepository()
        statsRepo.streakDates = []
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 0)
    }

    @Test func test_streak_only_today_is_one() {
        // Given
        let statsRepo = MockStatsRepository()
        statsRepo.streakDates = [Calendar.current.dateComponents([.year, .month, .day], from: .now)]
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 1)
    }

    @Test func test_streak_yesterday_and_today_is_two() {
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

    @Test func test_streak_only_yesterday_is_one() {
        // Given
        let statsRepo = MockStatsRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        statsRepo.streakDates = [Calendar.current.dateComponents([.year, .month, .day], from: yesterday)]
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 1)
    }

    @Test func test_streak_gap_in_dates_counts_only_continuous() {
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

    @Test func test_addTask_appears_in_tasks() {
        // Given
        let vm = TodayViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())

        // When
        vm.addTask(TaskModel(title: "New Task", details: "", dueDate: .now))

        // Then
        #expect(vm.tasks.count == 1)
    }


    @Test func test_deleteTask_removed_from_tasks() {
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

    @Test func test_toggleTask_complete_increments_stats() {
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

    @Test func test_toggleTask_uncomplete_decrements_stats() {
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

    @Test func test_toggleTask_complete_adds_StreakDate() {
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

    @Test func test_fetchAll_throws_sets_ErrorMessage() {
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
