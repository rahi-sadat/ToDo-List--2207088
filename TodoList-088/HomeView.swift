//
//  HomeView.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var authService: AuthService

    @StateObject private var taskService = TaskService()

    @State private var activeSheet: ActiveSheet?
    @State private var showError = false
    @State private var errorMessage = ""

    private enum ActiveSheet: Identifiable {
        case add
        case edit(TaskModel)

        var id: String {
            switch self {
            case .add:
                return "add"
            case .edit(let task):
                return "edit-\(task.id)"
            }
        }
    }

    var body: some View {

        NavigationStack {

            List {

                if let message = taskService.errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                }

                if taskService.tasks.isEmpty {

                    VStack(spacing: 12) {

                        Image(systemName: "checklist")
                            .font(.system(size: 45))
                            .foregroundColor(.secondary)

                        Text("No Tasks Yet")
                            .font(.headline)

                        Text("Tap + to create your first task.")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowSeparator(.hidden)

                } else {

                    ForEach(taskService.tasks) { task in

                        HStack(spacing: 12) {

                            VStack(alignment: .leading, spacing: 7) {

                                Text(task.title)
                                    .font(.headline)

                                Text(task.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text(task.createdAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                ))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }

                            Spacer()

                            Button {
                                activeSheet = .edit(task)
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.borderless)

                            Button {
                                deleteTask(task)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding(.vertical, 7)
                    }
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button("Logout") {

                        do {
                            try authService.logout()
                        } catch {
                            showErrorMessage(error)
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in

                switch sheet {

                case .add:
                    AddTaskView(taskService: taskService)
                case .edit(let task):
                                    EditTaskView(
                                        task: task,
                                        taskService: taskService
                                    )
                                }
                            }
                            .alert("Error", isPresented: $showError) {
                                Button("OK", role: .cancel) { }
                            } message: {
                                Text(errorMessage)
                            }
                            .onAppear {
                                taskService.startListening()
                            }
                            .onDisappear {
                                taskService.stopListening()
                            }
                        }
                    }

                    private func deleteTask(_ task: TaskModel) {

                        taskService.deleteTask(taskId: task.id) { error in

                            if let error = error {
                                showErrorMessage(error)
                            }
                        }
                    }

                    private func showErrorMessage(_ error: Error) {
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                }
