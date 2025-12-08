//
//  applixyApp.swift
//  applixy
//
//  Created by Sinchana Nama on 10/7/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct applixyApp: App {
    @StateObject private var sessionVM = SessionViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(sessionVM)
        }
    }
}

