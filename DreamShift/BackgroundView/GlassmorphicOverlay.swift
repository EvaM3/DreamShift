//
//  GlassmorphicOverlay.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import SwiftUI
import SwiftUI

struct GlassmorphicOverlay: View {
    var body: some View {
        Color.white
            .opacity(0.1)
            .background(.ultraThinMaterial)
            .blur(radius: 10)
            .cornerRadius(25)
    }
}


#Preview {
    GlassmorphicOverlay()
}
