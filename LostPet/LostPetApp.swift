//
//  LostPetApp.swift
//  LostPet
//
//  Created by Pedro Toledo on 14/8/23.
//

import SwiftUI
import Firebase

@main
struct LostPetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("*firebase configurado* - *mi mensaje personalizado* -")
        return true
    }
}
