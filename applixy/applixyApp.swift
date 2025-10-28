//
//  applixyApp.swift
//  applixy
//
//  Created by Sinchana Nama on 10/7/25.
//

import SwiftUI
import FirebaseCore

@main
struct ApplixyApp: App {
    init() {
        // Configure exactly once
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
