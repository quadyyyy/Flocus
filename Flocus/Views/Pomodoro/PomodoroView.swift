//
//  PomodoroView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 24.04.2026.
//

import SwiftUI
import SwiftData

struct PomodoroView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var statsRepository: StatsRepository
    @StateObject private var viewModel = PomodoroViewModel()
    @State private var isNewTaskPresented = false

    var body: some View {
        NavigationStack {
            adaptiveLayout
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
                .tint(.blue)
                .navigationDestination(for: TaskModel.self) { task in
                    DetailedTaskView(task: task)
                }
        }
        .onAppear {
            viewModel.setup(repository: TaskRepository(context: modelContext), statsRepository: statsRepository)
        }
        .onChange(of: viewModel.phase) {
            viewModel.reset()
        }
    }

    @ViewBuilder
    private var adaptiveLayout: some View {
        if #available(iOS 27.1, *) {
            ArrangementView {
                timerPanel
                    .layoutPriority(1)
            } secondary: {
                taskPanel
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        } else {
            timerPanel
        }
    }


    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pomodoro")
                .font(.largeTitle.bold())
            Picker("Phase", selection: $viewModel.phase) {
                Text(PomodoroPhase.focus.label).tag(PomodoroPhase.focus)
                Text(PomodoroPhase.shortBreak.label).tag(PomodoroPhase.shortBreak)
                Text(PomodoroPhase.longBreak.label).tag(PomodoroPhase.longBreak)
            }
            .pickerStyle(.segmented)

        }
    }

    private var taskPanel: some View {
        VStack(spacing: 20) {
            HStack(alignment: .firstTextBaseline) {
                Text("Tasks")
                    .font(.largeTitle.bold())
                Spacer()
                Button("New task", systemImage: "plus") {
                    isNewTaskPresented = true
                }
                .font(.headline)
                .foregroundStyle(.tint)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)

            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink(value: task) {
                        TaskRowView(task: task) {
                            viewModel.toggleTask(task)
                        }
                    }
                }
                .onDelete { indexSet in
                    let tasksToDelete = indexSet.map { viewModel.tasks[$0] }
                    for task in tasksToDelete {
                        viewModel.deleteTask(task)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .listSectionSpacing(.compact)
            .scrollContentBackground(.hidden)
            .contentMargins(.top, 0, for: .scrollContent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $isNewTaskPresented) {
            NewTaskView(title: "", description: "", dueDate: Date()) { task in
                viewModel.addTask(task)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } })
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var timerPanel: some View {
        VStack(spacing: 20) {
            header
                .frame(maxWidth: .infinity, alignment: .leading)
            GeometryReader { geometry in
                let diameter = max(0, min(geometry.size.width - 12, geometry.size.height - 12))
                timerFace(diameter: diameter)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            controls
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    private func timerFace(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Color.pomodoroGray, lineWidth: 15)
            if viewModel.progress > 0 {
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(viewModel.phaseColor(), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: viewModel.progress)
            }
            VStack(spacing: 10) {
                Text(viewModel.phase.label.uppercased())
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .tracking(2)
                Text(viewModel.timeString)
                    .font(.system(size: min(62, diameter * 0.19), weight: .bold))
                    .monospacedDigit()
                Text(viewModel.isRunning ? "Stay with it" : "Ready when you are")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .minimumScaleFactor(0.6)
        }
        .frame(width: diameter, height: diameter)
        .accessibilityElement(children: .combine)
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                if viewModel.isRunning {
                    viewModel.pause()
                } else {
                    viewModel.start()
                }
            } label: {
                Text(viewModel.isRunning ? "Pause" : "Start focus")
                    .font(.headline)
                    .foregroundStyle(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
                    .background(Color.primary, in: RoundedRectangle(cornerRadius: 16))
            }
            Button {
                viewModel.reset()
            } label: {
                Text("Reset")
                    .font(.headline)
                    .foregroundStyle(.tint)
                    .frame(minWidth: 100, minHeight: 56)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PomodoroView()
        .modelContainer(for: TaskModel.self, inMemory: true)
        .environmentObject(StatsRepository())
}
