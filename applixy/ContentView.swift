//
//  ContentView.swift
//  applixy
//
//  Created by Sinchana Nama on 10/7/25.
//

import SwiftUI

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
                
                Spacer()
                
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
                
                // Sign up link
                Button("Don't have an account? Sign up") {
                    showingCreatePassword = true
                }
                .font(.subheadline)
                .foregroundColor(.applixyPrimary)
                .padding(.top, 8)
                
                // Or sign up with section
                VStack(spacing: 20) {
                    // Or sign up with divider
                    HStack {
                        Rectangle()
                            .fill(Color.applixyLight)
                            .frame(height: 1)
                        
                        Text("or sign up with")
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
    
    
    var body: some View {
        
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Standard Header
                    StandardHeaderView(
                        title: "Discover",
                        subtitle: " "
                    )
                    
                    // Card Stack
                    cardStackView
                }
            }
            .onAppear {
                loadSampleOpportunities()
            }
            .sheet(isPresented: $showingDetail) {
                if let opportunity = selectedOpportunity {
                    OpportunityDetailView(opportunity: opportunity)
                }
            }
        
    }
    
    
    // MARK: - Card Stack View
    private var cardStackView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack {
                if opportunities.isEmpty {
                    emptyStateView
                } else if currentIndex >= opportunities.count {
                    allCaughtUpView
                } else {
                    let currentOpportunity = opportunities[currentIndex]
                    ZStack {
                        // Main card
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
                        
            // Overlay action buttons (positioned like in your image)
            VStack {
            Spacer()
            
            HStack(spacing: 20) {
                                // X button (left)
                Button(action: {
                        skipOpportunity()
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.applixyWhite)
                                            .frame(width: 60, height: 60)
                                            .shadow(color: .applixyPrimary.opacity(0.2), radius: 8, x: 0, y: 4)
                                        
                        Image(systemName: "xmark")
                            .font(.title2)
                                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                                }
                
                                // Heart button (center)
                Button(action: {
                                    saveOpportunity(currentOpportunity)
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.applixyWhite)
                                            .frame(width: 70, height: 70)
                                            .shadow(color: .applixyPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                                        
                                        Image(systemName: "heart.fill")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.applixyPrimary)
                                    }
                                }
                                
                                // Star button (right)
                Button(action: {
                                    saveOpportunity(currentOpportunity)
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.applixyWhite)
                        .frame(width: 60, height: 60)
                                            .shadow(color: .applixyPrimary.opacity(0.2), radius: 8, x: 0, y: 4)
                                        
                                        Image(systemName: "star.fill")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.applixyPrimary)
                                    }
                                }
                            }
                            .offset(y: 20) // Position buttons slightly overlapping the card
                        }
                    }
                }
            }
            .frame(height: 400)
            
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
    private func loadSampleOpportunities() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        opportunities = [
            OpportunityData(
                id: "1",
                title: "Gates Millennium Scholars Program",
                type: "Scholarship",
                deadline: formatter.date(from: "2024-12-15") ?? today,
                awardAmount: "Full tuition + expenses",
                eligibility: "High school seniors, minimum 3.3 GPA, leadership potential",
                details: "The Gates Millennium Scholars Program provides outstanding minority students with an opportunity to complete an undergraduate college education in any discipline they choose.",
                link: "https://www.gmsp.org",
                tags: ["STEM", "Leadership", "Minority Programs"]
            ),
            OpportunityData(
                id: "2",
                title: "MIT Summer Research Program",
                type: "Program",
                deadline: formatter.date(from: "2024-12-30") ?? today,
                awardAmount: "$5,000 stipend",
                eligibility: "Undergraduate students, STEM majors, minimum 3.0 GPA",
                details: "10-week summer research program at MIT for underrepresented students in STEM fields.",
                link: "https://web.mit.edu/srp",
                tags: ["STEM", "Research", "Women in Tech"]
            ),
            OpportunityData(
                id: "3",
                title: "Stanford University",
                type: "College",
                deadline: formatter.date(from: "2024-11-30") ?? today,
                awardAmount: "Need-based financial aid",
                eligibility: "High school seniors, strong academic record",
                details: "World-renowned private research university with comprehensive financial aid program.",
                link: "https://admission.stanford.edu",
                tags: ["STEM", "Arts", "Leadership"]
            ),
            OpportunityData(
                id: "4",
                title: "Coca-Cola Scholars Foundation",
                type: "Scholarship",
                deadline: formatter.date(from: "2025-01-15") ?? today,
                awardAmount: "$20,000",
                eligibility: "High school seniors, minimum 3.0 GPA, leadership and service",
                details: "Merit-based scholarship program recognizing students who demonstrate leadership and service.",
                link: "https://www.coca-colascholarsfoundation.org",
                tags: ["Leadership", "Community Service"]
            ),
            OpportunityData(
                id: "5",
                title: "Google Summer of Code",
                type: "Program",
                deadline: formatter.date(from: "2025-02-15") ?? today,
                awardAmount: "$3,000 stipend",
                eligibility: "University students, programming experience",
                details: "Global program that brings new contributors into open source software development.",
                link: "https://summerofcode.withgoogle.com",
                tags: ["STEM", "Women in Tech", "Programming"]
            ),
            OpportunityData(
                id: "6",
                title: "Harvard University",
                type: "College",
                deadline: formatter.date(from: "2024-12-01") ?? today,
                awardAmount: "Need-based financial aid",
                eligibility: "High school seniors, exceptional academic achievement",
                details: "Ivy League institution with generous financial aid for families earning less than $65,000.",
                link: "https://college.harvard.edu",
                tags: ["STEM", "Arts", "Leadership"]
            ),
            OpportunityData(
                id: "7",
                title: "Women in Technology Scholarship",
                type: "Scholarship",
                deadline: formatter.date(from: "2025-01-30") ?? today,
                awardAmount: "$5,000",
                eligibility: "Female students, STEM majors, minimum 3.0 GPA",
                details: "Scholarship supporting women pursuing degrees in technology and engineering.",
                link: "https://www.womenintechnology.org",
                tags: ["STEM", "Women in Tech"]
            ),
            OpportunityData(
                id: "8",
                title: "NASA Internship Program",
                type: "Program",
                deadline: formatter.date(from: "2025-03-15") ?? today,
                awardAmount: "$6,000 stipend",
                eligibility: "Undergraduate/graduate students, STEM majors",
                details: "Hands-on research experience at NASA centers across the country.",
                link: "https://intern.nasa.gov",
                tags: ["STEM", "Research", "Women in Tech"]
            )
        ]
        print("Loaded \(opportunities.count) opportunities")
        currentIndex = 0
    }
    
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
                                    Text("SKIP")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
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
                                    Text("SAVE")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
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
                    Button("Save") {
                        // Save action
                        dismiss()
                    }
                    .foregroundColor(.applixyWhite)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.applixyPrimary)
                    .cornerRadius(20)
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
    @State private var showingBookingConfirmation = false
    @State private var selectedMentor: MentorProfile?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Standard Header
                    StandardHeaderView(
                        title: "Mentors",
                        subtitle: " "
                    )
                    
                    // Content
                    if mentors.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 16) {
                                ForEach(mentors) { mentor in
                                    MentorGridCard(mentor: mentor) {
                                        selectedMentor = mentor
                                        showingBookingConfirmation = true
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
           // .navigationTitle("Mentors")
            .onAppear {
                loadMentors()
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
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.applixyDark)
            
            Text("Check back later for mentor profiles")
                .foregroundColor(.applixySecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func loadMentors() {
        mentors = [
            MentorProfile(
                id: "1",
                name: "Dr. Sarah Chen",
                specialty: "STEM Applications",
                experience: "10+ years",
                contactInfo: "sarah.chen@example.com",
                bio: "Former MIT admissions officer with 10+ years experience helping students with STEM applications. Specializes in engineering and computer science programs.",
                rating: 4.9,
                sessionsCompleted: 150
            ),
            MentorProfile(
                id: "2",
                name: "Marcus Johnson",
                specialty: "Scholarship Strategy",
                experience: "8+ years",
                contactInfo: "marcus.j@example.com",
                bio: "Scholarship expert who has helped students secure over $2M in funding. Focuses on merit-based and need-based scholarships.",
                rating: 4.8,
                sessionsCompleted: 200
            ),
            MentorProfile(
                id: "3",
                name: "Dr. Elena Rodriguez",
                specialty: "First-Gen Support",
                experience: "12+ years",
                contactInfo: "elena.rodriguez@example.com",
                bio: "First-generation college graduate and admissions counselor specializing in supporting FGLI students through the application process.",
                rating: 4.9,
                sessionsCompleted: 180
            ),
            MentorProfile(
                id: "4",
                name: "James Park",
                specialty: "Ivy League Prep",
                experience: "15+ years",
                contactInfo: "james.park@example.com",
                bio: "Harvard graduate and former admissions reader with expertise in competitive college applications and essay writing.",
                rating: 4.7,
                sessionsCompleted: 300
            ),
            MentorProfile(
                id: "5",
                name: "Dr. Aisha Williams",
                specialty: "Minority Programs",
                experience: "9+ years",
                contactInfo: "aisha.williams@example.com",
                bio: "Diversity and inclusion expert with deep knowledge of minority-focused scholarships and programs. Passionate about equity in education.",
                rating: 4.8,
                sessionsCompleted: 120
            )
        ]
    }
}

struct MentorProfile: Identifiable {
    let id: String
    let name: String
    let specialty: String
    let experience: String
    let contactInfo: String
    let bio: String
    let rating: Double
    let sessionsCompleted: Int
}

struct MentorCard: View {
    let mentor: MentorProfile
    let onBookMeeting: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mentor.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.applixyDark)
                    
                    Text(mentor.specialty)
                        .font(.subheadline)
                        .foregroundColor(.applixySecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", mentor.rating))
                            .font(.caption)
                            .foregroundColor(.applixyDark)
                    }
                    
                    Text("\(mentor.sessionsCompleted) sessions")
                        .font(.caption2)
                        .foregroundColor(.applixySecondary)
                }
            }
            
            // Bio
            Text(mentor.bio)
                .font(.body)
                .foregroundColor(.applixyDark)
                .lineLimit(3)
            
            // Experience and Contact
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Experience")
                        .font(.caption)
                        .foregroundColor(.applixySecondary)
                    Text(mentor.experience)
                        .font(.subheadline)
                        .foregroundColor(.applixyDark)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Contact")
                        .font(.caption)
                        .foregroundColor(.applixySecondary)
                    Text(mentor.contactInfo)
                        .font(.caption)
                        .foregroundColor(.applixyPrimary)
                }
            }
            
            // Book Meeting Button
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
                    LinearGradient(
                        colors: [.applixyPrimary, .applixySecondary],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
            }
        }
        .padding(20)
        .background(Color.applixyWhite)
        .cornerRadius(16)
        .shadow(color: .applixyLight, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Mentor Grid Card
struct MentorGridCard: View {
    let mentor: MentorProfile
    let onBookMeeting: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Image placeholder with overlay
            ZStack {
                // Image placeholder
                Image("mentor")
                        .resizable()
                        
                // Star icon in top right
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
                
                // Name and specialty overlay at bottom
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
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            
        }
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
        .onTapGesture {
            onBookMeeting()
        }
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
            ),
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
            )
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

#Preview {
    ContentView()
}
