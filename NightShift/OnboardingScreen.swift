//
//  OnboardingScreen.swift
//  NightShift
//
//  Created by Eva Madarasz
//
import SwiftUI

struct OnboardingScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var navigateToNext = false

    var body: some View {
        ZStack {

            // 🌌 Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [.nightShiftIndigo, .nightShiftMauve]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            // ✨ Animated Starfield
            SprinklingStarsView()
                .ignoresSafeArea()
            

            VStack(spacing: 30) {
                Spacer()

                Text("Welcome to NightShift")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.nightShiftGold)
                    .multilineTextAlignment(.center)

                Text("A nightly ritual to align your inner world with your desires.")
                    .foregroundColor(.nightShiftGold.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                NavigationLink(destination: DreamView(viewModel: viewModel), isActive: $navigateToNext) {
                    EmptyView()
                }

                Button(action: {
                    navigateToNext = true
                }) {
                    Text("Begin Your Shift")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.nightShiftGold.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.nightShiftGold)
                        .shadow(color: Color.nightShiftGold.opacity(0.4), radius: 20, x: 0, y: 0) // 🌟 Glow
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


#Preview {
   OnboardingScreen(viewModel: OnboardingViewModel())
}
