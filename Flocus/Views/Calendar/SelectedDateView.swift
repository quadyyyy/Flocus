//
//  SelectedDateView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 21.04.2026.
//

import SwiftUI
import SwiftData

struct SelectedDateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var statsRepository: StatsRepository
    var selectedDate: SelectedDate
    @StateObject private var viewModel = SelectedDateViewModel()
    @State var isAddingTask = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task) {
                            viewModel.toggleTask(task)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.deleteTask(viewModel.tasks[$0]) }
                }
            }
            .navigationTitle(selectedDate.date.formatted(.dateTime.day().month(.wide)))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.setup(repository: TaskRepository(context: modelContext), statsRepository: statsRepository, date: selectedDate.date)
            }
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
                    viewModel.addTask(task)
                    isAddingTask = false
                }
            }
            .navigationDestination(for: TaskModel.self) { task in
                DetailedTaskView(task: task)
            }
            .alert("Error", isPresented: Binding (
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } })
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
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
    return SelectedDateView(selectedDate: SelectedDate(date: today))
        .modelContainer(container)
}
