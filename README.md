# Applixy

A mobile application designed to help students discover and save educational opportunities including scholarships, college programs, and resources. Built with SwiftUI and Firebase.

## 📱 Features

### Core Features
- **Opportunity Discovery**: Swipe through scholarships, college programs, and educational opportunities
- **Save & Dismiss**: Save opportunities you're interested in or dismiss ones that don't fit
- **Persistent State**: Your saved and dismissed opportunities are saved to your account
- **Mentor Network**: Browse and connect with mentors across various specialties
- **Resources Library**: Access curated educational resources and tools
- **Status Updates**: Track your application progress and updates

### User Experience
- **Swipe-Based Interface**: Intuitive card-based discovery experience
- **User Authentication**: Secure email/password authentication with Firebase
- **Onboarding Flow**: Guided setup to personalize your experience
- **Real-Time Updates**: Live synchronization with Firestore database
- **Offline Support**: Firestore caching for offline access

## 🛠 Tech Stack

- **Framework**: SwiftUI
- **Backend**: Firebase
  - Firebase Authentication (Email/Password)
  - Cloud Firestore (NoSQL Database)
- **Language**: Swift
- **Platform**: iOS

## 📋 Prerequisites

- Xcode 14.0 or later
- iOS 15.0 or later
- Firebase account and project
- `GoogleService-Info.plist` file configured for your Firebase project

## 🚀 Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd idsn599applixy-2
```

### 2. Firebase Configuration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication:
   - Go to Authentication → Sign-in method
   - Enable Email/Password authentication
3. Create Firestore Database:
   - Go to Firestore Database
   - Create database in production mode
   - Set up security rules (see Security Rules section)
4. Download `GoogleService-Info.plist`:
   - Go to Project Settings → General
   - Download the `GoogleService-Info.plist` file
   - Place it in the `applixy/` directory

### 3. Firestore Collections

The app uses the following Firestore collections:

- `users` - User profile data
- `scholarship` - Scholarship opportunities
- `college` - College program opportunities
- `program` - General program opportunities
- `mentors` - Mentor profiles
- `user_opportunity_decisions` - User's saved/dismissed opportunities

### 4. Open in Xcode

1. Open `applixy.xcodeproj` in Xcode
2. Ensure `GoogleService-Info.plist` is in the project
3. Build and run the project (⌘R)

## 🏗 Architecture

### Backend Architecture

The app uses a Firebase-based backend with the following components:

#### Authentication & User Management
- **SessionViewModel**: Manages authentication state and user data
- **UserService**: Handles user document CRUD operations in Firestore
- Real-time auth state listeners for automatic user data loading

#### Opportunity Management
- **OpportunityStateService**: Singleton service tracking user decisions (saved/dismissed)
- Real-time Firestore listeners for opportunity updates
- Per-user state isolation using user IDs

#### Data Models
- `Opportunity`: Main model for scholarships/programs
- `MentorProfile`: Mentor information
- `AppUser`: User profile data
- `OpportunityState`: User decision tracking

### Key Components

- **RootView**: Main navigation controller, handles auth state routing
- **DiscoveryView**: Swipe-based opportunity discovery
- **SavedOpportunitiesView**: Displays user's saved opportunities
- **MentorsView**: Mentor browsing and connection
- **ResourcesView**: Educational resources library
- **OnboardingFlowView**: Multi-step user onboarding

## 📁 Project Structure

```
applixy/
├── applixyApp.swift          # App entry point, Firebase initialization
├── RootView.swift            # Main navigation and auth routing
├── ContentView.swift         # Main UI components and views
├── SessionViewModel.swift    # Authentication and user state management
├── BackendFunctions.swift    # Firestore operations and data models
├── Opportunity.swift         # Opportunity data model
├── OpportunityStateService.swift  # User decision tracking service
├── SavedOpportunitiesView.swift   # Saved opportunities view
├── UserDecisions.swift       # User decision models
├── GoogleService-Info.plist # Firebase configuration
└── Assets.xcassets/          # App assets and images
```

## 🔒 Security Rules

Example Firestore security rules (adjust based on your needs):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read opportunities, authenticated users can write
    match /scholarship/{docId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /college/{docId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /program/{docId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Mentors: read for all, write for authenticated
    match /mentors/{docId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // User decisions: users can only access their own
    match /user_opportunity_decisions/{docId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## 🎨 Design System

The app uses a custom color palette:

- **Primary**: Deep Indigo (#1B1471)
- **Secondary**: Periwinkle (#8091DF)
- **Background**: Light background color
- **Dark**: Dark text color
- **Light**: Light accent color

## 📝 Usage

### For Users

1. **Sign Up**: Create an account with email and password
2. **Onboarding**: Complete the onboarding flow to set up your profile
3. **Discover**: Swipe through opportunities on the Discover tab
   - Swipe right or tap star to save
   - Swipe left or tap X to dismiss
4. **Saved**: View your saved opportunities in the Saved tab
5. **Mentors**: Browse and connect with mentors
6. **Resources**: Access educational resources

### For Developers

#### Adding Opportunities
Use the `AddOpportunityView` to post new opportunities. The form supports:
- Opportunity name and description
- Category selection (scholarship, college, program, resource)
- Deadline and award amount
- Target demographics
- Organization and website

#### Adding Mentors
Use the `AddMentorView` to add mentor profiles with:
- Name and specialty
- Contact information (email, phone, website)
- Bio and experience level

## 🐛 Known Issues

- Discovery view currently only loads from the `scholarship` collection
- Some placeholder data may still exist in backend functions

## 🔮 Future Enhancements

- [ ] Multi-collection support in discovery view
- [ ] Push notifications for new opportunities
- [ ] Advanced filtering and search
- [ ] Social features and sharing
- [ ] Application tracking and reminders
- [ ] Personalized recommendations

## 👥 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is part of IDSN599 - Mobile App Development course.

## 👨‍💻 Authors

- Sinchana Nama
- Parissa Teli

## 🙏 Acknowledgments

- Firebase for backend infrastructure
- SwiftUI for the modern UI framework
- IDSN599 course instructors and peers

---

**Note**: This app requires a valid Firebase project configuration to run. Make sure to set up your `GoogleService-Info.plist` file before building.

