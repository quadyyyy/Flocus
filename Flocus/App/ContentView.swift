//
//  ContentView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 17.04.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Today", systemImage: "list.bullet.rectangle") {
                TodayView()
            }
            
            Tab("Calendar", systemImage: "calendar") {
                CalendarContainerView()
            }
            
            Tab("Pomodoro", systemImage: "timer") {
                PomodoroView()
            }
            
            Tab("Account", systemImage: "person") {
                AccountView()
            }
        }
    }
}

#Preview {
    ContentView()
}
