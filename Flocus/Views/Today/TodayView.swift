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
    @State private var selectedTask: TaskModel?

    @ScaledMetric(relativeTo: .body) private var minimumPanelWidth = 300

    let testingID = UIIdentifiers.TodayView.self

    var body: some View {
        NavigationStack {
            adaptiveLayout
                .navigationTitle("What's up for today?")
                .navigationDestination(for: TaskModel.self) { task in
                    DetailedTaskView(task: task)
                }
                .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            viewModel.setup(repository: TaskRepository(context: modelContext), statsRepository: statsRepository)
        }
    }

    @ViewBuilder
    private var adaptiveLayout: some View {
        if #available(iOS 27.1, *) {
            ArrangementView {
                tasksPanel
                    .splitArrangementLayoutSize(minWidth: minimumPanelWidth)
                    .layoutPriority(1)
            } secondary: {
                detailsPanel
                    .padding(.leading, 16)
                    .splitArrangementLayoutSize(minWidth: minimumPanelWidth)
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        } else {
            tasksPanel
        }
    }

    private var tasksPanel: some View {
        List {
            Section {
                TodoCardView(tasks: viewModel.tasks, streak: viewModel.streak)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            ForEach(viewModel.tasks) { task in
                if #available(iOS 27.1, *) {
                    AdaptiveTodayTaskRow(task: task, selectedTask: $selectedTask) {
                        viewModel.toggleTask(task)
                    }
                } else {
                    NavigationLink(value: task) {
                        TaskRowView(task: task) {
                            viewModel.toggleTask(task)
                        }
                    }
                }
            }
            .onDelete { indexSet in
                let tasksToDelete = indexSet.map { viewModel.tasks[$0] }
                for task in tasksToDelete {
                    if selectedTask == task { selectedTask = nil }
                    viewModel.deleteTask(task)
                }
            }
        }
        .listStyle(.insetGrouped)
        .listSectionSpacing(.compact)
        .toolbar {
            if #available(iOS 27.1, *) {
                ToolbarItem(placement: .topBarPinnedTrailing) {
                    newTaskButton
                }
            } else {
                ToolbarItem(placement: .topBarTrailing) {
                    newTaskButton
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            NewTaskView(title: "", description: "", dueDate: Date()) { task in
                viewModel.addTask(task)
            }
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

    private var newTaskButton: some View {
        Button("New task", systemImage: "plus") {
            isSheetPresented = true
        }
        .accessibilityIdentifier(testingID.newTaskButton)
    }

    private var detailsPanel: some View {
        Group {
            if let selectedTask {
                List {
                    Section {
                        DetailedTaskPanel(task: selectedTask)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.insetGrouped)
                .listSectionSpacing(.compact)
                .scrollDismissesKeyboard(.interactively)
            } else {
                ContentUnavailableView("Select a task", systemImage: "checklist",
                                       description: Text("Task details will appear here."))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// Read the arrangement environment inside its content, where SwiftUI supplies the axis.
@available(iOS 27.1, *)
private struct AdaptiveTodayTaskRow: View {
    @Environment(\.splitArrangementAxis) private var splitAxis
    let task: TaskModel
    @Binding var selectedTask: TaskModel?
    let onToggle: () -> Void

    var body: some View {
        if splitAxis == .horizontal {
            Button {
                selectedTask = task
            } label: {
                TaskRowView(task: task, onToggle: onToggle)
            }
            .buttonStyle(.plain)
            .listRowBackground(selectedTask == task
                               ? Color.accentColor.opacity(0.12)
                               : Color(.secondarySystemGroupedBackground))
        } else {
            NavigationLink(value: task) {
                TaskRowView(task: task, onToggle: onToggle)
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
