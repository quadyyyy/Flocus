//
//  MockStatsRepository.swift
//  FlocusTests
//
//  Created by Timofei Kupriianov on 10.05.2026.
//

import Foundation
@testable import Flocus

@MainActor
class MockStatsRepository: StatsRepositoryProtocol {
    var completedCount = 0
    var streakDates: [DateComponents] = []
    var focusSessionsCount: Int = 0

    func incrementCompletedTask() { completedCount += 1 }
    func decrementCompletedTask() { completedCount -= 1 }
    func incrementFocusSession() { focusSessionsCount += 1}
    func resetAll() { completedCount = 0; streakDates = [] }
    func addToArray(_ date: DateComponents) { streakDates.append(date) }
    func deleteFromArray(_ date: DateComponents) { streakDates.removeAll { $0 == date } }
    func getCompletedTasksCount() -> Int { completedCount }
    func getFocusSessionsCount() -> Int { focusSessionsCount }
    func getStreakDates() -> [DateComponents] { streakDates }
}
