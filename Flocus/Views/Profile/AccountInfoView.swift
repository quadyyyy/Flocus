//
//  AccountInfoView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 30.04.2026.
//

import SwiftUI

struct AccountInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var alertIsPresented: Bool = false
    @AppStorage("username") var username: String = "User"

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Image("placeholderAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Spacer()
                Button {
                    // TODO: - add avatar change
                } label: {
                    Text("Edit avatar")
                }

                Form {
                    Section("Name") {
                        TextField("Your name", text: $username)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Button {
                        alertIsPresented = true
                    } label: {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                )
                            Text("Reset All Data")
                                .foregroundStyle(.red)
                                .font(.body)
                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)

                    Text("This will permanently erase your tasks, focus history, and achievements from this device.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
                .padding()

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Danger zone", isPresented: $alertIsPresented) {
                Button(role: .destructive) {
                    StatsRepository().resetAll()
                    TaskRepository(context: modelContext).deleteAll()
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("Are you sure you want to reset all data?")
            }
        }
    }
}

#Preview {
    AccountInfoView()
}

