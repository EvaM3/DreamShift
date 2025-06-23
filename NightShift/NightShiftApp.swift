//
//  NightShiftApp.swift
//  NightShift
//
//  Created by Eva Sira Madarasz on 13/05/2025.
//

import SwiftUI

@main
struct NightShiftApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                OnboardingScreen(viewModel: OnboardingViewModel())
            }
            .tint(.white)
        }
        .modelContainer(for: Wish.self)
    }
}
