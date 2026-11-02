//
//  PomodoroViewModelTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 13.05.2026.
//

import Foundation
import Testing
@testable import Flocus

@Suite("PomodoroViewModel tests")
@MainActor
struct PomodoroViewModelTests {
    
    @Test func test_timeString_shows_correct_value() async throws {
        // given
        let vm = PomodoroViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 100
        
        // expect
        #expect(vm.timeString == "01:40")
    }
    
    @Test func test_progress_shows_correct_value() async throws {
        // given
        let vm = PomodoroViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 750
        
        // expect
        #expect(vm.progress == 0.5)
    }

    @Test func test_after_focus_comes_short_break() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 3
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        // then
        #expect(vm.phase == .shortBreak)
    }
    
    @Test func test_after_four_session_comes_long_break() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.completedSessions = 3
        vm.timeRemaining = 3
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        // then
        #expect(vm.phase == .longBreak)
    }
    
    @Test func test_after_short_break_comes_focus() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 3
        vm.phase = .shortBreak
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        // then
        #expect(vm.phase == .focus)
    }
    
    @Test func test_after_long_break_comes_focus() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 3
        vm.phase = .longBreak
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        // then
        #expect(vm.phase == .focus)
    }
    
    @Test func test_start_function_guard_works() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 3
        
        // when
        vm.start()
        vm.start()
        
        // then
        #expect(vm.isRunning == true)
    }
    
    @Test func test_completedSessions_increments_after_focus() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 3
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        // then
        #expect(vm.completedSessions == 1)
    }
    
    @Test func test_pause_function_toggles_isRunning() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 3
        
        // when
        vm.start()
        vm.pause()
        
        // then
        #expect(vm.isRunning == false)
    }
    
    @Test func test_reset_function_stops_timer_and_restores_time() {
        // given
        let vm = PomodoroViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: MockStatsRepository())
        vm.timeRemaining = 100
        
        // when
        vm.start()
        vm.reset()
        
        // then
        #expect(vm.isRunning == false)
        #expect(vm.timeRemaining == PomodoroPhase.focus.duration)
    }
    
    @Test func test_start_function_after_focus_session_increments_focus_sessions_count() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
        let repo = MockStatsRepository()
        vm.setup(repository: MockTaskRepository(), statsRepository: repo)
        vm.timeRemaining = 3
        vm.phase = .focus
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        #expect(repo.getFocusSessionsCount() == 1)
    }
    
    @Test func test_todayTask_is_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let todayTask = TaskModel(title: "Task", details: "", dueDate: .now)
        taskRepo.tasks = [todayTask]
        let vm = PomodoroViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.count == 1)
    }

    @Test func test_futureTask_is_not_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: tomorrow)]
        let vm = PomodoroViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func test_overdue_incomplet_task_is_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: yesterday, isCompleted: false)]
        let vm = PomodoroViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.count == 1)
    }

    @Test func test_overdueCompletedTask_is_not_visible() {
        // Given
        let taskRepo = MockTaskRepository()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        taskRepo.tasks = [TaskModel(title: "Task", details: "", dueDate: yesterday, isCompleted: true)]
        let vm = PomodoroViewModel()
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // Then
        #expect(vm.tasks.isEmpty)
    }

    @Test func test_streak_no_dates_is_zero() {
        // Given
        let statsRepo = MockStatsRepository()
        statsRepo.streakDates = []
        let vm = PomodoroViewModel()
        vm.setup(repository: MockTaskRepository(), statsRepository: statsRepo)

        // Then
        #expect(vm.streak == 0)
    }


    @Test func test_addTask_appears_in_tasks() {
        // Given
        let vm = PomodoroViewModel()
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
        let vm = PomodoroViewModel()
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
        let vm = PomodoroViewModel()
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
        let vm = PomodoroViewModel()
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
        let vm = PomodoroViewModel()
        vm.setup(repository: taskRepo, statsRepository: statsRepo)

        // When
        vm.toggleTask(task)

        // Then
        #expect(!statsRepo.streakDates.isEmpty)
    }

    @Test func test_fetchAll_throws_sets_ErrorMessage() {
        // given
        let taskRepo = MockTaskRepository()
        taskRepo.shouldThrow = true
        let vm = PomodoroViewModel()

        // when
        vm.setup(repository: taskRepo, statsRepository: MockStatsRepository())

        // then
        #expect(vm.errorMessage != nil)
    }


}
