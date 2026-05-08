//
//  NewTaskView.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 17.04.2026.
//

import SwiftUI
import SwiftData

struct NewTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String
    @State var description: String
    @State var dueDate: Date
    @State var selectedTag: Tags = .none
    
    var onSave: (TaskModel) -> Void

    
    var body: some View {
        NavigationStack {
            Form {
                Section("Essentials") {
                    TextField("Title", text: $title)
                    TextField("Details", text: $description)
                }
                
                Section("Information") {
                    DatePicker("Due Date", selection: $dueDate)
                }
                
                Section("Tag") {
                    Picker("Tag", selection: $selectedTag) {
                        Text(Tags.none.label).tag(Tags.none)
                        Text(Tags.home.label).tag(Tags.home)
                        Text(Tags.work.label).tag(Tags.work)
                        Text(Tags.study.label).tag(Tags.study)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let task = TaskModel(title: title, details: description, dueDate: dueDate, tag: selectedTag)
                        onSave(task)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    NewTaskView(title: "", description: "", dueDate: Date()) { _ in }
        .modelContainer(for: TaskModel.self, inMemory: true)
}
