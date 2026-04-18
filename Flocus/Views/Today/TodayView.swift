//
//  TodayView.swift
//  Flocus
//
//  Created by Куприянов Тимофей on 17.04.2026.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = TodayViewModel()
    @State var isSheetPresented = false
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks) { task in
                    TaskRowView(task: task)
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.deleteTask(viewModel.tasks[$0]) }
                }
            }
            .navigationTitle("What's up for today?")
            .onAppear {
                viewModel.setup(repository: TaskRepository(context: modelContext))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                NewTaskView(title: "", description: "", dueDate: Date()) { task in
                    viewModel.addTask(task)}
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
}
