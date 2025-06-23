//
//  DreamView.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import SwiftUI
import AVFoundation
import UIKit

struct DreamView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var showWishReceived = false
    @State private var animateSparkle = false
    @State private var showInstructions = true
    @State private var player: AVAudioPlayer?

    @State private var navigateToDreamJournal = false
    @State private var navigateToDreamTheater = false
    @State private var showInfoSheet = false
    @State private var showReminderSheet = false
    

    @AppStorage("reminderEnabled") private var reminderEnabled = true
    @AppStorage("reminderHour") private var reminderHour = 22
    @AppStorage("reminderMinute") private var reminderMinute = 0

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.indigo, .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // MARK: Reminder + Info Buttons
                    HStack {
                        Button(action: {
                            showReminderSheet = true
                        }) {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.nightShiftGold)
                                .font(.title3)
                        }

                        Spacer()

                        Button(action: {
                            showInfoSheet = true
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.nightShiftGold)
                                .font(.title3)
                        }
                    }

                    // 🌙 Goddard Instructions
                    if showInstructions {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🌙 Evening Manifestation (Neville Goddard)")
                                .font(.headline)
                                .foregroundColor(.nightShiftGold)

                            Text("""
                            1. Relax your body completely.
                            2. Close your eyes and feel drowsy.
                            3. Assume the feeling of the wish fulfilled.
                            4. Visualize the scene that implies your desire is real.
                            5. Repeat gently until it feels natural.
                            6. Fall asleep in that state.
                            """)
                                .font(.callout)
                                .foregroundColor(.white)

                            Button("Hide Instructions") {
                                withAnimation {
                                    showInstructions = false
                                }
                            }
                            .font(.footnote)
                            .foregroundColor(.yellow)
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }

                  
                    Text("What does your dream life feel like?")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    TextField("Type a sentence in past tense...", text: $viewModel.userIntention)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)

                
                    Button(action: {
                        makeWish()
                    }) {
                        if showWishReceived {
                            Text("✨ Wish received ✨")
                                .foregroundColor(.yellow)
                                .fontWeight(.semibold)
                        } else {
                            Text("Make a Wish")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.yellow.opacity(animateSparkle ? 0.8 : 0), lineWidth: 2)
                                        .scaleEffect(animateSparkle ? 1.2 : 1)
                                        .opacity(animateSparkle ? 0 : 1)
                                        .animation(.easeOut(duration: 1), value: animateSparkle)
                                )
                        }
                    }
                    .disabled(viewModel.userIntention.trimmingCharacters(in: .whitespaces).isEmpty)

                    Spacer()

                  
                    Button(action: {
                        navigateToDreamJournal = true
                    }) {
                        Text("Dream Journal")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.nightShiftGold.opacity(0.2))
                            .foregroundColor(.nightShiftGold)
                            .cornerRadius(12)
                            .shadow(color: Color.nightShiftGold.opacity(0.5), radius: 10, x: 0, y: 0)
                    }

                    Spacer()

                  
                    Button(action: {
                        navigateToDreamTheater = true
                    }) {
                        Text("Dream Theater")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.nightShiftGold.opacity(0.2))
                            .foregroundColor(.nightShiftGold)
                            .cornerRadius(12)
                            .shadow(color: Color.nightShiftGold.opacity(0.5), radius: 10, x: 0, y: 0)
                    }

                   
                    NavigationLink("", destination: DreamJournalView(), isActive: $navigateToDreamJournal)
                        .hidden()

                    NavigationLink("", destination: DreamTheaterView(), isActive: $navigateToDreamTheater)
                        .hidden()
                }
                .padding()
            }

          
            .sheet(isPresented: $showInfoSheet) {
                InfoSheetView()
            }

            
            .sheet(isPresented: $showReminderSheet) {
                ReminderSettingsView()
            }
        }
    }

    func makeWish() {
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()

        let wish = Wish(text: viewModel.userIntention)
        modelContext.insert(wish)
        
        viewModel.userIntention = ""

        animateSparkle = true
        withAnimation {
            showWishReceived = true
        }

        playWishSound()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showWishReceived = false
                animateSparkle = false
            }
        }
    }

    func playWishSound() {
        guard let url = Bundle.main.url(forResource: "wish", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    DreamView(viewModel: OnboardingViewModel())
}
