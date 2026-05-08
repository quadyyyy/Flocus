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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(statsRepository)
        }
        .modelContainer(for: TaskModel.self)
    }
}
