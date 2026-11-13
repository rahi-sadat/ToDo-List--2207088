//
//  AddTaskView.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import SwiftUI

struct AddTaskView: View {

    @ObservedObject var taskService: TaskService

    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var errorMessage = ""
    @State private var isSaving = false

    var body: some View {

        NavigationStack {

            Form {

                Section("Task Information") {

                    TextField("Task Title", text: $title)

                    TextField(
                        "Task Description",
                        text: $description,
                        axis: .vertical
                    )
                    .lineLimit(4...8)
                }

                if !errorMessage.isEmpty {

                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {

                    Button("Save") {
                        saveTask()
                    }
                    .disabled(isSaving)
                }
            }
        }
    }

    private func saveTask() {

        isSaving = true
        errorMessage = ""

        taskService.addTask(
            title: title,
            description: description
        ) { error in

            isSaving = false

            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                dismiss()
            }
        }
    }
}
