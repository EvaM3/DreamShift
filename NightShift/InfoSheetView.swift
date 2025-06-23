//
//  InfoSheetView.swift
//  NightShift
//
//  Created by Eva Sira Madarasz on 26/05/2025.
//

import SwiftUI

struct InfoSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("🌌 Manifestation with Neville Goddard")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.nightShiftGold)

                    Text("""
Neville Goddard taught that your imagination creates reality. His evening technique involves relaxing the body, entering a sleepy state, and imagining a scene that implies your desire is already fulfilled.

 Practice it every night until it feels real — every part of it.
 Fall asleep in the feeling of the wish fulfilled to impress the subconscious mind.

Repeat this nightly to impress the subconscious mind.

**Core Principles:**
• Imagination is reality
• Assume the feeling of the wish fulfilled
• Feeling is the secret

**Recommended Books:**
• Feeling is the Secret
• The Power of Awareness
• Your Faith is Your Fortune
• Awakened Imagination
• Out of This World

You don’t force the dream — you *live in it* as if it’s already true.
""")
                        .font(.callout)
                        .foregroundColor(.white)
                }
                .padding()
            }
            .background(LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
            .navigationTitle("About the Method")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    InfoSheetView()
}
