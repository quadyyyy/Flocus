//
//  CalendarContainerView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 21.04.2026.
//

import SwiftUI
import SwiftData

struct CalendarContainerView: View {
    @Query var tasks: [TaskModel]
    @StateObject var viewmodel = CalendarViewModel()
    
    var body: some View {
        adaptiveLayout
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onDisappear {
                viewmodel.selectedDate = nil
            }
    }
    
    @ViewBuilder
    private var adaptiveLayout: some View {
        if #available(iOS 27.1, *) {
            ArrangementView {
                AdaptiveCalendarPanel(selectedDate: $viewmodel.selectedDate) {
                    calendarPanel
                }
                .layoutPriority(1)
            } secondary: {
                selectedDatePanel
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        }
        else {
            calendarPanel
                .sheet(item: $viewmodel.selectedDate) { date in
                    SelectedDateView(selectedDate: date)
                }
        }
    }

    private var selectedDatePanel: some View {
        Group {
            if let date = viewmodel.selectedDate {
                SelectedDateView(selectedDate: date, showsDismissButton: false)
                    .id(date.id)
            } else {
                ContentUnavailableView("Select a date", systemImage: "calendar",
                                       description: Text("Tasks for the selected day will appear here."))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var calendarPanel: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Calendar")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            CalendarView(viewModel: viewmodel, tasks: tasks)
                .onAppear {
                    viewmodel.reloadTasks(tasks)
                }
                .onChange(of: tasks) {
                    viewmodel.reloadTasks(tasks)
                }
                .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// read the axis inside arrangementview so presentation follows its actual layout
@available(iOS 27.1, *)
private struct AdaptiveCalendarPanel<Content: View>: View {
    @Environment(\.splitArrangementAxis) private var splitAxis
    @Binding var selectedDate: SelectedDate?
    @ViewBuilder let content: Content

    var body: some View {
        if splitAxis == .horizontal {
            content
        } else {
            content.sheet(item: Binding(
                get: { selectedDate },
                set: { date in
                    if splitAxis != .horizontal {
                        selectedDate = date
                    }
                }
            )) { date in
                SelectedDateView(selectedDate: date)
            }
        }
    }
}

#Preview {
    CalendarContainerView()
        .modelContainer(for: TaskModel.self, inMemory: true)
        .environmentObject(StatsRepository())
}
