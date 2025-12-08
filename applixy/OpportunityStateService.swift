//
//  OpportunityStateService.swift
//  applixy
//
//  Created by Parissa Teli on 12/8/25.
//

// MARK: - Model for a user's decision on an opportunity

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

/// Per-user yes/no state for an opportunity.
/// (UI mostly cares about `opportunityId`, `isSaved`, `isDismissed`)
struct OpportunityState: Identifiable {
    let id: String
    let userId: String
    let opportunityId: String
    let type: String
    let isSaved: Bool
    let isDismissed: Bool
    let updatedAt: Date?

    // Extra fields so SavedOpportunityCard compiles (you don't have to use them)
    let name: String
    let organization: String
    let deadline: Date?
    let link: String

    init(id: String,
         userId: String,
         opportunityId: String,
         type: String,
         isSaved: Bool,
         isDismissed: Bool,
         updatedAt: Date?,
         name: String = "",
         organization: String = "",
         deadline: Date? = nil,
         link: String = "") {
        self.id = id
        self.userId = userId
        self.opportunityId = opportunityId
        self.type = type
        self.isSaved = isSaved
        self.isDismissed = isDismissed
        self.updatedAt = updatedAt
        self.name = name
        self.organization = organization
        self.deadline = deadline
        self.link = link
    }

    init?(doc: QueryDocumentSnapshot) {
        let d = doc.data()
        guard let userId = d["userId"] as? String else { return nil }
        let opportunityId = d["opportunityId"] as? String ?? doc.documentID
        let type = d["type"] as? String ?? "scholarship"
        let isSaved = d["isSaved"] as? Bool ?? false
        let isDismissed = d["isDismissed"] as? Bool ?? false
        let ts = d["updatedAt"] as? Timestamp
        let updatedAt = ts?.dateValue()

        self.init(
            id: doc.documentID,
            userId: userId,
            opportunityId: opportunityId,
            type: type,
            isSaved: isSaved,
            isDismissed: isDismissed,
            updatedAt: updatedAt
        )
    }
}


/// Stores the current user's yes/no decisions in Firestore
/// and exposes saved/dismissed opportunity IDs to the UI.
final class OpportunityStateService: ObservableObject {
    static let shared = OpportunityStateService()

    /// All opportunity IDs this user has starred
    @Published private(set) var savedIds: Set<String> = []

    /// All opportunity IDs this user has dismissed
    @Published private(set) var dismissedIds: Set<String> = []

    private let db = Firestore.firestore()
    private var stateListener: ListenerRegistration?
    private var authListener: AuthStateDidChangeListenerHandle?

    private init() {
        // Listen for auth changes so each user gets their own state
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.startListening(for: user)
        }

        // Also try with current user at launch
        startListening(for: Auth.auth().currentUser)
    }

    deinit {
        if let handle = authListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        stateListener?.remove()
    }

    // MARK: - Firestore listener

    /// Listen to this user's decisions in the `user_opportunity_decisions` collection.
    private func startListening(for user: User?) {
        // Clear old state and listener
        stateListener?.remove()
        stateListener = nil
        savedIds = []
        dismissedIds = []

        guard let user = user else { return }

        let ref = db.collection("user_opportunity_decisions")
            .whereField("userId", isEqualTo: user.uid)

        stateListener = ref.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("⚠️ Error listening to user_opportunity_decisions: \(error)")
                return
            }

            guard let docs = snapshot?.documents else {
                DispatchQueue.main.async {
                    self.savedIds = []
                    self.dismissedIds = []
                }
                return
            }

            var newSaved: Set<String> = []
            var newDismissed: Set<String> = []

            for doc in docs {
                let data = doc.data()
                let oppId = data["opportunityId"] as? String ?? ""
                if oppId.isEmpty { continue }

                if data["isSaved"] as? Bool == true {
                    newSaved.insert(oppId)
                }
                if data["isDismissed"] as? Bool == true {
                    newDismissed.insert(oppId)
                }
            }

            DispatchQueue.main.async {
                self.savedIds = newSaved
                self.dismissedIds = newDismissed
            }
        }
    }

    // MARK: - Public API: mark saved/dismissed

    // MARK: - Convenience overloads used by DiscoveryView
    /// Mark an opportunity as saved just by id + type (no full `Opportunity` model needed).
    func setSaved(opportunityId: String, type: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ setSaved(id:type:) called with no logged-in user")
            return
        }

        let key = "\(uid)_\(opportunityId)"
        let ref = db.collection("user_opportunity_decisions").document(key)

        ref.setData([
            "userId": uid,
            "opportunityId": opportunityId,
            "type": type,
            "isSaved": true,
            "isDismissed": false,
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    /// Mark an opportunity as dismissed just by id + type.
    func setDismissed(opportunityId: String, type: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ setDismissed(id:type:) called with no logged-in user")
            return
        }

        let key = "\(uid)_\(opportunityId)"
        let ref = db.collection("user_opportunity_decisions").document(key)

        ref.setData([
            "userId": uid,
            "opportunityId": opportunityId,
            "type": type,
            "isSaved": false,
            "isDismissed": true,
            "updatedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    /// Optional helper if you ever want to clear a decision.
    func clearDecision(for opportunity: Opportunity) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let key = "\(uid)_\(opportunity.id)"
        db.collection("user_opportunity_decisions").document(key).delete()
    }
}
