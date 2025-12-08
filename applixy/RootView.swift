//
//  RootView.swift
//  applixy
//
//  Created by Parissa Teli on 12/8/25.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject var sessionVM: SessionViewModel
    @EnvironmentObject var savedOpportunitiesManager: SavedOpportunitiesManager

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
                // Always start here when app launches (we signOut in SessionViewModel.init)
                // This should be your login / sign-up screen.
                ContentView()
            } else if (sessionVM.currentUser?.onboardingComplete ?? false) == false {
                // Signed in but onboarding not complete
                
                OnboardingFlowView(
                    currentStep: $onboardingStep,
                    userProfile: $userProfile,
                    showingMainApp: $showingMainApp,
                    savedOpportunitiesManager: savedOpportunitiesManager
                )
                .onAppear {
                    // If this is an EXISTING user who just logged in,
                    // skip the General Info (step 0) and start at step 1.
                    if sessionVM.justLoggedInExistingUser {
                        onboardingStep = 1
                    } else {
                        onboardingStep = 0
                    }
                }
            } else {
                // Fully onboarded -> main app
                MainTabView(savedOpportunitiesManager: savedOpportunitiesManager)
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SessionViewModel())
        .environmentObject(SavedOpportunitiesManager())
}


#Preview {
    RootView()
        .environmentObject(SessionViewModel())
        .environmentObject(SavedOpportunitiesManager())
}
