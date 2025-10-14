//
//  applixyApp.swift
//  applixy
//
//  Created by Sinchana Nama on 10/7/25.
//


import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct applixyApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}

/*
import SwiftUI

@main
struct applixyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/
