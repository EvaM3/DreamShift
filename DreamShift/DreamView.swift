//
//  DreamView.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import SwiftUI
import AVFoundation

struct DreamView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var showWishReceived = false
    @State private var animateSparkle   = false
    @State private var player: AVAudioPlayer?

    @State private var navigateToDreamJournal  = false
    @State private var navigateToDreamTheater  = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 🌌 Night gradient
                LinearGradient(colors: [.indigo, .black],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer(minLength: 20)

                    // 🧘 Affirmation
                    Text("“Assume the feeling of the wish fulfilled.”")
                        .font(.footnote)
                        .foregroundColor(.nightShiftGold.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // 💫 Wish box (larger & multiline)
                    VStack(spacing: 16) {
                        Text("What does your dream life feel like?")
                            .font(.title2)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        // ZStack for placeholder + TextEditor
                        ZStack(alignment: .topLeading) {
                            if viewModel.userIntention.isEmpty {
                                Text("Type a sentence in past tense...")
                                    .foregroundColor(.white.opacity(0.5))
                                    .italic()
                                    .padding(12)
                            }

                            TextEditor(text: $viewModel.userIntention)
                                .frame(height: 120)                   // bigger box
                                .padding(8)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)     // keep bg transparent
                        }

                        // 🎯 Make a Wish button
                        Button(action: makeWish) {
                            if showWishReceived {
                                Text("✨ Wish received ✨")
                                    .foregroundColor(.yellow)
                                    .fontWeight(.semibold)
                                    .transition(.scale.combined(with: .opacity))
                            } else {
                                Text("Make a Wish")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.nightShiftGold.opacity(0.25))
                                    .cornerRadius(12)
                                    .shadow(color: Color.yellow.opacity(0.4), radius: 4, x: 0, y: 2)
                            }
                        }
                        .disabled(viewModel.userIntention
                                   .trimmingCharacters(in: .whitespacesAndNewlines)
                                   .isEmpty)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    Spacer()

                    // 📔 Dream Journal
                    Button {
                        navigateToDreamJournal = true
                    } label: {
                        Label("Dream Journal", systemImage: "book.closed.fill")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.nightShiftGold.opacity(0.2))
                            .foregroundColor(.nightShiftGold)
                            .cornerRadius(12)
                            .shadow(color: Color.nightShiftGold.opacity(0.5), radius: 10)
                    }

                    Spacer().frame(height: 14)   // extra gap between buttons

                    // 🎭 Dream Theater
                    Button {
                        navigateToDreamTheater = true
                    } label: {
                        Label("Dream Theater", systemImage: "sparkles")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.nightShiftGold.opacity(0.2))
                            .foregroundColor(.nightShiftGold)
                            .cornerRadius(12)
                            .shadow(color: Color.nightShiftGold.opacity(0.5), radius: 10)
                    }

                    // Hidden navigation links
                    NavigationLink("", destination: DreamJournalView(),
                                   isActive: $navigateToDreamJournal)
                        .hidden()
                    NavigationLink("", destination: DreamTheaterView(),
                                   isActive: $navigateToDreamTheater)
                        .hidden()
                }
                .padding()
            }
        }
    }

    // MARK: - Wish logic
    private func makeWish() {
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.prepare()
        haptic.impactOccurred()

        let wish = Wish(text: viewModel.userIntention)
        modelContext.insert(wish)
        viewModel.userIntention = ""

        animateSparkle = true
        withAnimation(.spring()) { showWishReceived = true }

        playWishSound()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showWishReceived = false
                animateSparkle = false
            }
        }
    }

    private func playWishSound() {
        guard let url = Bundle.main.url(forResource: "wish", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Sound error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    DreamView(viewModel: OnboardingViewModel())
}
