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
                // calendar view
                EmptyView()
            }
            
            Tab("Mindfulness", systemImage: "figure.mind.and.body") {
                // mindfulness view
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
