//
//  TaskModel.swift
//  Flocus
//
//  Created by Куприянов Тимофей on 18.04.2026.
//

import Foundation
import SwiftData
import SwiftUI

enum Tags: String, CaseIterable, Hashable, Codable {
    case none = "🚫 None"
    case home = "🏠 Home"
    case work = "🫡 Work"
    case study = "📚 Study"
    
    var color: Color {
        switch self {
        case .none: .gray
        case .home: .green
        case .work: .blue
        case .study: .orange
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
