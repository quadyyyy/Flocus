//
//  TaskRowView.swift
//  Flocus
//
//  Created by Куприянов Тимофей on 17.04.2026.
//

import SwiftUI
import SwiftData

struct TaskRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: TaskModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isCompleted ? .green : .secondary)
                .font(.title2)
                .onTapGesture {
                    task.isCompleted.toggle()
                    try? modelContext.save()
                }
                .animation(.easeInOut(duration: 0.2), value: task.isCompleted)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)

                HStack(spacing: 4) {
                    Text(task.dueDate, style: .date)
                    Text(task.dueDate, style: .time)
                }
                .font(.caption)
                .foregroundStyle(task.dueDate < .now ? .red : .secondary)
            }
            Spacer()
            Text("\(task.tag.rawValue)")
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(task.tag.color)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let task1 = TaskModel(title: "title 1", details: "", dueDate: Date(), tag: .home)
    let task2 = TaskModel(title: "title 2", details: "", dueDate: Date(), tag: .work)
    VStack {
        TaskRowView(task: task1)
        TaskRowView(task: task2)
    }
    .padding()
}
