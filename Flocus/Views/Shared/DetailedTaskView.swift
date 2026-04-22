//
//  DetailedTaskView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 22.04.2026.
//

import SwiftUI
import SwiftData

struct DetailedTaskView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var task: TaskModel
    
    var body: some View {
        Form {
            Section("Essentials") {
                TextField("Title", text: $task.title)
                TextField("Details", text: $task.details)
            }

            Section("Information") {
                DatePicker("Due Date", selection: $task.dueDate)
            }

            Section("Tag") {
                Picker("Tag", selection: $task.tag) {
                    Text(Tags.none.rawValue).tag(Tags.none)
                    Text(Tags.home.rawValue).tag(Tags.home)
                    Text(Tags.work.rawValue).tag(Tags.work)
                    Text(Tags.study.rawValue).tag(Tags.study)
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    try? modelContext.save()
                } label: {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
        }
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
