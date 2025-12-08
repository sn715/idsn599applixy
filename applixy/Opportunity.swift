//
//  Opportunity.swift
//  applixy
//
//  Created by Parissa Teli on 12/8/25.

import Foundation
import FirebaseFirestore

/// Main app model for a scholarship/program/college opportunity.
struct Opportunity: Identifiable {
    let id: String

    let name: String
    let organization: String
    let description: String

    /// Raw website string from Firestore ("website" field)
    let website: String

    /// Raw deadline string we store as "MMMM d, yyyy"
    let deadlineString: String?

    /// Award amount (if provided in AddOpportunityView)
    let awardAmount: Int?

    /// Category / type (optional; we default to empty if not present)
    let type: String

    /// Target demographics tags
    let targetDemographic: [String]

    /// Firestore timestamp when created
    let createdAt: Date?

    // MARK: - Convenience for existing UI

    /// Used by the Saved card, Discovery detail, etc.
    var link: String { website }

    /// Parse the stored deadline string into a Date for display.
    var deadline: Date? {
        guard let deadlineString,
              !deadlineString.isEmpty
        else { return nil }

        let df = DateFormatter()
        df.dateFormat = "MMMM d, yyyy"   // same as AddOpportunityView
        return df.date(from: deadlineString)
    }

    // MARK: - Firestore init

    /// Initialize from a Firestore document (used in SavedOpportunitiesView.reloadSaved())
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()

        self.id = doc.documentID
        self.name = data["name"] as? String ?? ""
        self.organization = data["organization"] as? String ?? ""
        self.description = data["description"] as? String ?? ""

        self.website = data["website"] as? String ?? ""

        self.deadlineString = data["application_deadline"] as? String
        self.awardAmount = data["award_amount"] as? Int
        self.type = data["type"] as? String ?? ""   // we didn't set this yet, so it’s usually ""

        self.targetDemographic = data["target_demographic"] as? [String] ?? []

        if let ts = data["timestamp"] as? Timestamp {
            self.createdAt = ts.dateValue()
        } else {
            self.createdAt = nil
        }
    }
}
