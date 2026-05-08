//
//  AvatarPickerView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 06.05.2026.
//

import SwiftUI

struct AvatarPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(UserDefaultsKeys.avatar) var avatar: String = "avatar1"
    let avatars: Array<String> = ["avatar1", "avatar2", "avatar3", "avatar4", "avatar5", "avatar6"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        NavigationStack {
            VStack {
                Image(avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.bottom, 150)
                Text("Choose the avatar below")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(avatars, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: avatar == name ? 3 : 0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: avatar)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    avatar = name
                                }
                            }
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "multiply")
                        }
                    }
                }
                .navigationTitle("Avatar Selection")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    AvatarPickerView()
}
