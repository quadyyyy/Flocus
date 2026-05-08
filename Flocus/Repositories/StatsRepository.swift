//
//  StatsRepository.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 28.04.2026.
//


import Foundation
import Combine

@MainActor
protocol StatsRepositoryProtocol {
    func incrementCompletedTask()
    func decrementCompletedTask()
    func incrementFocusSession()
    func resetAll()
    func addToArray(_ date: DateComponents)
    func deleteFromArray(_ date: DateComponents)
    func getCompletedTasksCount() -> Int
    func getFocusSessionsCount() -> Int
    func getStreakDates() -> [DateComponents]
}

@MainActor
class StatsRepository: ObservableObject, StatsRepositoryProtocol {
    private let completedTasksKey = "completedTasksCount"
    private let focusSessionsKey = "focusSessionsCount"
    private let streakDatesArrayKey = "streakDates"
    
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
    
    func addToArray(_ date: DateComponents) {
        let existing = UserDefaults.standard.getArray(DateComponents.self, forKey: streakDatesArrayKey)
        guard !existing.contains(date) else { return }
        UserDefaults.standard.appendToArray(date, forKey: streakDatesArrayKey)
    }

    func deleteFromArray(_ date: DateComponents) {
        UserDefaults.standard.removeFromArray(date, forKey: streakDatesArrayKey)
    }
    
    func getCompletedTasksCount() -> Int {
        return UserDefaults.standard.integer(forKey: completedTasksKey)
    }
    
    func getFocusSessionsCount() -> Int {
        return UserDefaults.standard.integer(forKey: focusSessionsKey)
    }
    
    func getStreakDates() -> [DateComponents] {
        return UserDefaults.standard.getArray(DateComponents.self, forKey: streakDatesArrayKey)
    }
    
    func resetAll() {
        UserDefaults.standard.set(0, forKey: completedTasksKey)
        UserDefaults.standard.set(0, forKey: focusSessionsKey)
        UserDefaults.standard.removeObject(forKey: streakDatesArrayKey)
    }
}

extension UserDefaults {
    func appendToArray<T: Codable>(_ value: T, forKey key: String) {
              var array = getArray(T.self, forKey: key)
              array.append(value)
              if let data = try? JSONEncoder().encode(array) {
                  set(data, forKey: key)
              }
          }

    func getArray<T: Codable>(_ type: T.Type, forKey key: String) -> [T] {
        guard let data = data(forKey: key),
              let array = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return array
    }

    func removeFromArray<T: Codable & Equatable>(_ value: T, forKey key: String) {
        var array = getArray(T.self, forKey: key)
        array.removeAll { $0 == value }
        if let data = try? JSONEncoder().encode(array) {
            set(data, forKey: key)
        }
    }
}
