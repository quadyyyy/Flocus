//
//  AccountRowView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 01.05.2026.
//

import SwiftUI

struct AccountRowView: View {
    @AppStorage("username") var userName: String = "User"
    
    var body: some View {
        HStack(spacing: 14) {
            Image("placeholderAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text("\(userName)")
                    .font(.title3).bold()
                Text("Edit your profile")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    AccountRowView()
}
