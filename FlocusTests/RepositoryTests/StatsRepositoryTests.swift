//
//  StatsRepositoryTests.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 11.05.2026.
//

import Foundation
import Testing
@testable import Flocus

@Suite("StatsRepository tests")
@MainActor
struct StatsRepositoryTests {

    
    func makeRepo() -> StatsRepository {
        StatsRepository(defaults: UserDefaults(suiteName: UUID().uuidString)!)
    }
    
    @Test func incrementCompletedTask_increseases_count() async throws {
        // given
        let repo = makeRepo()
        
        // when
        repo.incrementCompletedTask()
        repo.incrementCompletedTask()
        
        // then
        #expect(repo.getCompletedTasksCount() == 2)
    }
    
    @Test func decrementCompletedTask_decreases_count() async throws {
        // given
        let repo = makeRepo()
        repo.incrementCompletedTask()
        repo.incrementCompletedTask()
        
        // when
        repo.decrementCompletedTask()
        
        // then
        #expect(repo.getCompletedTasksCount() == 1)
    }
    
    @Test func decrementCompletedTask_doesNotGoBelowZero() {
        // given
        let repo = makeRepo()
        
        // when
        repo.decrementCompletedTask()
        
        // then
        #expect(repo.getCompletedTasksCount() == 0)
    }
    
    @Test func incrementFocusSession_increases_count() async throws {
        // given
        let repo = makeRepo()
        
        // when
        repo.incrementFocusSession()
        
        // then
        #expect(repo.getFocusSessionsCount() == 1)
    }
    
    @Test func addToArray_adds_element() async throws {
        // given
        let repo = makeRepo()
        let date = Date.now
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        // when
        repo.addToArray(comps)
        
        // then
        #expect(repo.getStreakDates().count == 1)
    }
    
    @Test func addToArray_noDuplicates() {
        // given
        let repo = makeRepo()
        let date = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        // when
        repo.addToArray(date)
        repo.addToArray(date)
        
        // then
        #expect(repo.getStreakDates().count == 1)
    }
    
    @Test func deleteFromArray_removes_element() async throws {
        // given
        let repo = makeRepo()
        let date1 = Date.now
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
        let date1Comps = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let date2Comps = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        repo.addToArray(date1Comps)
        repo.addToArray(date2Comps)
        
        // when
        repo.deleteFromArray(date1Comps)
        
        // then
        #expect(repo.getStreakDates().count == 1)
    }
    
    @Test func resetAll_resets_all_stats() async throws {
        // given
        let repo = makeRepo()
        let date1 = Date.now
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
        let date1Comps = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let date2Comps = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        
        repo.addToArray(date1Comps)
        repo.addToArray(date2Comps)
        
        repo.incrementCompletedTask()
        repo.incrementFocusSession()
        
        // when
        repo.resetAll()
        
        // then
        #expect(repo.getStreakDates().isEmpty)
        #expect(repo.getCompletedTasksCount() == 0)
        #expect(repo.getFocusSessionsCount() == 0)
    }

}
