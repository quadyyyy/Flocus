//
//  DetailedTaskPanel.swift
//  Flocus
//
//  Created by Timofei Kupriianov on 03.10.2026.
//

import SwiftUI
import SwiftData

struct DetailedTaskPanel: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: TaskModel
    @State private var saveError: String?
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case title, details
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Title", systemImage: "pencil")
                TextField("Task title", text: $task.title, axis: .vertical)
                    .font(.title.bold())
                    .focused($focusedField, equals: .title)
                    .accessibilityLabel("Task title")
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                fieldLabel("Tag", systemImage: "tag")
                Menu {
                    Picker("Tag", selection: $task.tag) {
                        ForEach(Tags.allCases, id: \.self) { tag in
                            Text(tag.label).tag(tag)
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(task.tag.label)
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.semibold))
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(task.tag.color)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(task.tag.color.opacity(0.12), in: Capsule())
                }
                .accessibilityLabel("Tag")
                .accessibilityValue(task.tag.label)
            }

            VStack(alignment: .leading, spacing: 12) {
                fieldLabel("Due date", systemImage: "calendar")
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 12) {
                        dateControl
                        timeControl
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        dateControl
                        timeControl
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("Details", systemImage: "text.alignleft")
                TextField("Add details…", text: $task.details, axis: .vertical)
                    .lineLimit(1...10)
                    .focused($focusedField, equals: .details)
                    .accessibilityLabel("Task details")
            }
        }
        .textFieldStyle(.plain)
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.primary.opacity(0.06), lineWidth: 1)
        }
        .onChange(of: task.title) { saveChanges() }
        .onChange(of: task.details) { saveChanges() }
        .onChange(of: task.tag) { saveChanges() }
        .onChange(of: task.dueDate) { saveChanges() }
        .onChange(of: task.persistentModelID) { focusedField = nil }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .alert("Couldn't save changes", isPresented: Binding(
            get: { saveError != nil },
            set: { if !$0 { saveError = nil } }
        )) {
            Button("Retry") { saveChanges() }
            Button("OK", role: .cancel) { }
        } message: {
            Text(saveError ?? "")
        }
    }

    private var dateControl: some View {
        DatePicker("Due date", selection: $task.dueDate, displayedComponents: .date)
            .labelsHidden()
            .datePickerStyle(.compact)
            .accessibilityLabel("Due date")
    }

    private var timeControl: some View {
        DatePicker("Due time", selection: $task.dueDate, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(.compact)
            .accessibilityLabel("Due time")
    }

    private func fieldLabel(_ title: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .frame(width: 20, alignment: .center)
            Text(title)
        }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.secondary)
    }

    private func saveChanges() {
        do {
            try modelContext.save()
            saveError = nil
        } catch {
            saveError = error.localizedDescription
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: TaskModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let task = TaskModel(title: "Read a book", details: "", dueDate: .now, tag: .study)
    container.mainContext.insert(task)
    return NavigationStack {
        ScrollView {
            DetailedTaskPanel(task: task)
                .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    .modelContainer(container)
}
