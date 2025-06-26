//
//  SprinklingStarsView.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var baseOpacity: Double
    var sparkleOpacity: Double
}

struct SprinklingStarsView: View {
    @State private var stars: [Star] = []
    @State private var starOpacities: [UUID: Double] = [:]
    @State private var shootingStars: [UUID] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Twinkling stars
                ForEach(stars) { star in
                    Circle()
                        .fill(Color.white)
                        .frame(width: star.size, height: star.size)
                        .position(x: star.x, y: star.y)
                        .opacity(starOpacities[star.id] ?? star.baseOpacity)
                        .animation(.easeInOut(duration: 1.2), value: starOpacities[star.id])
                }

                // Shooting stars
                ForEach(shootingStars, id: \.self) { id in
                    ShootingStarView(screenSize: geometry.size)
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    if stars.isEmpty && geometry.size.width > 0 && geometry.size.height > 0 {
                        generateStars(in: geometry.size)
                        startTwinkleTimer()
                        startShootingStarTimer()
                    }
                }
            }

        }
    }

    private func generateStars(in size: CGSize) {
        stars = (0..<70).map { _ in
            let base = Double.random(in: 0.2...0.5)
            let sparkle = Double.random(in: 0.7...1.0)
            let star = Star(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 1.5...3.5),
                baseOpacity: base,
                sparkleOpacity: sparkle
            )
            starOpacities[star.id] = base
            return star
        }
    }

    private func startTwinkleTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            for star in stars {
                if Bool.random() {
                    starOpacities[star.id] = star.sparkleOpacity

                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.0...2.0)) {
                        starOpacities[star.id] = star.baseOpacity
                    }
                }
            }
        }
    }

    private func startShootingStarTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let newID = UUID()
            shootingStars.append(newID)

            // Remove it after animation ends
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                shootingStars.removeAll { $0 == newID }
            }
        }
    }
}

