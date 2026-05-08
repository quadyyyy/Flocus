//
//  AccountView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 24.04.2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var statsRepository: StatsRepository
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationLink(destination: AccountInfoView()) {
                        AccountRowView()
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 15)
                    
                    
                    HStack {
                        Text("Your progress")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    
                    HStack(spacing: 10) {
                        StatCardView(
                            icon: "clock.fill",
                            iconColor: .blue,
                            title: "Focus time",
                            value: "\(viewModel.focusTimeFormatted)",
                            subtitle: "all time"
                        )
                        StatCardView(
                            icon: "checkmark",
                            iconColor: .orange,
                            title: "Tasks done",
                            value: "\(viewModel.completedTasks)",
                            subtitle: "all time"
                        )
                    }
                    Spacer()
                    HStack(spacing: 10) {
                        StatCardView(
                            icon: "lightbulb.min.fill",
                            iconColor: .green,
                            title: "Sessions",
                            value: "\(viewModel.focusSessions)",
                            subtitle: "completed"
                        )
                        StatCardView(
                            icon: "flame.fill",
                            iconColor: .red,
                            title: "Your streak",
                            value: "\(viewModel.streak)",
                            subtitle: "current"
                        )
                    }
                    .padding(.bottom, 15)
                    
                    HStack {
                        Text("Achievements")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack {
                        ForEach(viewModel.achievements) { achievement in
                            AchievementRowView(achievement: achievement)
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .background(Color(.systemGroupedBackground))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
            }
            .onAppear { viewModel.setup(statsRepository: statsRepository) }
            .navigationTitle("Account")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(StatsRepository())
}
