//
//  ProfileViewModelTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 12.05.2026.
//

import Testing
@testable import Flocus


@Suite("ProfileViewModel tests")
@MainActor
struct ProfileViewModelTests {

    @Test func focusTimeFormatted_returns_correct_minutes() {
        // given
        let vm = ProfileViewModel()
        
        // when
        vm.focusSessions = 1
        
        // then
        #expect(vm.focusTimeFormatted == "25m")
    }
    
    @Test func focusTimeFormatted_returns_correct_hours_and_minutes() {
        // given
        let vm = ProfileViewModel()
        
        // when
        vm.focusSessions = 5
        
        // then
        #expect(vm.focusTimeFormatted == "2h 5m")
    }
    
    @Test func focusTimeFormatted_return_zero_when_no_sessions() {
        // given
        let vm = ProfileViewModel()
        
        // when
        vm.focusSessions = 0
        
        // then
        #expect(vm.focusTimeFormatted == "0m")
    }

}
