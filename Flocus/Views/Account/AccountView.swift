//
//  AccountView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 24.04.2026.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("completedTasksCount") private var completedCount: Int = 0
    var body: some View {
        VStack {
            Text("Completed tasks \(completedCount)")
        }
    }
}

#Preview {
    AccountView()
}
