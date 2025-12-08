//
//  SessionViewModel.swift
//  applixy
//
//  Created by Parissa Teli on 12/7/25.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var isLoadingUser: Bool = false
    
    /// Set to `true` when an **existing user** logs in from the login screen.
    /// RootView uses this to skip the General Info onboarding step.
    @Published var justLoggedInExistingUser: Bool = false

    // Optional: keep handle so you could remove the listener later if needed
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        // In SwiftUI previews, don't touch Firebase or start listeners
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("SessionViewModel: Running in previews — skipping Firebase setup.")
            return
        }

        // Normal app launch: begin listening for authentication changes
        listenToAuthState()
    }

    deinit {
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    private func listenToAuthState() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                // Load the Firestore user document whenever auth state changes
                Task {
                    await self.loadUser(for: user)
                }
            } else {
                self.currentUser = nil
            }
        }
    }

    private func loadUser(for firebaseUser: User) async {
        isLoadingUser = true
        defer { isLoadingUser = false }

        do {
            // Try to fetch an existing user
            if let existing = try await UserService.fetchUser(uid: firebaseUser.uid) {
                self.currentUser = existing
            } else {
                // Create a new user doc, then fetch it
                try await UserService.createUserDocument(
                    uid: firebaseUser.uid,
                    email: firebaseUser.email ?? ""
                )
                let created = try await UserService.fetchUser(uid: firebaseUser.uid)
                self.currentUser = created
            }
        } catch {
            print("Failed to load user: \(error)")
            self.currentUser = nil
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            justLoggedInExistingUser = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    /// Call this **after a successful LOGIN** (not sign-up) to skip General Info onboarding.
    func markExistingUserLoggedIn() {
        justLoggedInExistingUser = true
    }
    
    /// Call when onboarding completes, or whenever you want to clear the flag.
    func clearLoginFlag() {
        justLoggedInExistingUser = false
    }
}
