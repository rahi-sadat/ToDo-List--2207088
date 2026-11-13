import SwiftUI
import FirebaseCore

@main
struct MyApp: App {

    @StateObject private var authService: AuthService

    init() {
        FirebaseApp.configure()

        _authService = StateObject(
            wrappedValue: AuthService()
        )
    }

    var body: some Scene {

        WindowGroup {

            ContentView()
                .environmentObject(authService)
        }
    }
}
