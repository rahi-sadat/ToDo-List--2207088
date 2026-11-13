//
//  AuthService.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import Foundation
import FirebaseAuth
import Combine

final class AuthService: ObservableObject {

    @Published var user: User?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser

        authStateHandle = Auth.auth().addStateDidChangeListener {
            [weak self] _, user in

            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }

    func register(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { [weak self] result, error in

            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }

                self?.user = result?.user
                completion(nil)
            }
        }
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { [weak self] result, error in

            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }

                self?.user = result?.user
                completion(nil)
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
        user = nil
    }
}
