//
//  ShootingStarView.swift
//  NightShift
//
//  Created by Eva Sira Madarasz on 18/05/2025.
//
import SwiftUI

struct ShootingStarView: View {
    @State private var startPosition: CGPoint = .zero
    @State private var endPosition: CGPoint = .zero
    @State private var animate = false
    @State private var wasTapped = false

    let screenSize: CGSize

    var body: some View {
        Circle()
            .fill(wasTapped ? Color.yellow : Color.white)
            .frame(width: wasTapped ? 5 : 2.5, height: wasTapped ? 5 : 2.5)
            .position(animate ? endPosition : startPosition)
            .opacity(animate ? 0 : 1)
            .animation(.easeOut(duration: 1.2), value: animate)
            .onAppear {
                generateRandomPath()
                animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    animate = false
                }
            }
            .onTapGesture {
                makeAWish()
            }
    }

    private func generateRandomPath() {
        let startX = CGFloat.random(in: 0...screenSize.width * 0.4)
        let startY = CGFloat.random(in: 0...screenSize.height * 0.3)
        let endX = startX + CGFloat.random(in: 100...250)
        let endY = startY + CGFloat.random(in: 80...200)

        startPosition = CGPoint(x: startX, y: startY)
        endPosition = CGPoint(x: endX, y: endY)
    }

    private func makeAWish() {
        wasTapped = true

        // Optional: add wish sound or journal entry here

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            wasTapped = false
        }
    }
}




