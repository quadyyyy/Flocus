//
//  PomodoroViewModelTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 13.05.2026.
//

import Testing
@testable import Flocus

@Suite("PomodoroViewModel tests")
@MainActor
struct PomodoroViewModelTests {
    
    @Test func test_timeString_shows_correct_value() async throws {
        // given
        let vm = PomodoroViewModel()
        vm.timeRemaining = 100
        
        // expect
        #expect(vm.timeString == "01:40")
    }
    
    @Test func test_progress_shows_correct_value() async throws {
        // given
        let vm = PomodoroViewModel()
        vm.timeRemaining = 750
        
        // expect
        #expect(vm.progress == 0.5)
    }

    @Test func test_after_focus_comes_short_break() async throws {
        // given
        let vm = PomodoroViewModel(tickInterval: 1_000_000)
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
        vm.setup(statsRepository: repo)
        vm.timeRemaining = 3
        vm.phase = .focus
        
        // when
        vm.start()
        try await Task.sleep(nanoseconds: 30_000_000)
        
        #expect(repo.getFocusSessionsCount() == 1)
    }

}
