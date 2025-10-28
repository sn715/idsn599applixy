//
//  ContentView.swift
//  applixy
//
//  Created by Sinchana Nama on 10/7/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// MARK: - Brand Colors
extension Color {
    static let applixyPrimary = Color(hex: "#1B1471")      // Deep Indigo
    static let applixySecondary = Color(hex: "#8091DF")     // Periwinkle
    static let applixyLight = Color(hex: "#CBCFF8")         // Light Lavender
    static let applixyBackground = Color(hex: "#F5F6FF")    // Off-white
    static let applixyDark = Color(hex: "#14131C")           // Charcoal
    static let applixyWhite = Color(hex: "#FFFFFF")          // White
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ContentView: View {
    @State private var showingOnboarding = false
    @State private var showingSignIn = false
    @State private var showingCreatePassword = false
    @State private var currentStep = 0
    @State private var userProfile = UserProfileData()
    @State private var showingMainApp = false
    @StateObject private var savedOpportunitiesManager = SavedOpportunitiesManager()
    
    var body: some View {
        if showingMainApp {
            MainTabView(savedOpportunitiesManager: savedOpportunitiesManager)
        } else if showingCreatePassword {
            CreatePasswordView(
                showingCreatePassword: $showingCreatePassword,
                showingOnboarding: $showingOnboarding
            )
        } else if showingOnboarding {
            OnboardingFlowView(
                currentStep: $currentStep,
                userProfile: $userProfile,
                showingMainApp: $showingMainApp,
                savedOpportunitiesManager: savedOpportunitiesManager
            )
        } else if showingSignIn {
            SignInView(
                showingMainApp: $showingMainApp,
                showingSignIn: $showingSignIn
            )
        } else {
            LandingPageView(
                showingOnboarding: $showingOnboarding,
                showingSignIn: $showingSignIn,
                showingCreatePassword: $showingCreatePassword
            )
        }
    }
}

// MARK: - Landing Page View
struct LandingPageView: View {
    @Binding var showingOnboarding: Bool
    @Binding var showingSignIn: Bool
    @Binding var showingCreatePassword: Bool
    
    var body: some View {
        ZStack {
            // Background with subtle gradient
            LinearGradient(
                colors: [Color.applixyBackground, Color.applixyLight.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo Section
                VStack(spacing: 30) {
                    // App Logo Placeholder
                    Image("app-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                    // App Name and Tagline
                    VStack(spacing: 12) {
                        Text("Applixy")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.applixyDark)
                        
                        /*Text("Sign in to continue")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.applixyDark)
                            */
                    }
                }
                
                //Spacer()
                
                // Sign In/Sign Up Buttons
                VStack(spacing: 16) {
                    // Sign in with email button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                            showingSignIn = true
                    }
                }) {
                        Text("Sign in")
                            .font(.system(size: 20))
                            //.fontWeight(.semibold)
                    .foregroundColor(.applixyWhite)
                            .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.applixyPrimary)
                            .cornerRadius(12)
                            .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                    
                    // Sign up button
                    Button(action: {
                        showingCreatePassword = true
                    }) {
                        Text("Sign up")
                            .font(.system(size: 16))
                            //.fontWeight(.semibold)
                            .foregroundColor(.applixySecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.applixyWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.applixySecondary, lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 60)
                
                /* Sign up link
                Button("Don't have an account? Sign up") {
                    showingCreatePassword = true
                }
                .font(.subheadline)
                .foregroundColor(.applixyPrimary)
                .padding(.top, 8)*/
                
                // Or sign up with section
                VStack(spacing: 20) {
                    // Or sign up with divider
                    HStack {
                        Rectangle()
                            .fill(Color.applixyLight)
                            .frame(height: 1)
                        
                        Text("or continue with")
                            .font(.system(size: 12))
                            .foregroundColor(.applixyDark)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .fill(Color.applixyLight)
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 18)
                    
                    // Social media buttons
                    HStack(spacing: 16) {
                        // Facebook button
                        Button(action: {
                            // Facebook sign up action
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.applixyWhite)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.applixySecondary, lineWidth: 1)
                                    )
                                    .frame(width: 60, height: 60)
                                
                                Text("f")
                            .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.applixyPrimary)
                            }
                        }
                        
                        // Google button
                        Button(action: {
                            // Google sign up action
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.applixyWhite)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.applixySecondary, lineWidth: 1)
                                    )
                                    .frame(width: 60, height: 60)
                                
                                Text("G")
                            .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.applixyPrimary)
                            }
                        }
                        
                        // Apple button
                        Button(action: {
                            // Apple sign up action
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.applixyWhite)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.applixySecondary, lineWidth: 1)
                                    )
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "apple.logo")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.applixyPrimary)
                            }
                        }
                    }
                }
                
                // Terms and Privacy links
                HStack(spacing: 20) {
                    Button("Terms of use") {
                        // Terms of use action
                    }
                    .font(.subheadline)
                            .foregroundColor(.applixySecondary)
                        
                    Button("Privacy Policy") {
                        // Privacy policy action
                    }
                            .font(.subheadline)
                            .foregroundColor(.applixySecondary)
                }
                
                // Decorative elements
                
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Create Password View
struct CreatePasswordView: View {
    @Binding var showingCreatePassword: Bool
    @Binding var showingOnboarding: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.applixyBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Back button
                HStack {
                Button(action: {
                        showingCreatePassword = false
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.applixySecondary)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                // Standard Header
                StandardHeaderView(
                    title: "Create Account",
                    subtitle: " "
                )
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email Address")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.applixySecondary)
                                    .frame(width: 20)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(Color.applixyWhite)
                            .cornerRadius(12)
                            .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.applixySecondary)
                                    .frame(width: 20)
                                
                                SecureField("Create a password", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .background(Color.applixyWhite)
                            .cornerRadius(12)
                            .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
                        }
                        
                        // Confirm Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.applixySecondary)
                                    .frame(width: 20)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }
                            .padding()
                            .background(Color.applixyWhite)
                            .cornerRadius(12)
                            .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
                        }
                        
                        // Password requirements
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password Requirements:")
                                .font(.caption)
                            .fontWeight(.semibold)
                                .foregroundColor(.applixyDark)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: password.count >= 8 ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(password.count >= 8 ? .green : .applixySecondary)
                                        .font(.caption)
                                    Text("At least 8 characters")
                                        .font(.caption)
                                        .foregroundColor(.applixySecondary)
                                }
                                
                                HStack {
                                    Image(systemName: password.contains(where: { $0.isUppercase }) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(password.contains(where: { $0.isUppercase }) ? .green : .applixySecondary)
                                        .font(.caption)
                                    Text("One uppercase letter")
                                        .font(.caption)
                                        .foregroundColor(.applixySecondary)
                                }
                                
                                HStack {
                                    Image(systemName: password.contains(where: { $0.isNumber }) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(password.contains(where: { $0.isNumber }) ? .green : .applixySecondary)
                                        .font(.caption)
                                    Text("One number")
                                        .font(.caption)
                                        .foregroundColor(.applixySecondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.applixyLight.opacity(0.3))
                        .cornerRadius(12)
                        
                        // Create Account button
                        Button(action: createAccount) {
                            Text("Create Account")
                                .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.applixyWhite)
                                .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.applixyPrimary, .applixySecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                                .cornerRadius(12)
                                .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isFormValid: Bool {
        return !email.isEmpty &&
               !password.isEmpty &&
               !confirmPassword.isEmpty &&
               password == confirmPassword &&
               password.count >= 8 &&
               password.contains(where: { $0.isUppercase }) &&
               password.contains(where: { $0.isNumber })
    }
    private func createAccount() {
        guard isFormValid else {
            alertMessage = "Please ensure all fields are filled and passwords match"
            showingAlert = true
            return
        }

        Task {
            do {
                // 1) Create Firebase Auth user
                let result = try await Auth.auth().createUser(withEmail: email, password: password)

                // 2) Create Firestore profile document
                try await UserService.createUserDocument(
                    uid: result.user.uid,
                    email: email
                )

                // 3) Proceed to onboarding
                await MainActor.run {
                    showingCreatePassword = false
                    showingOnboarding = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Sign up failed: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
/*
    private func createAccount() {
        if isFormValid {
            // Here you would typically save the email and password
            // For now, we'll just proceed to onboarding
            showingCreatePassword = false
            showingOnboarding = true
        } else {
            alertMessage = "Please ensure all fields are filled and passwords match"
            showingAlert = true
        }
    }
 */
}

// MARK: - Sign In View
struct SignInView: View {
    @Binding var showingMainApp: Bool
    @Binding var showingSignIn: Bool
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var isEmailSignIn = true
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Back button
                HStack {
                Button(action: {
                            showingSignIn = false
                        }) {
                HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Back")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.applixySecondary)
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    //.padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Header
                    VStack(spacing: 20) {
                        // Logo
                        
                        VStack(spacing: 8) {
                            Text("Welcome back!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.applixyDark)
                            
                            Text("Sign in to your account")
                                .font(.subheadline)
                                .foregroundColor(.applixySecondary)
                        }
                    }
                    
                    // Sign in method toggle
                    HStack(spacing: 0) {
                        Button("Email") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isEmailSignIn = true
                            }
                        }
                        .foregroundColor(isEmailSignIn ? .applixyWhite : .applixySecondary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            isEmailSignIn ? 
                            Color.applixyPrimary : 
                            Color.clear
                        )
                        .cornerRadius(8)
                        
                        Button("Phone") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isEmailSignIn = false
                            }
                        }
                        .foregroundColor(!isEmailSignIn ? .applixyWhite : .applixySecondary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            !isEmailSignIn ? 
                            Color.applixyPrimary : 
                            Color.clear
                        )
                        .cornerRadius(8)
                    }
                    .background(Color.applixyLight.opacity(0.3))
                    .cornerRadius(8)
                    
                    // Form fields
                    VStack(spacing: 20) {
                        if isEmailSignIn {
                            CustomTextField(
                                title: "Email",
                                text: $email,
                                icon: "envelope.fill",
                                keyboardType: .emailAddress
                            )
                        } else {
                            CustomTextField(
                                title: "Phone Number",
                                text: $phone,
                                icon: "phone.fill",
                                keyboardType: .phonePad
                            )
                        }
                        
                        CustomTextField(
                            title: "Password",
                            text: $password,
                            icon: "lock.fill",
                            keyboardType: .default
                        )
                    }
                    
                    // Sign in button
                    Button(action: signIn) {
                        Text("Sign In")
                            .font(.title3)
                            .fontWeight(.semibold)
                    .foregroundColor(.applixyWhite)
                            .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.applixyPrimary, .applixySecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                            .cornerRadius(12)
                            .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(email.isEmpty && phone.isEmpty || password.isEmpty)
                    .opacity((email.isEmpty && phone.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                    
                    // Forgot password
                    Button("Forgot password?") {
                        // Handle forgot password
                    }
                    .font(.subheadline)
                    .foregroundColor(.applixyPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationBarHidden(true)
            .alert("Sign In Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    private func signIn() {
        if isEmailSignIn {
            guard !email.isEmpty, !password.isEmpty else {
                alertMessage = "Please fill in email and password"
                showingAlert = true
                return
            }
            Task {
                do {
                    _ = try await Auth.auth().signIn(withEmail: email, password: password)
                    await MainActor.run {
                        showingMainApp = true
                    }
                } catch {
                    await MainActor.run {
                        alertMessage = "Sign in failed: \(error.localizedDescription)"
                        showingAlert = true
                    }
                }
            }
        } else {
            // (Optional) Implement phone auth later with PhoneAuthProvider
            alertMessage = "Phone sign-in not implemented yet."
            showingAlert = true
        }
    }

    /*
    private func signIn() {
        // Mock sign in logic - replace with actual authentication
        if isEmailSignIn && !email.isEmpty && !password.isEmpty {
            // Email sign in
            showingMainApp = true
        } else if !isEmailSignIn && !phone.isEmpty && !password.isEmpty {
            // Phone sign in
            showingMainApp = true
        } else {
            alertMessage = "Please fill in all required fields"
            showingAlert = true
        }
    }
    */
}

// MARK: - Onboarding Flow View
struct OnboardingFlowView: View {
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfileData
    @Binding var showingMainApp: Bool
    @ObservedObject var savedOpportunitiesManager: SavedOpportunitiesManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if currentStep < 4 {
                        // Standard Header
                        StandardHeaderView(
                            title: getOnboardingTitle(),
                            subtitle: getOnboardingSubtitle()
                        )
                        
                        // Progress indicator
                        VStack(spacing: 10) {
                            HStack {
                                Text("Step \(currentStep + 1) of 4")
                                    .font(.caption)
                                    .foregroundColor(.applixyDark)
                                Spacer()
                                Text("\(Int((Double(currentStep) / 4.0) * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.applixyDark)
                            }
                            
                            ProgressView(value: Double(currentStep), total: 4)
                                .progressViewStyle(LinearProgressViewStyle(tint: .applixyPrimary))
                                .scaleEffect(y: 2)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Onboarding steps
                        TabView(selection: $currentStep) {
                            GeneralInfoView(userProfile: $userProfile)
                                .tag(0)
                            
                            DemographicsView(userProfile: $userProfile)
                                .tag(1)
                            
                            AcademicInfoView(userProfile: $userProfile)
                                .tag(2)
                            
                            InterestsView(userProfile: $userProfile)
                                .tag(3)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        // Navigation buttons
                        HStack {
                            if currentStep > 0 {
                                Button("Back") {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentStep -= 1
                                    }
                                }
                                .foregroundColor(.applixySecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.applixyLight)
                                .cornerRadius(25)
                            }
                            
                            Spacer()
                            
                            Button(currentStep == 3 ? "Complete" : "Next") {
                                if currentStep == 3 {
                                    // Save user profile and show completion
                                    showingMainApp = true
                                } else {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentStep += 1
                                    }
                                }
                            }
                            .foregroundColor(.applixyWhite)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [.applixyPrimary, .applixySecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showingMainApp) {
            MainTabView(savedOpportunitiesManager: savedOpportunitiesManager)
        }
    }
    
    private func getOnboardingTitle() -> String {
        switch currentStep {
        case 0: return "General Info"
        case 1: return "Demographics"
        case 2: return "Academic Info"
        case 3: return "Interests"
        default: return "Onboarding"
        }
    }
    
    private func getOnboardingSubtitle() -> String {
        switch currentStep {
        case 0: return "Tell us about yourself"
        case 1: return "Help us understand your background"
        case 2: return "Share your academic journey"
        case 3: return "What interests you most?"
        default: return "Complete your profile"
        }
    }
}

// MARK: - User Profile Data Model
struct UserProfileData {
    var firstName = ""
    var lastName = ""
    var age = 18
    var email = ""
    var location = ""
    var gender = ""
    var race = ""
    var isFirstGen = false
    var isLowIncome = false
    var school = ""
    var gpaRange = ""
    var graduationDate = Date()
    var interests: [String] = []
}

// MARK: - Onboarding Views
struct GeneralInfoView: View {
    @Binding var userProfile: UserProfileData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CustomTextField(title: "First Name", text: $userProfile.firstName, icon: "person.fill")
                CustomTextField(title: "Last Name", text: $userProfile.lastName, icon: "person.fill")
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.applixySecondary)
                        .frame(width: 20)
                    Text("Age:")
                        .font(.headline)
                        .foregroundColor(.applixyDark)
                    Spacer()
                    Stepper("\(userProfile.age)", value: $userProfile.age, in: 16...25)
                        .accentColor(.applixyPrimary)
        }
        .padding()
                .background(Color.applixyWhite)
                .cornerRadius(12)
                .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
                
                CustomTextField(title: "Email", text: $userProfile.email, icon: "envelope.fill", keyboardType: .emailAddress)
                CustomTextField(title: "Location (City, State)", text: $userProfile.location, icon: "location.fill")
        }
        .padding()
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.applixyDark)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.applixySecondary)
                    .frame(width: 20)
                
                TextField(title, text: $text)
                    .keyboardType(keyboardType)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(Color.applixyWhite)
            .cornerRadius(12)
            .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
        }
    }
}

struct DemographicsView: View {
    @Binding var userProfile: UserProfileData
    
    private let genders = ["Male", "Female", "Non-binary", "Prefer not to say"]
    private let races = ["American Indian/Alaska Native", "Asian", "Black/African American", "Hispanic/Latino", "Native Hawaiian/Pacific Islander", "White", "Other", "Prefer not to say"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CustomPicker(title: "Gender", selection: $userProfile.gender, options: genders, icon: "person.2.fill")
                CustomPicker(title: "Race/Ethnicity", selection: $userProfile.race, options: races, icon: "globe")
                
                VStack(spacing: 15) {
                    CustomToggle(title: "First Generation College Student", isOn: $userProfile.isFirstGen, icon: "graduationcap.fill")
                    CustomToggle(title: "Low Income Background", isOn: $userProfile.isLowIncome, icon: "dollarsign.circle.fill")
            }
        }
        .padding()
        }
    }
}

struct CustomPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.applixyDark)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.applixySecondary)
                    .frame(width: 20)
                
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.applixyPrimary)
            }
            .padding()
            .background(Color.applixyWhite)
            .cornerRadius(12)
            .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
        }
    }
}

struct CustomToggle: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.applixySecondary)
                .frame(width: 20)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.applixyDark)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .accentColor(.applixyPrimary)
        }
        .padding()
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
    }
}

struct AcademicInfoView: View {
    @Binding var userProfile: UserProfileData
    
    private let gpaRanges = ["3.0-3.2", "3.2-3.5", "3.5-3.7", "3.7-4.0", "4.0+"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CustomTextField(title: "Current School", text: $userProfile.school, icon: "building.2.fill")
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("GPA Range")
                        .font(.headline)
                        .foregroundColor(.applixyDark)
                    
                    Picker("GPA Range", selection: $userProfile.gpaRange) {
                        ForEach(gpaRanges, id: \.self) { range in
                            Text(range).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .accentColor(.applixyPrimary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Expected Graduation")
                        .font(.headline)
                        .foregroundColor(.applixyDark)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.applixySecondary)
                            .frame(width: 20)
                        
                        DatePicker("", selection: $userProfile.graduationDate, displayedComponents: .date)
                            .accentColor(.applixyPrimary)
                    }
                    .padding()
                    .background(Color.applixyWhite)
                    .cornerRadius(12)
                    .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
            }
        }
        .padding()
        }
    }
}

struct InterestsView: View {
    @Binding var userProfile: UserProfileData
    
    private let interestOptions = [
        "STEM", "Arts", "Leadership", "Business",
        "Community Service", "Women in Tech", "Minority Programs"
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                ForEach(interestOptions, id: \.self) { interest in
                    InterestTag(
                        title: interest,
                        isSelected: userProfile.interests.contains(interest)
                    ) {
                        if userProfile.interests.contains(interest) {
                            userProfile.interests.removeAll { $0 == interest }
                        } else {
                            userProfile.interests.append(interest)
                    }
                }
            }
        }
        .padding()
        }
    }
}

struct InterestTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    isSelected ?
                    LinearGradient(
                        colors: [.applixyPrimary, .applixySecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [Color.applixyLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(isSelected ? .applixyWhite : .applixyDark)
                .cornerRadius(25)
                .shadow(
                    color: isSelected ? .applixyPrimary.opacity(0.3) : .applixyLight,
                    radius: isSelected ? 8 : 4,
                    x: 0,
                    y: isSelected ? 4 : 2
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab = 0
    @ObservedObject var savedOpportunitiesManager: SavedOpportunitiesManager
    
    var body: some View {
        ZStack {
            // Main content
            Group {
                switch selectedTab {
                case 0:
                    DiscoveryView(savedOpportunitiesManager: savedOpportunitiesManager)
                case 1:
                    SavedView(savedOpportunitiesManager: savedOpportunitiesManager)
                case 2:
                    MentorsView()
                case 3:
                    UpdatesView()
                case 4:
                    ResourcesView()
                default:
                    DiscoveryView(savedOpportunitiesManager: savedOpportunitiesManager)
                }
            }
            
            // Custom Tab Bar
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // Discover (Home) - Active state
            TabBarButton(
                icon: "house.fill",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            // Saved (Star)
            TabBarButton(
                icon: "star.fill",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            // Mentors (People)
            TabBarButton(
                icon: "person.2.fill",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
            
            // Updates (Calendar)
            TabBarButton(
                icon: "calendar",
                isSelected: selectedTab == 3,
                action: { selectedTab = 3 }
            )
            
            // Resources (Compass)
            TabBarButton(
                icon: "location.north.fill",
                isSelected: selectedTab == 4,
                action: { selectedTab = 4 }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.applixyWhite)
                .shadow(color: .applixyPrimary.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(Color.applixyPrimary)
                        .frame(width: 50, height: 50)
                }
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .applixyWhite : .applixySecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Saved View
struct SavedView: View {
    @ObservedObject var savedOpportunitiesManager: SavedOpportunitiesManager
    
    var body: some View {
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                // Standard Header
                StandardHeaderView(
                    title: "Saved",
                    subtitle: " "
                )
                
                // Content
                if savedOpportunitiesManager.savedOpportunities.isEmpty {
                    VStack(spacing: 30) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.applixyLight)
                        
                        Text("No Saved Opportunities")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.applixyDark)
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(savedOpportunitiesManager.savedOpportunities) { opportunity in
                                SavedOpportunityCard(opportunity: opportunity, savedOpportunitiesManager: savedOpportunitiesManager)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
}

// MARK: - Saved Opportunity Card
struct SavedOpportunityCard: View {
    let opportunity: OpportunityData
    @ObservedObject var savedOpportunitiesManager: SavedOpportunitiesManager
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with title and remove button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(opportunity.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.applixyDark)
                        .lineLimit(2)
                    
                    Text(opportunity.type)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.applixyPrimary)
                }
                
                Spacer()
                
                Button(action: {
                    savedOpportunitiesManager.removeOpportunity(opportunity)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.applixySecondary)
                }
            }
            
            // Description
            Text(opportunity.details)
                .font(.system(size: 14))
                .foregroundColor(.applixySecondary)
                .lineLimit(3)
            
            // Deadline and link
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text("Due \(opportunity.deadline, formatter: dateFormatter)")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.applixySecondary)
                
                Spacer()
                
                if !opportunity.link.isEmpty {
                    Button("View Details") {
                        showingDetail = true
                    }
                    .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.applixyPrimary)
                }
            }
        }
        .padding()
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showingDetail) {
            OpportunityDetailView(opportunity: opportunity)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

// MARK: - Updates View
struct UpdatesView: View {
    @State private var scholarshipUpdates: [ScholarshipUpdate] = []
    
    var body: some View {
        ZStack {
            Color.applixyBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Standard Header
                StandardHeaderView(
                    title: "Updates",
                    subtitle: " "
                )
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(scholarshipUpdates) { update in
                            ScholarshipUpdateCard(update: update)
                }
            }
            .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            loadScholarshipUpdates()
        }
    }
    
    private func loadScholarshipUpdates() {
        scholarshipUpdates = [
            ScholarshipUpdate(
                title: "Jack Kent Scholarship",
                organization: "JACK KENT COOKE FOUNDATION",
                description: "Offers up to $55,000 per year for high-achieving students with financial need to attend top universities.",
                status: "Decision Ready!",
                statusColor: .green,
                imageName: "jack-kent-scholarship",
                isNew: false
            ),
            ScholarshipUpdate(
                title: "Dell Scholarship Program",
                organization: "DELL SCHOLARSHIP PROGRAM",
                description: "Support for students who've overcome significant challenges and demonstrate financial need.",
                status: "Releases Tomorrow!",
                statusColor: .gray,
                imageName: "dell-scholarship",
                isNew: true
            )
        ]
    }
}

// MARK: - Scholarship Update Data Model
struct ScholarshipUpdate: Identifiable {
    let id = UUID().uuidString
    let title: String
    let organization: String
    let description: String
    let status: String
    let statusColor: Color
    let imageName: String
    let isNew: Bool
}

// MARK: - Scholarship Update Card
struct ScholarshipUpdateCard: View {
    let update: ScholarshipUpdate
    @State private var showingDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main card content
            ZStack(alignment: .topLeading) {
                // Update image background
                Image("update")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                
                // Status tag
                HStack {
                    Text(update.status)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(update.statusColor == .green ? .white : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(update.statusColor == .green ? Color.green : Color.white.opacity(0.8))
                        )
                    
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                // Organization name
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    
                    Text(update.organization)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    
                    Text(update.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                }
            }
            
            // Description section
            VStack(alignment: .leading, spacing: 12) {
                Text(update.description)
                    .font(.system(size: 14))
                    .foregroundColor(.applixyDark)
                    .lineLimit(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                // Action button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingDetail = true
                    }) {
                        HStack(spacing: 8) {
                            Text("Learn More")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.applixyPrimary)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.applixyPrimary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .background(Color.applixyWhite)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .background(Color.applixyWhite)
        .cornerRadius(16)
        .shadow(color: .applixyLight, radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showingDetail) {
            ScholarshipDetailView(update: update)
        }
    }
}

// MARK: - Scholarship Detail View
struct ScholarshipDetailView: View {
    let update: ScholarshipUpdate
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(update.organization)
                            .font(.caption)
                            .fontWeight(.bold)
                        .foregroundColor(.applixySecondary)
                        
                        Text(update.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.applixyDark)
                        
                        HStack {
                            Text(update.status)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(update.statusColor == .green ? .white : .gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(update.statusColor == .green ? Color.green : Color.gray.opacity(0.2))
                                )
                            
                            Spacer()
                        }
                }
                .padding(.horizontal)
                    
                    // Description
                    Text(update.description)
                        .font(.body)
                        .foregroundColor(.applixyDark)
                        .padding(.horizontal)
                    
                    Spacer()
        }
        .padding(.top)
            }
            .navigationTitle("Scholarship Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Discovery View
struct DiscoveryView: View {
    @ObservedObject var savedOpportunitiesManager: SavedOpportunitiesManager
    @State private var opportunities: [OpportunityData] = []
    @State private var currentIndex = 0
    @State private var dragOffset = CGSize.zero
    @State private var showingDetail = false
    @State private var selectedOpportunity: OpportunityData?
    @State private var showingSavedAlert = false
    @State private var showingSkippedAlert = false
    @State private var swipeDirection: SwipeDirection = .none
    @State private var listener: ListenerRegistration?
    @State private var showingAddOpportunity = false
    
    

    
    var body: some View {
        
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    HStack{
                        // Standard Header
                        StandardHeaderView(
                            title: "Discover",
                            subtitle: " "
                        )
                        
                        Spacer()
                        
                        // Button should direct user to another pop up to add opportunities... Then when they click the submit button their opportunity should post (using the postOpportunity function)
                        Button(action: {
                            showingAddOpportunity = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [.applixyPrimary, .applixySecondary],
                                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .frame(width: 54, height: 54)
                                    .shadow(color: .applixyPrimary.opacity(0.25), radius: 12, x: 0, y: 6)
                                Image(systemName: "plus")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.applixyWhite)
                            }
                        }
                        .padding(.trailing, 20) // Add padding to match the reference image
                    }
                    .padding(.horizontal, 20) // Add horizontal padding to the entire header
                    
                    
                    
                    // Card Stack
                    cardStackView
                }
            }
            .onAppear {
                loadOpportunities()
            }
            .sheet(isPresented: $showingDetail) {
                if let opportunity = selectedOpportunity {
                    OpportunityDetailView(opportunity: opportunity)
                }
            }
            .sheet(isPresented: $showingAddOpportunity) {
                AddOpportunityView()
            }
        
    }
    
    
    // MARK: - Card Stack View
    private var cardStackView: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 50)
            
            if opportunities.isEmpty {
                emptyStateView
            } else if currentIndex >= opportunities.count {
                allCaughtUpView
            } else {
                let currentOpportunity = opportunities[currentIndex]
                
                VStack(spacing: 15) {
                    // Main card - made taller
                    SwipeCardView(
                        opportunity: currentOpportunity,
                        dragOffset: $dragOffset,
                        swipeDirection: $swipeDirection,
                        onSwipeLeft: {
                            skipOpportunity()
                        },
                        onSwipeRight: {
                            saveOpportunity(currentOpportunity)
                        },
                        onHeartTap: {
                            saveOpportunity(currentOpportunity)
                        }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                print("Drag changed: \(value.translation.width)")
                                dragOffset = value.translation
                                updateSwipeDirection(value: value)
                            }
                            .onEnded { value in
                                print("Drag ended: \(value.translation.width)")
                                handleSwipeGesture(value: value, opportunity: currentOpportunity)
                            }
                    )
                    
                    // Action buttons below the card
                    HStack(spacing: 40) {
                        // X button (left)
                        Button(action: {
                            skipOpportunity()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.applixyWhite)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: .applixyPrimary.opacity(0.2), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "xmark")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Star button (right)
                        Button(action: {
                            saveOpportunity(currentOpportunity)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.applixyWhite)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: .applixyPrimary.opacity(0.2), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "star.fill")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.applixyPrimary)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.applixyLight)
            
            Text("No opportunities yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.applixyDark)
            
            Text("Check back later for new opportunities")
                .foregroundColor(.applixySecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // MARK: - All Caught Up State
    private var allCaughtUpView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.applixyPrimary, .applixySecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .applixyPrimary.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.applixyWhite)
            }
            
            Text("All caught up!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.applixyDark)
            
            Text("You've seen all available opportunities. Check back tomorrow for new ones!")
                .foregroundColor(.applixySecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    // MARK: - Helper Functions
    
    private func loadOpportunities() {
        // If already signed in, attach the listener immediately
        if Auth.auth().currentUser != nil {
            attachScholarshipListener()
            return
        }

        // Otherwise sign in anonymously, then attach
        Auth.auth().signInAnonymously { _, error in
            if let error = error {
                print("🔥 Anonymous sign-in failed: \(error.localizedDescription)")
                return
            }
            print("✅ Anonymous sign-in OK")
            attachScholarshipListener()
        }
    }

    // Split out the actual listener so we can call it from both paths
    private func attachScholarshipListener() {
        // Start live updates from your scholarship collection
        listener = startScholarshipListener { posts in
            print("📥 posts from listener: \(posts.count)")
            let mapped: [OpportunityData] = posts.map { p in
                OpportunityData(
                    id: p.id,
                    title: p.name,
                    type: "Scholarship",
                    deadline: parseDeadline(p.applicationDeadline),
                    awardAmount: formatAward(p.awardAmount),
                    eligibility: p.organization.isEmpty ? "See details" : p.organization,
                    details: p.description,
                    link: p.website ?? "",
                    tags: []
                )
            }
            DispatchQueue.main.async {
                self.opportunities = mapped
                self.currentIndex = 0
                print("✅ opportunities set: \(self.opportunities.count)")
            }
        }
    }
    
    // MARK: - Helpers
    private func parseDeadline(_ raw: String?) -> Date {
        guard let raw = raw, !raw.isEmpty else { return Date() }
        let fmts = ["yyyy-MM-dd", "MM/dd/yyyy", "MMMM d, yyyy", "MMMM d"]
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        for f in fmts {
            df.dateFormat = f
            if let d = df.date(from: raw) {
                if f == "MMMM d" {
                    let y = Calendar.current.component(.year, from: Date())
                    return Calendar.current.date(bySetting: .year, value: y, of: d) ?? d
                }
                return d
            }
        }
        // Fallback: now (so UI still renders)
        return Date()
    }

    private func formatAward(_ amount: Int?) -> String {
        guard let amount = amount, amount > 0 else { return "" }
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 0
        return nf.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }


    /*
    private func loadOpportunities() {
        // Start live updates from your scholarship collection
        listener = startScholarshipListener { posts in
            // Map ScholarshipPost -> OpportunityData
            let mapped: [OpportunityData] = posts.map { p in
                OpportunityData(
                    id: p.id,
                    title: p.name,
                    type: "Scholarship",
                    deadline: parseDeadline(p.applicationDeadline),
                    awardAmount: formatAward(p.awardAmount),
                    eligibility: p.organization.isEmpty ? "See details" : p.organization,
                    details: p.description,
                    link: p.website ?? "",
                    tags: [] // add if you later store tags in Firestore
                )
            }
            DispatchQueue.main.async {
                self.opportunities = mapped
                self.currentIndex = 0
            }
        }
    }

    // If you want to stop listening (e.g., onDisappear)
    private func stopListening() {
        listener?.remove()
        listener = nil
    }

    // Helpers
    private func parseDeadline(_ raw: String?) -> Date {
        guard let raw = raw, !raw.isEmpty else { return Date() }
        // Try several common formats (adjust to your data)
        let fmts = ["yyyy-MM-dd", "MM/dd/yyyy", "MMMM d, yyyy", "MMMM d"] // e.g., "November 13"
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        for f in fmts {
            df.dateFormat = f
            if let d = df.date(from: raw) {
                // If no year (e.g., "November 13"), assume current year
                if f == "MMMM d" {
                    let y = Calendar.current.component(.year, from: Date())
                    return Calendar.current.date(bySetting: .year, value: y, of: d) ?? d
                }
                return d
            }
        }
        return Date()
    }

    private func formatAward(_ amount: Int?) -> String {
        guard let amount = amount, amount > 0 else { return "" }
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 0
        return nf.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
    
    */
/*
    
    private func loadOpportunities() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        //var listener: ListenerRegistration?

        // Start listening
        listener = startScholarshipListener { posts in
            let mapped: [OpportunityData] = posts.map { p in
                OpportunityData(
                    id: p.id,
                       title: p.name,
                       type: "Scholarship",
                       deadline: parseDeadline(p.applicationDeadline),
                       awardAmount: formatAward(p.awardAmount),
                       eligibility: p.organization.isEmpty ? "See details" : p.organization,
                       details: p.description,
                       link: p.website ?? "",
                       tags: []
                )
                
            }
            DispatchedQueue.main.async {
                self.opportunities = mapped
                self.currentIndex = 0
            }
            
            print("Live update: \(posts.count) scholarships found")
        }
        
    
         
        print("Loaded \(opportunities.count) opportunities")
        currentIndex = 0
    }
    */
    
    private func updateSwipeDirection(value: DragGesture.Value) {
        let threshold: CGFloat = 50
        
        if abs(value.translation.width) > threshold {
            if value.translation.width > 0 {
                swipeDirection = .right
            } else {
                swipeDirection = .left
            }
        } else {
            swipeDirection = .none
        }
    }
    
    private func handleSwipeGesture(value: DragGesture.Value, opportunity: OpportunityData) {
        let threshold: CGFloat = 100
        print("Swipe gesture ended - translation: \(value.translation.width), threshold: \(threshold)")
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            if abs(value.translation.width) > threshold {
                if value.translation.width > 0 {
                    // Swipe right - save
                    print("Swipe right detected - saving opportunity")
                    saveOpportunity(opportunity)
                } else {
                    // Swipe left - skip
                    print("Swipe left detected - skipping opportunity")
                    skipOpportunity()
                }
            } else {
                // Return to original position
                print("Swipe not far enough - returning to original position")
            dragOffset = .zero
            }
            swipeDirection = .none
        }
    }
    
    private func saveOpportunity(_ opportunity: OpportunityData) {
        print("Saved: \(opportunity.title)")
        savedOpportunitiesManager.saveOpportunity(opportunity)
        showingSavedAlert = true
        nextOpportunity()
    }
    
    private func skipOpportunity() {
        print("Skipped opportunity")
        showingSkippedAlert = true
        nextOpportunity()
    }
    
    private func nextOpportunity() {
        print("Current index: \(currentIndex), Total opportunities: \(opportunities.count)")
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentIndex += 1
            dragOffset = .zero
            swipeDirection = .none
        }
        print("New index: \(currentIndex)")
    }
}

// MARK: - Standard Header Component
struct StandardHeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.applixyDark)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.applixySecondary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

// MARK: - Shared Data Manager
class SavedOpportunitiesManager: ObservableObject {
    @Published var savedOpportunities: [OpportunityData] = []
    
    func saveOpportunity(_ opportunity: OpportunityData) {
        if !savedOpportunities.contains(where: { $0.id == opportunity.id }) {
            savedOpportunities.append(opportunity)
        }
    }
    
    func removeOpportunity(_ opportunity: OpportunityData) {
        savedOpportunities.removeAll { $0.id == opportunity.id }
    }
}

// MARK: - Data Models
enum SwipeDirection {
    case none, left, right, up
}

struct OpportunityData: Identifiable {
    let id: String
    let title: String
    let type: String
    let deadline: Date
    let awardAmount: String
    let eligibility: String
    let details: String
    let link: String
    let tags: [String]
}

// MARK: - Swipe Card View
struct SwipeCardView: View {
    let opportunity: OpportunityData
    @Binding var dragOffset: CGSize
    @Binding var swipeDirection: SwipeDirection
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    let onHeartTap: () -> Void
    
    var body: some View {
        ZStack {
            // Main Card
            VStack(spacing: 0) {
                // Image placeholder with deadline tag
                ZStack(alignment: .topLeading) {
                    // Opportunity image
                    Image("opportunity")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                    
                    // Deadline tag
                    Text("DUE: \(opportunity.deadline, formatter: dateFormatter)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.applixyWhite)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.applixyDark.opacity(0.8))
                        .cornerRadius(12)
                        .padding(.top, 16)
                        .padding(.leading, 16)
                }
                
                // Card content
                VStack(alignment: .leading, spacing: 12) {
                    // Title and type
                VStack(alignment: .leading, spacing: 8) {
                    Text(opportunity.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.applixyDark)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: typeIcon)
                            .foregroundColor(.applixySecondary)
                        Text(opportunity.type)
                            .font(.subheadline)
                            .foregroundColor(.applixySecondary)
                }
            }
            
            // Deadline and Award
                    VStack(spacing: 6) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.red)
                    Text("Deadline: \(opportunity.deadline, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.green)
                    Text(opportunity.awardAmount)
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
            
                    // Description
                    Text(opportunity.details.isEmpty ? opportunity.eligibility : opportunity.details)
                .font(.body)
                .foregroundColor(.applixyDark)
                        .lineLimit(2)
            
            // Tags
            if !opportunity.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(opportunity.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.applixyLight)
                                .foregroundColor(.applixyPrimary)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
                }
                .padding(16)
            }
        .background(Color.applixyWhite)
        .cornerRadius(20)
        .shadow(
            color: .applixyPrimary.opacity(0.1),
            radius: 20,
            x: 0,
            y: 10
        )
            
            // Swipe feedback overlays
            if swipeDirection != .none {
                ZStack {
                    if swipeDirection == .left {
                        // Red overlay for left swipe (X)
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red.opacity(0.2))
                            .overlay(
                                VStack {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundColor(.red)
                                    /*Text("SKIP")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)*/
                                }
                            )
                    } else if swipeDirection == .right {
                        // Green overlay for right swipe (Star)
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green.opacity(0.2))
                            .overlay(
                                VStack {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundColor(.green)
                                    /*Text("SAVE")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)*/
                                }
                            )
                    }
                }
            }
        }
        .offset(x: dragOffset.width, y: dragOffset.height)
        .rotationEffect(.degrees(dragOffset.width / 20))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
    }
    
    private var typeIcon: String {
        switch opportunity.type.lowercased() {
        case "scholarship": return "dollarsign.circle.fill"
        case "college": return "building.2.fill"
        case "program": return "graduationcap.fill"
        default: return "star.fill"
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - Opportunity Detail View
struct OpportunityDetailView: View {
    let opportunity: OpportunityData
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(opportunity.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.applixyDark)
                        
                        HStack {
                            Image(systemName: typeIcon)
                                .foregroundColor(.applixySecondary)
                            Text(opportunity.type)
                                .font(.title3)
                                .foregroundColor(.applixySecondary)
                        }
                    }
                    
                    // Key Info
                    VStack(spacing: 16) {
                        InfoRow(icon: "calendar", title: "Deadline", value: opportunity.deadline, formatter: dateFormatter)
                        InfoRow(icon: "dollarsign.circle", title: "Award Amount", value: opportunity.awardAmount)
                        
                        if !opportunity.tags.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tags")
                                    .font(.headline)
                                    .foregroundColor(.applixyDark)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(opportunity.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.applixyLight)
                                            .foregroundColor(.applixyPrimary)
                                            .cornerRadius(15)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Eligibility
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Eligibility")
                            .font(.headline)
                            .foregroundColor(.applixyDark)
                        
                        Text(opportunity.eligibility)
                            .font(.body)
                            .foregroundColor(.applixyDark)
                    }
                    
                    // Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Details")
                            .font(.headline)
                            .foregroundColor(.applixyDark)
                        
                        Text(opportunity.details)
                            .font(.body)
                            .foregroundColor(.applixyDark)
                    }
                    
                    // Link
                    if !opportunity.link.isEmpty {
                        Link("Visit Official Website", destination: URL(string: opportunity.link)!)
                            .foregroundColor(.applixyWhite)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.applixyPrimary, .applixySecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .background(Color.applixyBackground)
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.applixyPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    /*Button("Save") {
                        // Save action
                        dismiss()
                    }
                    .foregroundColor(.applixyWhite)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.applixyPrimary)
                    .cornerRadius(20)*/
                }
            }
        }
    }
    
    private var typeIcon: String {
        switch opportunity.type.lowercased() {
        case "scholarship": return "dollarsign.circle.fill"
        case "college": return "building.2.fill"
        case "program": return "graduationcap.fill"
        default: return "star.fill"
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: Any
    var formatter: DateFormatter? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.applixySecondary)
                .frame(width: 20)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.applixyDark)
            
            Spacer()
            
            if let date = value as? Date, let formatter = formatter {
                Text(formatter.string(from: date))
                    .foregroundColor(.applixySecondary)
            } else {
                Text("\(value)")
                    .foregroundColor(.applixySecondary)
            }
        }
        .padding()
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Mentors View
struct MentorsView: View {
    @State private var mentors: [MentorProfile] = []
    @State private var showingAddMentor = false
    @State private var listener: ListenerRegistration? = nil
    @State private var loading = false
    @State private var loadError: String?

    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        StandardHeaderView(title: "Mentors", subtitle: " ")
                        Spacer()
                        Button(action: { showingAddMentor = true }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.applixyPrimary, .applixySecondary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 54, height: 54)
                                    .shadow(color: .applixyPrimary.opacity(0.25), radius: 12, x: 0, y: 6)
                                Image(systemName: "plus")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.applixyWhite)
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.horizontal, 20)

                    // Content
                    Group {
                        if loading {
                            VStack(spacing: 12) {
                                ProgressView()
                                Text("Loading mentors…")
                                    .foregroundColor(.applixySecondary)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let err = loadError {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.orange)
                                Text("Couldn’t load mentors")
                                    .font(.title3).fontWeight(.semibold)
                                    .foregroundColor(.applixyDark)
                                Text(err)
                                    .font(.footnote)
                                    .foregroundColor(.applixySecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                Button("Retry") { restartListener() }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.applixyPrimary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if mentors.isEmpty {
                            emptyStateView
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVGrid(
                                    columns: [
                                        GridItem(.flexible(), spacing: 16),
                                        GridItem(.flexible(), spacing: 16)
                                    ],
                                    spacing: 16
                                ) {
                                    ForEach(mentors) { mentor in
                                        MentorGridCard(mentor: mentor) {
                                            // Handle tap (e.g., push a detail view)
                                            print("Mentor tapped: \(mentor.name)")
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .onAppear { restartListener() }
            .onDisappear { stopListener() }
            .sheet(isPresented: $showingAddMentor) {
                // When AddMentorView succeeds, the live listener will auto-refresh this grid.
                AddMentorView(onSuccess: {
                    // No manual reload needed since snapshot listener is live,
                    // but you can still haptically nudge or log.
                })
            }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.2.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.applixyLight)
            Text("No mentors available")
                .font(.title2).fontWeight(.semibold)
                .foregroundColor(.applixyDark)
            Text("Check back later for mentor profiles")
                .foregroundColor(.applixySecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Firestore
    private func restartListener() {
        stopListener()
        startListener()
    }

    private func startListener() {
        loading = true
        loadError = nil

        let db = Firestore.firestore()
        // Sort newest first; adjust field name if you use "createdAt" instead of "timestamp"
        listener = db.collection("mentors")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                loading = false

                if let error = error {
                    loadError = error.localizedDescription
                    mentors = []
                    return
                }

                guard let docs = snapshot?.documents else {
                    mentors = []
                    return
                }

                mentors = docs.compactMap { MentorProfile(doc: $0) }
            }
    }

    private func stopListener() {
        listener?.remove()
        listener = nil
    }
}

struct MentorProfile: Identifiable {
    let id: String
    let name: String
    let specialty: String
    let bio: String
    let email: String
    let phone: String
    let website: String

    // Optional image overrides from Firestore
    let imageURL: String?
    let imageName: String?

    // ✅ Add these so MentorCard compiles
    let rating: Double?
    let sessionsCompleted: Int?
    let experience: String?
    let contactInfo: String?

    init?(doc: QueryDocumentSnapshot) {
        let d = doc.data()
        self.id = doc.documentID
        self.name = d["name"] as? String ?? ""
        self.specialty = d["specialty"] as? String ?? ""
        self.bio = d["description"] as? String ?? ""
        self.email = d["email"] as? String ?? ""
        self.phone = d["phone"] as? String ?? ""
        self.website = d["website"] as? String ?? ""
        self.imageURL = d["imageURL"] as? String
        self.imageName = d["imageName"] as? String

        // ✅ Safely read optional fields (provide sensible defaults if missing)
        self.rating = d["rating"] as? Double
        self.sessionsCompleted = d["sessionsCompleted"] as? Int
        self.experience = d["experience"] as? String
        // Prefer explicit contactInfo; fall back to email if not present
        if let ci = d["contactInfo"] as? String, !ci.isEmpty {
            self.contactInfo = ci
        } else if let em = d["email"] as? String, !em.isEmpty {
            self.contactInfo = em
        } else {
            self.contactInfo = nil
        }
    }
}


struct MentorCard: View {
    let mentor: MentorProfile
    let onBookMeeting: () -> Void

    // Map specialty → asset name (same mapping style as MentorGridCard)
    private static let specialtyImage: [String: String] = [
        "technology": "mentor_tech",
        "engineering": "mentor_engineering",
        "design": "mentor_design",
        "business": "mentor_business",
        "marketing": "mentor_marketing",
        "finance": "mentor_finance",
        "healthcare": "mentor_health",
        "education": "mentor_education",
        "law": "mentor_law",
        "science": "mentor_science",
        "arts": "mentor_arts",
        "other": "mentor"
    ]

    private var resolvedAssetName: String {
        if let explicit = mentor.imageName, !explicit.isEmpty {
            return explicit
        }
        let key = mentor.specialty.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return Self.specialtyImage[key] ?? "mentor" // fallback
    }

    var body: some View {
        VStack(spacing: 16) {
            // Top image (remote URL if provided, else local asset by specialty)
            ZStack(alignment: .topTrailing) {
                Group {
                    if let urlStr = mentor.imageURL, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable().scaledToFill()
                            case .failure(_):
                                Image(resolvedAssetName).resizable().scaledToFill()
                            case .empty:
                                Color.gray.opacity(0.15)
                            @unknown default:
                                Image(resolvedAssetName).resizable().scaledToFill()
                            }
                        }
                    } else {
                        Image(resolvedAssetName)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(height: 160)
                .clipped()
                .cornerRadius(12)

                // Subtle star (favorite) icon
                Image(systemName: "star.fill")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(8)
                    .background(Color.black.opacity(0.25))
                    .clipShape(Circle())
                    .padding(8)
            }

            // Title + specialty
            VStack(alignment: .leading, spacing: 6) {
                Text(mentor.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.applixyDark)

                Text(mentor.specialty)
                    .font(.subheadline)
                    .foregroundColor(.applixySecondary)
            }

            // Bio
            if !mentor.bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(mentor.bio)
                    .font(.body)
                    .foregroundColor(.applixyDark)
                    .lineLimit(4)
            }

            // Contact chips (email / phone / website if present)
            HStack(spacing: 8) {
                if !mentor.email.isEmpty {
                    contactChip(
                        system: "envelope.fill",
                        text: mentor.email
                    )
                }
                if !mentor.phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    contactChip(
                        system: "phone.fill",
                        text: mentor.phone
                    )
                }
                if !mentor.website.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    contactChip(
                        system: "globe",
                        text: urlDisplay(mentor.website)
                    )
                }
                Spacer(minLength: 0)
            }

            // Book Meeting button
            Button(action: onBookMeeting) {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                    Text("Book Meeting")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.applixyWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [.applixyPrimary, .applixySecondary],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(12)
                .shadow(color: .applixyPrimary.opacity(0.25), radius: 6, x: 0, y: 3)
            }
        }
        .padding(16)
        .background(Color.applixyWhite)
        .cornerRadius(16)
        .shadow(color: .applixyLight, radius: 8, x: 0, y: 4)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func contactChip(system: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: system)
            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .font(.caption)
        .foregroundColor(.applixyDark)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.applixyLight.opacity(0.25))
        .cornerRadius(10)
    }

    private func urlDisplay(_ url: String) -> String {
        var s = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("https://") { s.removeFirst("https://".count) }
        if s.hasPrefix("http://") { s.removeFirst("http://".count) }
        if s.hasSuffix("/") { s.removeLast() }
        return s
    }
}


// MARK: - Mentor Grid Card
struct MentorGridCard: View {
    let mentor: MentorProfile
    let onBookMeeting: () -> Void
    
    // Map specialty → asset name (add these assets to your catalog)
    private static let specialtyImage: [String: String] = [
        "technology": "mentor_tech",
        "engineering": "mentor_engineering",
        "design": "mentor_design",
        "business": "mentor_business",
        "marketing": "mentor_marketing",
        "finance": "mentor_finance",
        "healthcare": "mentor_health",
        "education": "mentor_education",
        "law": "mentor_law",
        "science": "mentor_science",
        "arts": "mentor_arts",
        "other": "mentor"
    ]
    
    private var resolvedAssetName: String {
        if let explicit = mentor.imageName, !explicit.isEmpty {
            return explicit
        }
        let key = mentor.specialty.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return Self.specialtyImage[key] ?? "mentor" // fallback
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // If a remote URL exists, load it; else use local asset mapped by specialty
                if let urlStr = mentor.imageURL, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        case .failure(_):
                            Image(resolvedAssetName).resizable().scaledToFill()
                        case .empty:
                            Color.gray.opacity(0.15)
                        @unknown default:
                            Image(resolvedAssetName).resizable().scaledToFill()
                        }
                    }
                } else {
                    Image(resolvedAssetName)
                        .resizable()
                        .scaledToFill()
                }
                
                // Star icon
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(8)
                    }
                    Spacer()
                }
                
                // Name + specialty overlay
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(mentor.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(mentor.specialty)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.95))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(colors: [.clear, .black.opacity(0.75)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                }
            }
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 180)
            .clipped()
            .cornerRadius(12, corners: [.topLeft, .topRight])
        }
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
        .onTapGesture { onBookMeeting() }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Resources View
struct ResourcesView: View {
    @State private var resources: [ResourceItem] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Standard Header
                    StandardHeaderView(
                        title: "Resources",
                        subtitle: " "
                    )
                    
                    // Content
                    if resources.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(resources) { resource in
                                    ResourceCard(resource: resource)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            //.navigationTitle("Resources")
            .onAppear {
                loadResources()
            }
        }
    }
    
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "link.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.applixyLight)
            
            Text("No resources available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.applixyDark)
            
            Text("Check back later for helpful resources")
                .foregroundColor(.applixySecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func loadResources() {
        resources = [
            ResourceItem(
                id: "1",
                title: "FAFSA Application",
                description: "Free Application for Federal Student Aid - Apply for financial aid",
                url: "https://studentaid.gov/h/apply-for-aid/fafsa",
                category: "Financial Aid",
                icon: "dollarsign.circle.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "2",
                title: "Common App",
                description: "Apply to multiple colleges with one application",
                url: "https://www.commonapp.org",
                category: "College Applications",
                icon: "building.2.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "3",
                title: "College Essay Tips",
                description: "Expert advice on writing compelling college essays",
                url: "https://www.collegeessayguy.com",
                category: "Writing Help",
                icon: "pencil.and.outline",
                isExternal: true
            ),
            ResourceItem(
                id: "4",
                title: "Scholarship Search Engines",
                description: "Find scholarships that match your profile",
                url: "https://www.fastweb.com",
                category: "Scholarships",
                icon: "magnifyingglass.circle.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "5",
                title: "College Board",
                description: "SAT prep, AP courses, and college planning resources",
                url: "https://www.collegeboard.org",
                category: "Testing",
                icon: "graduationcap.fill",
                isExternal: true
            )
            /*
            ResourceItem(
                id: "6",
                title: "Khan Academy",
                description: "Free SAT prep and academic courses",
                url: "https://www.khanacademy.org",
                category: "Test Prep",
                icon: "book.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "7",
                title: "College Essay Examples",
                description: "Successful college essay examples and analysis",
                url: "https://www.essayforum.com",
                category: "Writing Help",
                icon: "doc.text.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "8",
                title: "Financial Aid Calculator",
                description: "Estimate your financial aid eligibility",
                url: "https://studentaid.gov/aid-estimator",
                category: "Financial Aid",
                icon: "calculator.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "9",
                title: "College Visit Guide",
                description: "How to make the most of college visits",
                url: "https://www.collegeboard.org/student/plan/college-visits",
                category: "College Planning",
                icon: "location.fill",
                isExternal: true
            ),
            ResourceItem(
                id: "10",
                title: "Scholarship Application Tips",
                description: "YouTube channel with scholarship application strategies",
                url: "https://www.youtube.com/c/ScholarshipSystem",
                category: "Scholarships",
                icon: "play.circle.fill",
                isExternal: true
            )*/
        ]
    }
}

struct ResourceItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let url: String
    let category: String
    let icon: String
    let isExternal: Bool
}

struct ResourceCard: View {
    let resource: ResourceItem
    
    var body: some View {
        VStack(spacing: 0) {
            // Top image section
            ZStack(alignment: .topLeading) {
                // Resource image background
                Image("resource")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                
                // Category tag
                HStack {
                    Text(resource.category)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.6))
                        )
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
                
                // Title overlay
                VStack(alignment: .leading, spacing: 4) {
                Spacer()
                
                    Text(resource.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 12) {
            // Description
            Text(resource.description)
                    .font(.system(size: 14))
                .foregroundColor(.applixyDark)
                    .lineLimit(3)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
            
            // Action Button
            Button(action: {
                if let url = URL(string: resource.url) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Text("Visit Resource")
                        .fontWeight(.medium)
                    
                    if resource.isExternal {
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                    }
                }
                .foregroundColor(.applixyWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [.applixyPrimary, .applixySecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
            }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
            .background(Color.applixyWhite)
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 6, x: 0, y: 3)
    }
}

// MARK: - Add Opportunity View
struct AddOpportunityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var opportunityName = ""
    @State private var selectedCategory = "scholarship"
    @State private var deadline = Date()
    @State private var awardAmount = ""
    @State private var description = ""
    @State private var organization = ""
    @State private var website = ""
    @State private var targetDemographics: [String] = []
    @State private var newDemographic = ""
    @State private var isSubmitting = false
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    private let categories = [
        ("scholarship", "Scholarship", "dollarsign.circle.fill"),
        ("mentor", "Mentor", "person.2.fill"),
        ("resource", "Resource", "book.fill"),
        ("college", "College", "building.2.fill")
    ]
    
    private let commonDemographics = [
        "low-income", "high-achievers", "first-generation", 
        "minority", "women", "STEM", "arts", "athletics"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Add New Opportunity")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.applixyDark)
                        
                        Text("Share an opportunity with the community")
                            .font(.subheadline)
                            .foregroundColor(.applixySecondary)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        // Opportunity Name
                        FormField(
                            title: "Opportunity Name",
                            placeholder: "Enter the name of the opportunity",
                            text: $opportunityName
                        )
                        
                        // Category Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(categories, id: \.0) { category in
                                    CategoryButton(
                                        title: category.1,
                                        icon: category.2,
                                        isSelected: selectedCategory == category.0,
                                        action: { selectedCategory = category.0 }
                                    )
                                }
                            }
                        }
                        
                        // Deadline
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deadline")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            DatePicker("Select deadline", selection: $deadline, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.applixyLight.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        // Award Amount
                        FormField(
                            title: "Award Amount (Optional)",
                            placeholder: "e.g., $5,000 or Full Tuition",
                            text: $awardAmount
                        )
                        
                        // Organization
                        FormField(
                            title: "Organization",
                            placeholder: "Name of the organization or institution",
                            text: $organization
                        )
                        
                        // Website
                        FormField(
                            title: "Website (Optional)",
                            placeholder: "https://example.com",
                            text: $website
                        )
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            TextEditor(text: $description)
                                .frame(minHeight: 100)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.applixyLight.opacity(0.3))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.applixyLight, lineWidth: 1)
                                )
                        }
                        
                        // Target Demographics
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target Demographics (Optional)")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            // Add new demographic
                            HStack {
                                TextField("Add demographic", text: $newDemographic)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button("Add") {
                                    if !newDemographic.isEmpty {
                                        targetDemographics.append(newDemographic)
                                        newDemographic = ""
                                    }
                                }
                                .buttonStyle(.bordered)
                                .disabled(newDemographic.isEmpty)
                            }
                            
                            // Common demographics
                            if !commonDemographics.isEmpty {
                                Text("Common options:")
                                    .font(.caption)
                                    .foregroundColor(.applixySecondary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(commonDemographics, id: \.self) { demo in
                                        Button(demo) {
                                            if !targetDemographics.contains(demo) {
                                                targetDemographics.append(demo)
                                            }
                                        }
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.applixyLight.opacity(0.3))
                                        .foregroundColor(.applixyDark)
                                        .cornerRadius(16)
                                    }
                                }
                            }
                            
                            // Selected demographics
                            if !targetDemographics.isEmpty {
                                Text("Selected:")
                                    .font(.caption)
                                    .foregroundColor(.applixySecondary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(targetDemographics, id: \.self) { demo in
                                        HStack {
                                            Text(demo)
                                                .font(.caption)
                                            Button("×") {
                                                targetDemographics.removeAll { $0 == demo }
                                            }
                                            .font(.caption)
                                            .foregroundColor(.red)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.applixyPrimary.opacity(0.2))
                                        .foregroundColor(.applixyDark)
                                        .cornerRadius(16)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Submit Button
                    Button(action: submitOpportunity) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                            }
                            
                            Text(isSubmitting ? "Submitting..." : "Submit Opportunity")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.applixyPrimary, .applixySecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isSubmitting || opportunityName.isEmpty || organization.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(Color.applixyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.applixySecondary)
                }
            }
        }
        .alert("Success!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your opportunity has been submitted successfully!")
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func submitOpportunity() {
        guard !opportunityName.isEmpty, !organization.isEmpty else {
            errorMessage = "Please fill in all required fields."
            showingErrorAlert = true
            return
        }
        
        isSubmitting = true
        
        // Format deadline
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let deadlineString = formatter.string(from: deadline)
        
        // Parse award amount
        let awardAmountInt = Int(awardAmount.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)) ?? 0
        
        // Create the opportunity data
        let opportunityData: [String: Any] = [
            "active": true,
            "application_deadline": deadlineString,
            "award_amount": awardAmountInt,
            "description": description,
            "name": opportunityName,
            "organization": organization,
            "target_demographic": targetDemographics,
            "website": website,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Post to Firestore
        let db = Firestore.firestore()
        db.collection(selectedCategory)
            .addDocument(data: opportunityData) { error in
                DispatchQueue.main.async {
                    isSubmitting = false
                    
                    if let error = error {
                        errorMessage = "Failed to submit opportunity: \(error.localizedDescription)"
                        showingErrorAlert = true
                    } else {
                        showingSuccessAlert = true
                    }
                }
            }
    }
}

// MARK: - Form Field Component
struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.applixyDark)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.applixyLight.opacity(0.3))
                .cornerRadius(8)
        }
    }
}

// MARK: - Category Button Component
struct CategoryButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .applixyWhite : .applixyPrimary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .applixyWhite : .applixyDark)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ? 
                LinearGradient(colors: [.applixyPrimary, .applixySecondary], startPoint: .topLeading, endPoint: .bottomTrailing) :
                LinearGradient(colors: [Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.applixyLight, lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }
}

// MARK: - Add Mentor View
struct AddMentorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSuccess: (() -> Void)?
    
    @State private var mentorName = ""
    @State private var specialty = ""
    @State private var experience = ""
    @State private var contactInfo = ""
    @State private var bio = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var website = ""
    @State private var isSubmitting = false
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    private let specialties = [
        "Technology", "Business", "Healthcare", "Education", "Finance", 
        "Marketing", "Engineering", "Design", "Law", "Science", "Arts", "Other"
    ]
    
    private let experienceLevels = [
        "1-2 years", "3-5 years", "6-10 years", "11-15 years", "16+ years"
    ]
    
    init(onSuccess: (() -> Void)? = nil) {
        self.onSuccess = onSuccess
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Add New Mentor")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.applixyDark)
                        
                        Text("Share your expertise with the community")
                            .font(.subheadline)
                            .foregroundColor(.applixySecondary)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        // Mentor Name
                        FormField(
                            title: "Full Name",
                            placeholder: "Enter your full name",
                            text: $mentorName
                        )
                        
                        // Specialty Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Specialty")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(specialties, id: \.self) { spec in
                                    Button(spec) {
                                        specialty = spec
                                    }
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        specialty == spec ? 
                                        LinearGradient(colors: [.applixyPrimary, .applixySecondary], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                        LinearGradient(colors: [Color.applixyLight.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .foregroundColor(specialty == spec ? .white : .applixyDark)
                                    .cornerRadius(16)
                                }
                            }
                        }
                        
                        // Experience Level
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Experience Level")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(experienceLevels, id: \.self) { level in
                                    Button(level) {
                                        experience = level
                                    }
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        experience == level ? 
                                        LinearGradient(colors: [.applixyPrimary, .applixySecondary], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                        LinearGradient(colors: [Color.applixyLight.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .foregroundColor(experience == level ? .white : .applixyDark)
                                    .cornerRadius(16)
                                }
                            }
                        }
                        
                        // Contact Information
                        FormField(
                            title: "Email",
                            placeholder: "your.email@example.com",
                            text: $email
                        )
                        
                        FormField(
                            title: "Phone (Optional)",
                            placeholder: "(555) 123-4567",
                            text: $phone
                        )
                        
                        FormField(
                            title: "Website (Optional)",
                            placeholder: "https://yourwebsite.com",
                            text: $website
                        )
                        
                        // Bio
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio")
                                .font(.headline)
                                .foregroundColor(.applixyDark)
                            
                            TextEditor(text: $bio)
                                .frame(minHeight: 120)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.applixyLight.opacity(0.3))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.applixyLight, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Submit Button
                    Button(action: submitMentor) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "person.badge.plus")
                                    .font(.title3)
                            }
                            
                            Text(isSubmitting ? "Submitting..." : "Submit Mentor Profile")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.applixyPrimary, .applixySecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isSubmitting || mentorName.isEmpty || specialty.isEmpty || email.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(Color.applixyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.applixySecondary)
                }
            }
        }
        .alert("Success!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                onSuccess?()
                dismiss()
            }
        } message: {
            Text("Your mentor profile has been submitted successfully!")
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func submitMentor() {
        guard !mentorName.isEmpty, !specialty.isEmpty, !email.isEmpty else {
            errorMessage = "Please fill in all required fields."
            showingErrorAlert = true
            return
        }
        
        isSubmitting = true
        
        // Create the mentor data
        let mentorData: [String: Any] = [
            "active": true,
            "description": bio,
            "email": email,
            "name": mentorName,
            "phone": phone,
            "specialty": specialty,
            "experience": experience,
            "website": website,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Post to Firestore
        let db = Firestore.firestore()
        db.collection("mentors")
            .addDocument(data: mentorData) { error in
                DispatchQueue.main.async {
                    isSubmitting = false
                    
                    if let error = error {
                        errorMessage = "Failed to submit mentor profile: \(error.localizedDescription)"
                        showingErrorAlert = true
                    } else {
                        showingSuccessAlert = true
                    }
                }
            }
    }
}

struct AppUser: Codable {
    let uid: String
    let email: String
    let createdAt: Timestamp
    var firstName: String?
    var lastName: String?
    var onboardingComplete: Bool
}

enum UserService {
    static let coll = Firestore.firestore().collection("users")

    static func createUserDocument(uid: String, email: String,
                                   firstName: String? = nil,
                                   lastName: String? = nil,
                                   onboardingComplete: Bool = false) async throws {
        let user = AppUser(
            uid: uid,
            email: email.lowercased(),
            createdAt: Timestamp(date: Date()),
            firstName: firstName,
            lastName: lastName,
            onboardingComplete: onboardingComplete
        )
        try coll.document(uid).setData(from: user, merge: true)
    }

    static func fetchUser(uid: String) async throws -> AppUser? {
        let snap = try await coll.document(uid).getDocument()
        return try snap.data(as: AppUser?.self)
    }
}



#Preview {
    ContentView()
}


