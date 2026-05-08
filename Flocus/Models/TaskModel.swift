//
//  TaskModel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 18.04.2026.
//

import Foundation
import SwiftData
import SwiftUI

enum Tags: String, CaseIterable, Hashable, Codable {
    case none
    case home
    case work
    case study
    
    var color: Color {
        switch self {
        case .none: .gray
        case .home: .green
        case .work: .blue
        case .study: .orange
        }
    }
    
    var label: String {
        switch self {
        case .none: "🚫 None"
        case .home: "🏠 Home"
        case .work: "🫡 Work"
        case .study: "📚 Study"
        }
    }
}

@Model
class TaskModel {
    var title: String
    var details: String
    var dueDate: Date
    var isCompleted: Bool
    var tag: Tags

    init(title: String, details: String, dueDate: Date, isCompleted: Bool = false, tag: Tags = .none) {
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.tag = tag
    }
}
