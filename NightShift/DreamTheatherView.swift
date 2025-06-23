//
//  DreamTheatherView.swift
//  NightShift
//
//  Created by Eva Madarasz
//
import SwiftUI
import SwiftData
import AVFoundation

struct DreamTheaterView: View {

    @Query(FetchDescriptor<Wish>(sortBy: [SortDescriptor(\Wish.date, order: .reverse)]))
    var wishes: [Wish]

    @Environment(\.dismiss) var dismiss
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showWish = false
    @State private var animateGlow = false
    @State private var currentIndex = 0
    @State private var selectedSound: String? = nil 

    let soundOptions: [(label: String, file: String?)] = [
        ("🎹 Piano", "soft-piano-72454"),
        ("🌲 Forest", "night-forest-soundscape-158701"),
        ("🔔 Tibetan", "tibetan-bowl-26240"),
        ("🌧 Rain", "rain-and-thunder-sfx-12820"),
        ("🔇 Silence", nil)
    ]

    var body: some View {
        ZStack {
            // 🌌 Starry Night Background😀
            LinearGradient(colors: [.nightShiftIndigo, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            
            SprinklingStarsView()
                .ignoresSafeArea()

            Color.white.opacity(0.05)
                .blur(radius: 10)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Dream Theater")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)

                soundSelectionView

                Spacer()

                if !wishes.isEmpty {
                    VStack {
                        Text("“\(wishes[currentIndex].text)”")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(18)
                            .shadow(color: Color.nightShiftGold.opacity(animateGlow ? 0.8 : 0.3), radius: animateGlow ? 20 : 10)
                            .scaleEffect(showWish ? 1 : 0.8)
                            .opacity(showWish ? 1 : 0)
                            .animation(.easeOut(duration: 1), value: showWish)
                            .onAppear {
                                withAnimation {
                                    showWish = true
                                    animateGlow.toggle()
                                }
                            }
                            .gesture(DragGesture().onEnded { value in
                                if value.translation.width < -50 {
                                    if currentIndex < wishes.count - 1 {
                                        currentIndex += 1
                                    }
                                } else if value.translation.width > 50 {
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                }
                            })
                    }
                    .padding()
                } else {
                    Text("No wishes yet.")
                        .foregroundColor(.gray)
                }

                Spacer()

               
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Return")
                            .padding()
                            .background(Color.nightShiftGold.opacity(0.2))
                            .foregroundColor(.nightShiftGold)
                            .cornerRadius(12)
                            .shadow(color: Color.nightShiftGold.opacity(0.6), radius: 10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            playDreamSound()
        }
        .onChange(of: selectedSound) { _ in
            playDreamSound()
        }
    }

    // MARK: 🎛️ Sound Buttons View
    private var soundSelectionView: some View {
        VStack(spacing: 10) {
            Text("Soundscape")
                .foregroundColor(.white)
                .font(.subheadline)

            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(soundOptions, id: \.label) { option in
                    Button(action: {
                        selectedSound = option.file
                    }) {
                        Text(option.label)
                            .font(.callout)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                (selectedSound == option.file)
                                ? Color.nightShiftGold.opacity(0.3)
                                : Color.white.opacity(0.08)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.nightShiftGold.opacity(selectedSound == option.file ? 0.7 : 0.15), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    
    func playDreamSound() {
        audioPlayer?.stop()

        guard let sound = selectedSound else {
           
            return
        }

        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("❌ Could not find \(sound).mp3")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}


#Preview {
    DreamTheaterView()
}
