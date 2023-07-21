//
//  AutoVolleyApp.swift
//  AutoVolley
//
//  Created by Rayyan Zaid on 7/19/23.
//

import SwiftUI
import Firebase



@main
struct AutoVolleyApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
