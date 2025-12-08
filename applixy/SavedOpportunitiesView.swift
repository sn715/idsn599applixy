//
//  SavedOpportunitiesView.swift
//  applixy
//
//  Created by Parissa Teli on 12/8/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import UIKit

// MARK: - Saved Opportunities (Star Tab)

struct SavedOpportunitiesView: View {
    /// Global per-user yes/no state (from OpportunityStateService)
    @ObservedObject private var stateService = OpportunityStateService.shared

    /// All opportunities we’ve loaded from Firestore
    @State private var allOpportunities: [Opportunity] = []

    /// UI state
    @State private var loading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ZStack {
                Color.applixyBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    StandardHeaderView(
                        title: "Saved",
                        subtitle: "Your starred opportunities"
                    )

                    Group {
                        if loading {
                            VStack(spacing: 12) {
                                ProgressView()
                                Text("Loading saved opportunities…")
                                    .foregroundColor(.applixySecondary)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let err = errorMessage {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                                Text("Couldn't load saved opportunities")
                                    .font(.headline)
                                    .foregroundColor(.applixyDark)
                                Text(err)
                                    .font(.footnote)
                                    .foregroundColor(.applixySecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                Button("Retry") {
                                    reloadSaved()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.applixyPrimary.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if savedOpportunities.isEmpty {
                            VStack(spacing: 24) {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.applixyLight)
                                Text("No saved opportunities yet")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.applixyDark)
                                Text("Star an opportunity in Discover to see it here.")
                                    .font(.subheadline)
                                    .foregroundColor(.applixySecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
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
                                    ForEach(savedOpportunities) { opportunity in
                                        SavedOpportunityGridCard(opportunity: opportunity)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            reloadSaved()
        }
        .onReceive(stateService.$savedIds) { _ in
            // Whenever the user stars/unstars something, recompute
            reloadSaved()
        }
    }

    // MARK: - Derived Data

    /// Filter all opportunities to only those whose IDs are in stateService.savedIds
    private var savedOpportunities: [Opportunity] {
        allOpportunities.filter { opp in
            stateService.savedIds.contains(opp.id)
        }
    }

    // MARK: - Firestore load

    /// Reloads all opportunities and then applies the savedIds filter.
    /// Adjust the collections array if you store different categories.
    private func reloadSaved() {
        loading = true
        errorMessage = nil

        let db = Firestore.firestore()

        // 🔁 Add/adjust categories to match how you store opportunities
        let collections = ["scholarship", "college", "program"]

        var gathered: [Opportunity] = []
        var remaining = collections.count
        if remaining == 0 {
            loading = false
            allOpportunities = []
            return
        }

        for coll in collections {
            db.collection(coll).getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.loading = false
                    }
                } else if let docs = snapshot?.documents {
                    let opps = docs.compactMap { doc -> Opportunity? in
                        Opportunity(doc: doc)
                    }
                    gathered.append(contentsOf: opps)
                }

                remaining -= 1
                if remaining == 0 {
                    DispatchQueue.main.async {
                        self.loading = false
                        self.allOpportunities = gathered
                    }
                }
            }
        }
    }
}

// MARK: - Saved Opportunity Grid Card

struct SavedOpportunityGridCard: View {
    let opportunity: Opportunity

    private var formattedDeadline: String {
        if let deadline = opportunity.deadline {
            let df = DateFormatter()
            df.dateStyle = .medium
            return df.string(from: deadline)
        } else {
            return "Rolling"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(opportunity.name)
                .font(.headline)
                .foregroundColor(.applixyDark)
                .lineLimit(2)

            Text(opportunity.organization)
                .font(.subheadline)
                .foregroundColor(.applixySecondary)
                .lineLimit(1)

            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                Text(formattedDeadline)
                    .font(.caption)
            }
            .foregroundColor(.applixySecondary)

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(Color.applixyWhite)
        .cornerRadius(12)
        .shadow(color: .applixyLight, radius: 4, x: 0, y: 2)
    }
}
