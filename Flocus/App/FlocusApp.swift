//
//  FlocusApp.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 17.04.2026.
//

import SwiftUI
import SwiftData

@main
struct FlocusApp: App {
    @StateObject private var statsRepository = StatsRepository()

    init() {
        if CommandLine.arguments.contains("--resetOnboarding") {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isOnboardingCompleted)
            UserDefaults.standard.set("", forKey: UserDefaultsKeys.username)
        }
        if CommandLine.arguments.contains("--skipOnboarding") {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isOnboardingCompleted)
            if (UserDefaults.standard.string(forKey: UserDefaultsKeys.username) ?? "").isEmpty {
                UserDefaults.standard.set("Tester", forKey: UserDefaultsKeys.username)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(statsRepository)
        }
        .modelContainer(for: TaskModel.self)
    }
}
