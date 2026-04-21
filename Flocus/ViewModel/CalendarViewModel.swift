//
//  CalendarViewModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 21.04.2026.
//

import Foundation
import Combine
import SwiftData

struct SelectedDate: Identifiable {
    let id = UUID()
    let date: Date
}

class CalendarViewModel: ObservableObject {
    var taskByDate: [DateComponents: [TaskModel]] = [:]
    @Published var selectedDate: SelectedDate? = nil
    
    
    func reloadTasks(_ tasks: [TaskModel]) {
        taskByDate = Dictionary(grouping: tasks, by: { task in
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: task.dueDate)
            return DateComponents(year: comps.year, month: comps.month, day: comps.day)
        })
    }
    
    func tasks(for dateComponents: DateComponents) -> [TaskModel] {
        let key = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day)
        return taskByDate[key] ?? []
    }
}
