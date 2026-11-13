//
//  TaskService.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class TaskService: ObservableObject {

    @Published var tasks: [TaskModel] = []
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // Get the logged-in user's task collection
    private func currentTasksCollection() throws -> CollectionReference {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(
                domain: "TaskService",
                code: 401,
                userInfo: [
                    NSLocalizedDescriptionKey:
                    "Please log in first."
                ]
            )
        }

        return db.collection("users")
            .document(uid)
            .collection("tasks")
    }

    // READ: Listen for the user's tasks
    func startListening() {

        stopListening()

        do {
            let collection = try currentTasksCollection()

            listener = collection
                .order(by: "createdAt", descending: true)
                .addSnapshotListener { [weak self] snapshot, error in

                    DispatchQueue.main.async {

                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                            return
                        }

                        self?.errorMessage = nil

                        self?.tasks = snapshot?.documents.compactMap {
                            TaskModel(document: $0)
                        } ?? []
                    }
                }

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // CREATE: Add a new task
    func addTask(
        title: String,
        description: String,
        completion: @escaping (Error?) -> Void
    ) {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanDescription = description.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty, !cleanDescription.isEmpty else {
            let error = NSError(
                domain: "TaskService",
                code: 400,
                userInfo: [
                    NSLocalizedDescriptionKey:
                    "Title and description are required."
                ]
            )

            completion(error)
            return
        }

        do {
            let collection = try currentTasksCollection()

            let data: [String: Any] = [
                "title": cleanTitle,
                "description": cleanDescription,
                "createdAt": FieldValue.serverTimestamp()
            ]

            collection.addDocument(data: data) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }

        } catch {
            completion(error)
        }
    }

    // UPDATE: Edit an existing task
    func updateTask(
        task: TaskModel,
        title: String,
        description: String,
        completion: @escaping (Error?) -> Void
    ) {

        let cleanTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanDescription = description.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanTitle.isEmpty, !cleanDescription.isEmpty else {
            let error = NSError(
                domain: "TaskService",
                code: 400,
                userInfo: [
                    NSLocalizedDescriptionKey:
                    "Title and description are required."
                ]
            )

            completion(error)
            return
        }

        do {
            let collection = try currentTasksCollection()

            collection.document(task.id).updateData([
                "title": cleanTitle,
                "description": cleanDescription
            ]) { error in
DispatchQueue.main.async {
                    completion(error)
                }
            }

        } catch {
            completion(error)
        }
    }

    // DELETE: Remove a task
    func deleteTask(
        taskId: String,
        completion: @escaping (Error?) -> Void
    ) {

        do {
            let collection = try currentTasksCollection()

            collection.document(taskId).delete { error in

                DispatchQueue.main.async {
                    completion(error)
                }
            }

        } catch {
            completion(error)
        }
    }

    // Stop listening when the user logs out
    func stopListening() {
        listener?.remove()
        listener = nil
        tasks = []
    }

    deinit {
        listener?.remove()
    }
}
