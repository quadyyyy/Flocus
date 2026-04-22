//
//  ContentView.swift
//  Flocus
//
//  Created by Куприянов Тимофей on 17.04.2026.
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
                // pomodoro view
                EmptyView()
            }
            
            Tab("Account", systemImage: "person") {
                // account view
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
