//
//  SelectedDateView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 21.04.2026.
//

import SwiftUI
import SwiftData

// TODO: - Add viewmodel
struct SelectedDateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var selectedDate: SelectedDate
    var allTasks: [TaskModel]
    @State var isAddingTask = false

    var tasksForDate: [TaskModel] {
        allTasks.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate.date) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasksForDate) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { modelContext.delete(tasksForDate[$0]) }
                    try? modelContext.save()
                }
            }
            .navigationTitle(selectedDate.date.formatted(.dateTime.day().month(.wide)))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $isAddingTask) {
                NewTaskView(title: "", description: "", dueDate: selectedDate.date) { task in
                    modelContext.insert(task)
                    try? modelContext.save()
                    isAddingTask = false
                }
            }
            .navigationDestination(for: TaskModel.self) { task in
                DetailedTaskView(task: task)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: TaskModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    let today = Date()
    context.insert(TaskModel(title: "Buy groceries", details: "Milk, eggs", dueDate: today, tag: .home))
    context.insert(TaskModel(title: "Finish report", details: "", dueDate: today, tag: .work))
    context.insert(TaskModel(title: "Read Swift docs", details: "", dueDate: today, tag: .study))
    let tasks = try! context.fetch(FetchDescriptor<TaskModel>())
    return SelectedDateView(selectedDate: SelectedDate(date: today), allTasks: tasks)
        .modelContainer(container)
}
