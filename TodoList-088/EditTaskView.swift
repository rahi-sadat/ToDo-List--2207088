//
//  EditTaskView.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import SwiftUI

struct EditTaskView: View {

    let task: TaskModel

    @ObservedObject var taskService: TaskService

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var description: String

    @State private var errorMessage = ""
    @State private var isSaving = false

    init(task: TaskModel, taskService: TaskService) {

        self.task = task
        self.taskService = taskService

        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Edit Task") {

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
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {

                    Button("Update") {
                        updateTask()
                    }
                    .disabled(isSaving)
                }
            }
        }
    }

    private func updateTask() {

        isSaving = true
        errorMessage = ""

        taskService.updateTask(
            task: task,
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
