//
//  TaskModel.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import Foundation
import FirebaseFirestore

struct TaskModel: Identifiable {

    var id: String
    var title: String
    var description: String
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard
            let title = data["title"] as? String,
            let description = data["description"] as? String
        else {
            return nil
        }

        self.id = document.documentID
        self.title = title
        self.description = description

        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}
