//
//  CalendarView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 20.04.2026.
//

import SwiftData
import SwiftUI
import UIKit

struct CalendarView: UIViewRepresentable {
    @ObservedObject var viewModel: CalendarViewModel
    var tasks: [TaskModel]
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .default
        calendarView.delegate = context.coordinator
        calendarView.setContentHuggingPriority(.defaultLow, for: .vertical)
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection
        
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.viewModel.reloadTasks(tasks)
        let newDates = tasks.map { Calendar.current.dateComponents([.year, .month, .day], from: $0.dueDate) }
        let datesToReload = Array(Set(newDates + context.coordinator.previousDates))
        context.coordinator.previousDates = newDates
        uiView.reloadDecorations(forDateComponents: datesToReload, animated: false)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var viewModel: CalendarViewModel
        var previousDates: [DateComponents] = []
        
        init(viewModel: CalendarViewModel) {
            self.viewModel = viewModel
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let tasks = viewModel.tasks(for: dateComponents)
            guard !tasks.isEmpty else { return nil }
            
            return .customView {
                let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 20, height: 6))
                stack.axis = .horizontal
                stack.spacing = 2
                
                for task in tasks {
                    let dot = UIView()
                    dot.translatesAutoresizingMaskIntoConstraints = false
                    dot.backgroundColor = UIColor(task.tag.color)
                    dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
                    dot.heightAnchor.constraint(equalToConstant: 6).isActive = true
                    dot.layer.cornerRadius = 3
                    stack.addArrangedSubview(dot)
                }
                return stack
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents else { return }
            if let date = Calendar.current.date(from: dateComponents) {
                viewModel.selectedDate = SelectedDate(date: date)
            }
        }
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    let tasks = [
        TaskModel(title: "Task 1", details: "", dueDate: Date(), tag: .work),
        TaskModel(title: "Task 2", details: "", dueDate: Date(), tag: .home),
        TaskModel(title: "Task 3", details: "", dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, tag: .study),
        TaskModel(title: "Task 4", details: "", dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!, tag: .none)
    ]
    CalendarView(viewModel: viewModel, tasks: tasks)
}
