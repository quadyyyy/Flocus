//
//  StatsRepository.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 28.04.2026.
//


import Foundation

@MainActor
protocol StatsRepositoryProtocol {
    func incrementCompletedTask()
    func decrementCompletedTask()
    func incrementFocusSession()
}

@MainActor
class StatsRepository: StatsRepositoryProtocol {
    private let completedTasksKey = "completedTasksCount"
    private let focusSessionsKey = "focusSessionsCount"
    
    func incrementCompletedTask() {
        let current = UserDefaults.standard.integer(forKey: completedTasksKey)
        UserDefaults.standard.set(current + 1, forKey: completedTasksKey)
    }
    
    func decrementCompletedTask() {
        let current = UserDefaults.standard.integer(forKey: completedTasksKey)
        UserDefaults.standard.set(max(0, current - 1), forKey: completedTasksKey)
    }
    
    func incrementFocusSession() {
        let current = UserDefaults.standard.integer(forKey: focusSessionsKey)
        UserDefaults.standard.set(current + 1, forKey: focusSessionsKey)
    }
}
