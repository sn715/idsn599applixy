//
//  ContentView.swift
//  applixy
//
//  Created by Sinchana Nama on 10/7/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

// MARK: - Firebase Backend Code - Retrieving Data
import FirebaseFirestore
// NOTE: no FirebaseFirestoreSwift import. We map documents dynamically (schema-light).

// MARK: - Brand Colors
extension Color {
    static let applixyPrimary = Color(hex: "#1B1471")      // Deep Indigo
    static let applixySecondary = Color(hex: "#8091DF")     // Periwinkle
    static let applixyLight = Color(hex: "#CBCFF8")         // Light Lavender
    static let applixyBackground = Color(hex: "#F5F6FF")    // Off-white
    static let applixyDark = Color(hex: "#14131C")          // Charcoal
    static let applixyWhite = Color(hex: "#FFFFFF")         // White
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
    @State private var currentStep = 0
    @State private var userProfile = UserProfileData()
    @State private var showingMainApp = false
    
    var body: some View {
        if showingOnboarding {
            OnboardingFlowView(
                currentStep: $currentStep,
                userProfile: $userProfile,
                showingMainApp: $showingMainApp
            )
        } else {
            LandingPageView(showingOnboarding: $showingOnboarding)
        }
    }
}

// MARK: - Landing Page View
struct LandingPageView: View {
    @Binding var showingOnboarding: Bool
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 50
    @State private var textOpacity: Double = 0.0
    @State private var buttonOffset: CGFloat = 30
    @State private var buttonOpacity: Double = 0.0
    
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
                    // Applixy Logo
                    ZStack {
                        // Magnifying glass background circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.applixySecondary, .applixyLight],
                                    startPoint: .bottomTrailing,
                                    endPoint: .topLeading
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: .applixyPrimary.opacity(0.2), radius: 20, x: 0, y: 10)
                        
                        // Magnifying glass frame
                        Circle()
                            .stroke(Color.applixyPrimary, lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        // Star inside the magnifying glass
                        Image(systemName: "star.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.applixyDark)
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0)) {
                            logoScale = 1.0
                            logoOpacity = 1.0
                        }
                    }
                    
                    // App Name and Tagline
                    VStack(spacing: 12) {
                        Text("Applixy")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.applixyDark)
                            .offset(y: textOffset)
                            .opacity(textOpacity)
                        
                        Text("Discover your perfect opportunities")
                            .font(.title2)
                            .foregroundColor(.applixySecondary)
                            .multilineTextAlignment(.center)
                            .offset(y: textOffset)
                            .opacity(textOpacity)
                        
                        Text("Find scholarships, colleges, and programs tailored just for you")
                            .font(.subheadline)
                            .foregroundColor(.applixySecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .offset(y: textOffset)
                            .opacity(textOpacity)
                    }
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                            textOffset = 0
                            textOpacity = 1.0
                        }
                    }
                }
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showingOnboarding = true
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.title3)
                    }
                    .foregroundColor(.applixyWhite)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.applixyPrimary, .applixySecondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: .applixyPrimary.opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .offset(y: buttonOffset)
                .opacity(buttonOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8).delay(1.2)) {
                        buttonOffset = 0
                        buttonOpacity = 1.0
                    }
                }
                .scaleEffect(buttonOpacity == 1.0 ? 1.0 : 0.9)
                .animation(.easeInOut(duration: 0.2), value: buttonOpacity)
                
                // Decorative elements
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.applixyLight)
                            .frame(width: 8, height: 8)
                            .opacity(0.6)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever()
                                .delay(Double(index) * 0.3),
                                value: buttonOpacity
                            )
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Onboarding Flow View
struct OnboardingFlowView: View {
    @Binding var currentStep: Int
    @Binding var userProfile: UserProfileData
    @Binding var showingMainApp: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    if currentStep < 4 {
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
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showingMainApp) {
            MainTabView()
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
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tell us about yourself")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.applixyDark)
                
                Text("Let's start with the basics")
                    .font(.subheadline)
                    .foregroundColor(.applixySecondary)
            }
            
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
        }
        .padding()
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
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Demographics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.applixyDark)
                
                Text("Help us personalize your experience")
                    .font(.subheadline)
                    .foregroundColor(.applixySecondary)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                CustomPicker(title: "Gender", selection: $userProfile.gender, options: genders, icon: "person.2.fill")
                CustomPicker(title: "Race/Ethnicity", selection: $userProfile.race, options: races, icon: "globe")
                
                VStack(spacing: 15) {
                    CustomToggle(title: "First Generation College Student", isOn: $userProfile.isFirstGen, icon: "graduationcap.fill")
                    CustomToggle(title: "Low Income Background", isOn: $userProfile.isLowIncome, icon: "dollarsign.circle.fill")
                }
            }
        }
        .padding()
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
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Academic Information")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.applixyDark)
                
                Text("Tell us about your academic background")
                    .font(.subheadline)
                    .foregroundColor(.applixySecondary)
            }
            
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
        }
        .padding()
    }
}

struct InterestsView: View {
    @Binding var userProfile: UserProfileData
    
    private let interestOptions = [
        "STEM", "Arts", "Leadership", "Business",
        "Community Service", "Women in Tech", "Minority Programs"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Interests")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.applixyDark)
                
                Text("Select all that apply to help us find the best opportunities for you")
                    .font(.subheadline)
                    .foregroundColor(.applixySecondary)
            }
            
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
        }
        .padding()
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
    var body: some View {
        TabView {
            DiscoveryView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Discovery")
                }
            
            MentorsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Mentors")
                }
            
            ResourcesView()
                .tabItem {
                    Image(systemName: "link")
                    Text("Resources")
                }
        }
        .accentColor(.applixyPrimary)
    }
}

// MARK: - Discovery View
struct DiscoveryView: View {
    @State private var opportunities: [OpportunityData] = []
    @State private var currentIndex = 0
    @State private var dragOffset = CGSize.zero
    @State private var showingDetail = false
    @State private var selectedOpportunity: OpportunityData?
    @State private var showingSavedAlert = false
    @State private var showingSkippedAlert = false
    @State private var listener: ListenerRegistration?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Card Stack
                    cardStackView
                    
                    // Action Buttons
                    actionButtonsView
                }
            }
            //.navigationTitle("Discovery")
            .onAppear {
                ensureSignedInAndLoad() // loads from Firestore and shows different docs per card index
            }
            .onDisappear {
                // If you switch to addSnapshotListener, clean up here:
                listener?.remove()
            }
            .sheet(isPresented: $showingDetail) {
                if let opportunity = selectedOpportunity {
                    OpportunityDetailView(opportunity: opportunity)
                }
            }
            .alert("Opportunity Saved!", isPresented: $showingSavedAlert) {
                Button("OK") { }
            } message: {
                Text("This opportunity has been added to your saved list.")
            }
            .alert("Opportunity Skipped", isPresented: $showingSkippedAlert) {
                Button("OK") { }
            } message: {
                Text("You can always find this opportunity again later.")
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Discover")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.applixyDark)
                    
                    Text("Swipe to explore opportunities")
                        .font(.subheadline)
                        .foregroundColor(.applixySecondary)
                }
                
                Spacer()
                
                // Profile/Stats button
                Button(action: {}) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.applixyPrimary)
                }
            }
            .padding(.horizontal)
            
            // Progress indicator
            if !opportunities.isEmpty && currentIndex < opportunities.count {
                HStack {
                    Text("\(currentIndex + 1) of \(opportunities.count)")
                        .font(.caption)
                        .foregroundColor(.applixySecondary)
                    
                    Spacer()
                    
                    Text("New today")
                        .font(.caption)
                        .foregroundColor(.applixySecondary)
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
    
    // MARK: - Card Stack View
    private var cardStackView: some View {
        VStack(spacing: 0) {
            // Add margin above the card
            Spacer()
                .frame(height: 30)
            
            ZStack {
                if opportunities.isEmpty {
                    emptyStateView
                } else if currentIndex >= opportunities.count {
                    allCaughtUpView
                } else {
                    let currentOpportunity = opportunities[currentIndex] // <-- different index → different doc
                    SwipeCardView(
                        opportunity: currentOpportunity,
                        dragOffset: $dragOffset,
                        onSwipeLeft: {
                            skipOpportunity()
                        },
                        onSwipeUp: {
                            selectedOpportunity = currentOpportunity
                            showingDetail = true
                        },
                        onSave: {
                            saveOpportunity(currentOpportunity)
                        }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                handleSwipeGesture(value: value, opportunity: currentOpportunity)
                            }
                    )
                }
            }
            .frame(height: 500)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        VStack(spacing: 0) {
            // Add margin between card and buttons
            Spacer()
                .frame(height: 30)
            
            HStack(spacing: 40) {
                // Skip Button
                Button(action: {
                    if currentIndex < opportunities.count {
                        skipOpportunity()
                    }
                }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.red)
                            .frame(width: 60, height: 60)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(currentIndex >= opportunities.count)
                
                // Info Button
                Button(action: {
                    if currentIndex < opportunities.count {
                        selectedOpportunity = opportunities[currentIndex]
                        showingDetail = true
                    }
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.applixySecondary)
                        .frame(width: 60, height: 60)
                        .background(Color.applixyLight)
                        .clipShape(Circle())
                }
                .disabled(currentIndex >= opportunities.count)
                
                // Save Button
                Button(action: {
                    if currentIndex < opportunities.count {
                        saveOpportunity(opportunities[currentIndex])
                    }
                }) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundColor(.applixyWhite)
                        .frame(width: 60, height: 60)
                        .background(
                            LinearGradient(
                                colors: [.applixyPrimary, .applixySecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: .applixyPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(currentIndex >= opportunities.count)
            }
        }
        .padding(.bottom, 50)
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
    
    // MARK: - Helper Functions (Rotation & Firestore)
    private func handleSwipeGesture(value: DragGesture.Value, opportunity: OpportunityData) {
        let threshold: CGFloat = 100
        /*withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            if abs(value.translation.x) > threshold {
                if value.translation.x > 0 {
                    // Swipe right - save
                    saveOpportunity(opportunity)
                } else {
                    // Swipe left - skip
                    skipOpportunity()
                }
            } else if value.translation.y < -threshold {
                // Swipe up - show details
                selectedOpportunity = opportunity
                showingDetail = true
            }
            dragOffset = .zero
        }*/
    }
    
    private func saveOpportunity(_ opportunity: OpportunityData) {
        print("Saved: \(opportunity.title)")
        showingSavedAlert = true
        nextOpportunity()
    }
    
    private func skipOpportunity() {
        print("Skipped opportunity")
        showingSkippedAlert = true
        nextOpportunity()
    }
    
    private func nextOpportunity() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentIndex += 1            // <-- advancing index shows the next Firestore doc
        }
    }

    // MARK: - Firestore: auth + load (schema-light mapping)
    private func ensureSignedInAndLoad() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { _, error in
                if let error = error {
                    print("Auth error: \(error.localizedDescription)")
                    // Reads may still work if rules allow public access.
                    self.loadScholarshipOpportunities()
                    return
                }
                self.loadScholarshipOpportunities()
            }
        } else {
            self.loadScholarshipOpportunities()
        }
    }

    private func loadScholarshipOpportunities() {
        let db = Firestore.firestore()
        // You can add .order(by: "timestamp", descending: true) if you store one.
        db.collection("scholarship")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Firestore load error: \(error.localizedDescription)")
                    return
                }

                let docs = snapshot?.documents ?? []

                // Map each doc at runtime (no fixed struct). This makes the UI tolerant of schema changes.
                var mapped: [OpportunityData] = docs.compactMap { doc in
                    let data = doc.data()

                    // Title from multiple possible keys
                    let title = (data["name"] as? String)
                                ?? (data["title"] as? String)
                                ?? "Scholarship"

                    // Deadline can be string like "November 15, 2025" or just "November"
                    let deadlineString = (data["application_deadline"] as? String)
                                       ?? (data["deadline"] as? String)

                    // Award amount normalization to display string
                    let awardAmountStr: String = {
                        if let n = data["award_amount"] as? NSNumber {
                            return "$\(n.intValue)"
                        } else if let i = data["award_amount"] as? Int {
                            return "$\(i)"
                        } else if let s = data["award_amount"] as? String {
                            return s
                        } else {
                            return "—"
                        }
                    }()

                    // Description/details
                    let details = (data["description"] as? String)
                                ?? (data["details"] as? String)
                                ?? ""

                    // Tags / eligibility
                    let tags = (data["target_demographic"] as? [String])
                             ?? (data["tags"] as? [String])
                             ?? []
                    let eligibility = tags.joined(separator: ", ")

                    // Link
                    let link = (data["website"] as? String)
                             ?? (data["link"] as? String)
                             ?? ""

                    return OpportunityData(
                        id: doc.documentID,
                        title: title,
                        type: "Scholarship",
                        deadline: parseDeadline(deadlineString),
                        awardAmount: awardAmountStr,
                        eligibility: eligibility,
                        details: details,
                        link: link,
                        tags: tags
                    )
                }

                // Optional shuffle so the rotation feels fresh (comment out if you want Firestore order)
                // mapped.shuffle()

                self.opportunities = mapped
                self.currentIndex = 0
            }

        // --- Real-time version (optional) ---
        // listener = db.collection("scholarship")
        //     .addSnapshotListener { snapshot, error in
        //         if let error = error { print("Listener error: \(error.localizedDescription)"); return }
        //         let docs = snapshot?.documents ?? []
        //         // Use same mapping block as above to update self.opportunities live.
        //     }
    }

    // Convert "November" or "November 15, 2025" to Date; fallback to today.
    private func parseDeadline(_ raw: String?) -> Date {
        let today = Date()
        guard let raw = raw, !raw.trimmingCharacters(in: .whitespaces).isEmpty else { return today }

        let f1 = DateFormatter()
        f1.locale = Locale(identifier: "en_US_POSIX")
        f1.dateFormat = "MMMM d, yyyy"
        if let d = f1.date(from: raw) { return d }

        let f2 = DateFormatter()
        f2.locale = Locale(identifier: "en_US_POSIX")
        f2.dateFormat = "MMMM"
        if let monthDate = f2.date(from: raw) {
            var comps = Calendar.current.dateComponents([.year], from: today)
            comps.month = Calendar.current.component(.month, from: monthDate)
            comps.day = 28
            return Calendar.current.date(from: comps) ?? today
        }

        return today
    }
}

// MARK: - Data Models
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
    let onSwipeLeft: () -> Void
    let onSwipeUp: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
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
                
                Spacer()
                
                Button(action: onSave) {
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.applixyPrimary)
                }
            }
            
            // Deadline and Award
            VStack(spacing: 12) {
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
            
            // Eligibility
            Text(opportunity.eligibility)
                .font(.body)
                .foregroundColor(.applixyDark)
                .lineLimit(3)
            
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
            
            Spacer()
            
            // Action Buttons
            HStack {
                Button("Skip") {
                    onSwipeLeft()
                }
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.red.opacity(0.1))
                .cornerRadius(20)
                
                Spacer()
                
                Button("More Info") {
                    onSwipeUp()
                }
                .foregroundColor(.applixyWhite)
                .padding(.horizontal, 20)
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
        }
        .padding(24)
        .background(Color.applixyWhite)
        .cornerRadius(20)
        .shadow(
            color: .applixyPrimary.opacity(0.1),
            radius: 20,
            x: 0,
            y: 10
        )
        .offset(x: dragOffset.width, y: dragOffset.height)
        .rotationEffect(.degrees(dragOffset.width / 20))
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
                    // Header
                    headerView
                    
                    // Content
                    if mentors.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(mentors) { mentor in
                                    MentorCard(mentor: mentor) {
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
            .alert("Mock Meeting Booked!", isPresented: $showingBookingConfirmation) {
                Button("OK") { }
            } message: {
                if let mentor = selectedMentor {
                    Text("You've booked a mock meeting with \(mentor.name). We'll send you a confirmation email shortly!")
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mentors")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.applixyDark)
                    
                    Text("Connect with experienced mentors")
                        .font(.subheadline)
                        .foregroundColor(.applixySecondary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.top)
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
        ensureSignedIn {
            let db = Firestore.firestore()
            db.collection("mentor")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Mentors load error: \(error.localizedDescription)")
                        self.mentors = []
                        return
                    }

                    let docs = snapshot?.documents ?? []
                    self.mentors = docs.compactMap { doc in
                        let data = doc.data()

                        let name = (data["name"] as? String) ?? "Mentor"
                        let email = (data["email"] as? String) ?? ""
                        let phoneAny = data["phone_number"] ?? ""
                        let phone = (phoneAny as? String) ?? String(describing: phoneAny)
                        let bio = (data["description"] as? String) ?? ""

                        // specialty might be [String] OR (from your screenshot) a single string like
                        // '["Scholarship strategy","college applications","financial aid"]'
                        let specialtyText: String = {
                            if let arr = data["specialty"] as? [String] {
                                return arr.joined(separator: ", ")
                            } else if let s = data["specialty"] as? String {
                                return s.trimmingCharacters(in: .whitespacesAndNewlines)
                            } else {
                                return ""
                            }
                        }()

                        // optional fields; default if not present
                        let rating = (data["rating"] as? Double) ?? 4.8
                        let sessions = (data["sessionsCompleted"] as? Int) ?? 100

                        return MentorProfile(
                            id: doc.documentID,
                            name: name,
                            specialty: specialtyText.isEmpty ? "Mentoring" : specialtyText,
                            experience: (data["experience"] as? String) ?? "—",
                            contactInfo: email.isEmpty ? phone : email,
                            bio: bio,
                            rating: rating,
                            sessionsCompleted: sessions
                        )
                    }
                }
        }
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

// MARK: - Resources View
struct ResourcesView: View {
    @State private var resources: [ResourceItem] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
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
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Resources")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.applixyDark)
                    
                    Text("Helpful links and tools for your journey")
                        .font(.subheadline)
                        .foregroundColor(.applixySecondary)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.top)
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
        ensureSignedIn {
            let db = Firestore.firestore()
            db.collection("resources")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Resources load error: \(error.localizedDescription)")
                        self.resources = []
                        return
                    }

                    let docs = snapshot?.documents ?? []
                    self.resources = docs.compactMap { doc in
                        let data = doc.data()
                        let title = (data["name"] as? String)
                                 ?? (data["title"] as? String)
                                 ?? "Resource"
                        let link = (data["link"] as? String) ?? ""
                        let description = (data["description"] as? String) ?? ""

                        // Optional/derived fields (use sensible defaults if not stored)
                        let category = (data["category"] as? String) ?? "General"
                        let icon = (data["icon"] as? String) ?? "link"
                        let isExternal = (data["isExternal"] as? Bool) ?? true

                        return ResourceItem(
                            id: doc.documentID,
                            title: title,
                            description: description,
                            url: link,
                            category: category,
                            icon: icon,
                            isExternal: isExternal
                        )
                    }
                }
        }
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
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: resource.icon)
                    .font(.title2)
                    .foregroundColor(.applixyPrimary)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(resource.title)
                        .font(.headline)
                        .foregroundColor(.applixyDark)
                        .lineLimit(2)
                    
                    Text(resource.category)
                        .font(.caption)
                        .foregroundColor(.applixySecondary)
                }
                
                Spacer()
                
                if resource.isExternal {
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundColor(.applixyPrimary)
                }
            }
            
            // Description
            Text(resource.description)
                .font(.body)
                .foregroundColor(.applixyDark)
                .lineLimit(2)
            
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
        }
        .padding(16)
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 6, x: 0, y: 3)
    }
}

// MARK: - Shared: ensure Firebase auth, then run
func ensureSignedIn(_ then: @escaping () -> Void) {
    if Auth.auth().currentUser != nil { then(); return }
    Auth.auth().signInAnonymously { _, _ in then() }
}

// Mark: Preview

#Preview {
    ContentView()
}
