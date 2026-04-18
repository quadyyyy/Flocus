//
//  FlocusApp.swift
//  Flocus
//
//  Created by Куприянов Тимофей on 17.04.2026.
//

import SwiftUI
import SwiftData

@main
struct FlocusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskModel.self)
    }
}
