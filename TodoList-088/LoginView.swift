//
//  LoginView.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authService: AuthService

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 22) {

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 65))
                    .foregroundColor(.blue)

                Text("TodoList")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Sign in to manage your tasks")
                    .foregroundColor(.secondary)

                VStack(spacing: 15) {

                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: login) {

                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Login")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                NavigationLink("Create New Account") {
                    RegisterView()
                }

                Spacer()
            }
            .padding(25)
            .navigationTitle("Welcome")
        }
    }

    private func login() {

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        isLoading = true
        errorMessage = ""

        authService.login(
            email: cleanEmail,
            password: password
        ) { error in

            isLoading = false

            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
}
