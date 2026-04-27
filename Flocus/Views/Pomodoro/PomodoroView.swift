//
//  PomodoroView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 24.04.2026.
//

import SwiftUI

struct PomodoroView: View {
    @StateObject var viewModel = PomodoroViewModel()
    @State private var timerStarted = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Pomodoro")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 5)
            
            Picker("Phase",selection: $viewModel.phase) {
                Text(PomodoroPhase.focus.label).tag(PomodoroPhase.focus)
                Text(PomodoroPhase.shortBreak.label).tag(PomodoroPhase.shortBreak)
                Text(PomodoroPhase.longBreak.label).tag(PomodoroPhase.longBreak)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .foregroundStyle(.pomodoroGray)
                
                // visual bug with trim partly filled fix
                if timerStarted {
                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(viewModel.phaseColor(), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: viewModel.progress)
                }
                
                VStack(spacing: 6) {
                    Text(viewModel.phase.label.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .tracking(2)
                    
                    Text(viewModel.timeString)
                        .font(.system(size: 62, weight: .bold))
                    
                    Text(viewModel.isRunning ? "Stay with it" : "Ready when you are")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 55)
            .padding(.top, 24)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    if viewModel.isRunning {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                        timerStarted = true
                    }
                } label: {
                    Text(viewModel.isRunning ? "Pause" : "Start focus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color.primary.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }

                Button {
                    viewModel.reset()
                    timerStarted = false
                } label: {
                    Text("Reset")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 100, height: 58)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .onChange(of: viewModel.phase) {
            viewModel.reset()
            timerStarted = false
        }
    }
}

#Preview {
    PomodoroView()
}
