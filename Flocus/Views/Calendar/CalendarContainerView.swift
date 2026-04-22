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
    @StateObject var todayViewModel = TodayViewModel()
    @State var isSheetPresented: Bool = false
    
    var body: some View {
        CalendarView(viewModel: viewmodel, tasks: tasks)
            .onAppear {
                viewmodel.reloadTasks(tasks)
            }
            .onDisappear {
                viewmodel.selectedDate = nil
            }
            .onChange(of: tasks) {
                viewmodel.reloadTasks(tasks)
            }
            .sheet(item: $viewmodel.selectedDate) { date in
                SelectedDateView(selectedDate: date, viewModel: todayViewModel)
            }
    }
}

#Preview {
    CalendarContainerView()
}
