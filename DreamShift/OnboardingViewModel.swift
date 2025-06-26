//
//  OnboardingViewModel.swift
//  NightShift
//
//  Created by Eva Sira Madarasz on 13/05/2025.
//

import SwiftUI



class OnboardingViewModel: ObservableObject {
    @Published var userIntention: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Published var wishJournal: [Wish] = []

    func recordWish(_ text: String) {
        let newWish = Wish(text: text, date: Date())
        wishJournal.append(newWish)
    }
}

