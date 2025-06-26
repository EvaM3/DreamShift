//
//  Starfieldbackground.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import SwiftUI

struct StarfieldBackground: View {
    @State private var stars: [CGPoint] = []

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for point in stars {
                    var resolvedPoint = point
                    resolvedPoint.x += CGFloat.random(in: -0.3...0.3)
                    resolvedPoint.y += CGFloat.random(in: -0.3...0.3)

                    let rect = CGRect(origin: resolvedPoint, size: CGSize(width: 2, height: 2))
                    context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.6)))
                }
            }
            .onAppear {
                stars = (0..<80).map { _ in
                    CGPoint(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: CGFloat.random(in: 0...geo.size.height)
                    )
                }
            }
        }
    }
}


#Preview {
    StarfieldBackground()
}
