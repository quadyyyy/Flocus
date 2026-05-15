//
//  TodayView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 17.04.2026.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var statsRepository: StatsRepository
    @StateObject private var viewModel = TodayViewModel()
    @State private var isSheetPresented = false
    
    let testingID = UIIdentifiers.TodayView.self
        
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TodoCardView(tasks: viewModel.tasks, streak: viewModel.streak)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
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
            .listSectionSpacing(.compact)
            .navigationTitle("What's up for today?")
            .onAppear {
                viewModel.setup(repository: TaskRepository(context: modelContext), statsRepository: statsRepository)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier(testingID.newTaskButton)
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                NewTaskView(title: "", description: "", dueDate: Date()) { task in
                    viewModel.addTask(task)}
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
    context.insert(TaskModel(title: "Buy groceries", details: "Milk, eggs, bread", dueDate: Date(), tag: .home))
    context.insert(TaskModel(title: "Finish report", details: "", dueDate: Date(), tag: .work))
    context.insert(TaskModel(title: "Read Swift docs", details: "", dueDate: Date(), tag: .study))
    return TodayView()
        .modelContainer(container)
        .environmentObject(StatsRepository())
}
