//
//  PomodoroView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 24.04.2026.
//

import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject private var statsRepository: StatsRepository
    @StateObject private var viewModel = PomodoroViewModel()
    @State private var showsTasks = false

    @ScaledMetric(relativeTo: .body) private var minimumPanelWidth = 300

    var body: some View {
        NavigationStack {
            adaptiveLayout
            .sheet(isPresented: $showsTasks) {
                NavigationStack {
                    taskPanel
                        .navigationTitle("Tasks")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close", systemImage: "xmark") {
                                    showsTasks = false
                                }
                            }
                        }
                        .background(Color(.systemGroupedBackground))
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            viewModel.setup(statsRepository: statsRepository)
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
                    .splitArrangementLayoutSize(minWidth: minimumPanelWidth)
                    .layoutPriority(1)
            } secondary: {
                taskPanel
                    .splitArrangementLayoutSize(minWidth: minimumPanelWidth)
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        } else {
            timerPanel
        }
    }

    private var tasksButton: some View {
        Button("Tasks", systemImage: "list.bullet.rectangle") {
            showsTasks = true
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
        VStack(alignment: .leading, spacing: 24) {
            Text("Tasks")
                .font(.title3.bold())
            ScrollView {
                VStack(spacing: 12) {
//                    placeholderTask("Write summary notes", tag: "Study", icon: "graduationcap.fill", color: .orange)
//                    placeholderTask("Clean the apartment", tag: "Home", icon: "house.fill", color: .green)
//                    placeholderTask("Review pull requests", tag: "Work", icon: "briefcase.fill", color: .blue)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

    }

//    private func placeholderTask(_ title: String, tag: String, icon: String, color: Color) -> some View {
//        HStack(spacing: 18) {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundStyle(color)
//                .frame(width: 32)
//            VStack(alignment: .leading, spacing: 6) {
//                Text(title)
//                    .font(.body.weight(.medium))
//                Text(tag)
//                    .font(.caption)
//                    .foregroundStyle(color)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 3)
//                    .background(color.opacity(0.14), in: Capsule())
//            }
//            Spacer(minLength: 4)
//            Image(systemName: "circle")
//                .font(.title3)
//                .foregroundStyle(.tertiary)
//        }
//        .padding(18)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
//        .accessibilityElement(children: .combine)
//        .accessibilityHint("Sample task")
//    }

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
                    .foregroundStyle(.blue)
                    .frame(minWidth: 100, minHeight: 56)
                    .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PomodoroView()
        .environmentObject(StatsRepository())
}
