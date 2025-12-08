//
//  UserDecisions.swift
//  applixy
//
//  Created by Parissa Teli on 12/8/25.
//
import FirebaseFirestore
import Foundation

struct UserOpportunityDecision: Codable {
    let userId: String
    let opportunityId: String
    let decision: String   // "saved" or "skipped"
    let decidedAt: Timestamp
}

enum OpportunityDecisionService {
    private static let coll = Firestore.firestore()
        .collection("user_opportunity_decisions")

    static func recordDecision(
        userId: String,
        opportunityId: String,
        decision: String
    ) async throws {
        // Deterministic doc ID: one doc per (user, opportunity)
        let docId = "\(userId)_\(opportunityId)"
        try await coll.document(docId).setData([
            "userId": userId,
            "opportunityId": opportunityId,
            "decision": decision,
            "decidedAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    static func fetchSeenOpportunityIds(for userId: String) async throws -> Set<String> {
        let snap = try await coll
            .whereField("userId", isEqualTo: userId)
            .getDocuments()

        let ids = snap.documents.compactMap {
            $0.data()["opportunityId"] as? String
        }
        return Set(ids)
    }
}
