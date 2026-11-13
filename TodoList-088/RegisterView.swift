//
//  RegisterView.swift
//  TodoList-088
//
//  Created by Rahi Sadat Ruhan on 13/11/2026.
//

import SwiftUI

struct RegisterView: View {

    @EnvironmentObject var authService: AuthService

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {

        VStack(spacing: 20) {

            Spacer()

            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email Address", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: register) {

                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Register")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            Spacer()
        }
        .padding(25)
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func register() {

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanEmail.isEmpty else {
            errorMessage = "Please enter your email."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must contain at least 6 characters."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true
        errorMessage = ""

        authService.register(
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
