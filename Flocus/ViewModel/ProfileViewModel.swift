//
//  ProfileViewModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 01.05.2026.
//

import Foundation
import Combine
import SwiftUI

struct Achievement: Identifiable {
    var id: UUID = UUID()
    var icon: String
    var iconColor: Color
    var title: String
    var description: String
    var isAchieved: Bool
}

class ProfileViewModel: ObservableObject {
    private let stats: StatsRepository

    @Published var completedTasks: Int = 0
    @Published var focusSessions: Int = 0
    @Published var streak: Int = 0
    
    var achievements: [Achievement] {
        [
            Achievement(icon: "trophy.fill", iconColor: .yellow, title: "Centurion", description: "Complete 100 tasks", isAchieved: completedTasks >= 100),
            Achievement(icon: "clock.fill", iconColor: .purple, title: "Deep work", description: "25h focused", isAchieved: focusSessions >= 60),
            Achievement(icon: "case.fill", iconColor: .green, title: "Fresh start", description: "Complete your first task", isAchieved: completedTasks >= 1),
            Achievement(icon: "star.fill", iconColor: .cyan, title: "Fresh focused", description: "Complete your first focus session", isAchieved: focusSessions >= 1)
        ]
    }
    
    init(stats: StatsRepository) {
        self.stats = stats
        load()
    }
    
    var focusTimeFormatted: String {
        let minutes = focusSessions * 25
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours)h \(mins)m" : "\(mins)m"
    }
    
    func computeStreak(_ array: Array<DateComponents>) -> Int {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: .now)
        
        let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: .now)!
        var current = calendar.dateComponents([.year, .month, .day], from: yesterdayDate)
        
        let dates = Set(array)
        var streak: Int = 0
        
        while dates.contains(current) {
            streak += 1
            let date = calendar.date(from: current)!
            current = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: -1, to: date)!)
        }
        
        if dates.contains(today) {
            streak += 1
        }
        
        return streak
    }

    func load() {
        completedTasks = UserDefaults.standard.integer(forKey: "completedTasksCount")
        focusSessions = UserDefaults.standard.integer(forKey: "focusSessionsCount")
        let dates = UserDefaults.standard.getArray(DateComponents.self, forKey: "streakDates")
        streak = computeStreak(dates)
    }
}

