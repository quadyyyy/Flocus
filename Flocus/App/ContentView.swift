//
//  ContentView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 17.04.2026.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(UserDefaultsKeys.isOnboardingCompleted) var isOnboardingCompleted: Bool = false
    var body: some View {
        if !isOnboardingCompleted {
            FirstOnboardingView()
        } else {
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
                
                Tab("Profile", systemImage: "person") {
                    ProfileView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
