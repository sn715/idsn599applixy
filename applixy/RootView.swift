//
//  RootView.swift
//  applixy
//
//  Created by Parissa Teli on 12/8/25.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject var sessionVM: SessionViewModel

    @State private var onboardingStep: Int = 0
    @State private var userProfile = UserProfileData()
    @State private var showingMainApp: Bool = false

    var body: some View {
        Group {
            if sessionVM.isLoadingUser {
                // Loading state while we figure out auth + Firestore user
                VStack {
                    ProgressView()
                    Text("Loading…")
                        .padding(.top, 8)
                }
            } else if sessionVM.currentUser == nil {
                // Login / sign-up flow
                ContentView()
            } else if (sessionVM.currentUser?.onboardingComplete ?? false) == false {
                // Signed in but onboarding not complete

                if sessionVM.justLoggedInExistingUser {
                    // 👉 Existing user logging in again → SKIP ALL ONBOARDING PANELS
                    MainTabView()
                } else {
                    // 🆕 Brand-new user → show full onboarding flow
                    OnboardingFlowView(
                        currentStep: $onboardingStep,
                        userProfile: $userProfile,
                        showingMainApp: $showingMainApp,
                    )
                    .onAppear {
                        onboardingStep = 0
                    }
                }
            } else {
                // Fully onboarded → main app
                MainTabView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SessionViewModel())
}
