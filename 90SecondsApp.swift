// File: 90SecondsApp.swift
import SwiftUI

@main
struct NinetySecondsApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
            .environmentObject(appViewModel)
            .preferredColorScheme(.dark)
        }
    }
}
