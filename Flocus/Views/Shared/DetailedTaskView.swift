//
//  DetailedTaskView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 22.04.2026.
//

import SwiftUI
import SwiftData

struct DetailedTaskView: View {
    @Bindable var task: TaskModel

    var body: some View {
        ScrollView {
            if #available(iOS 27.1, *) {
                DetailedTaskPanel(task: task)
                    .contentMargins(for: .container)
            } else {
                DetailedTaskPanel(task: task)
                    .padding(20)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Task details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskModel.self, configurations: config)
    let task = TaskModel(title: "Buy groceries", details: "Milk, eggs, bread", dueDate: Date(), tag: .home)
    container.mainContext.insert(task)
    return NavigationStack {
        DetailedTaskView(task: task)
    }
    .modelContainer(container)
}
