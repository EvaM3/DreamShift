//
//  OnboardingScreen.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import SwiftUI

struct OnboardingScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // Navigation & sheets
    @State private var navigateToNext    = false
    @State private var showInstructions  = true
    @State private var showInfoSheet     = false
    @State private var showReminderSheet = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [.nightShiftIndigo, .nightShiftMauve]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            SprinklingStarsView()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
               
                HStack {
                    Button {
                        showReminderSheet = true
                    } label: {
                        Image(systemName: "bell.badge")
                            .font(.title3)
                            .foregroundColor(.nightShiftGold)
                    }
                    
                    Spacer()
                    
                    Button {
                        showInfoSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundColor(.nightShiftGold)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
         
                Text("Welcome to NightShift")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.nightShiftGold)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.25), radius: 1, y: 1)
                
                Text("A nightly ritual to align your inner world with your desires.")
                    .foregroundColor(.nightShiftGold.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
                
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
                    .background(Color.white.opacity(0.10))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .transition(.opacity)
                } else {
                    Button("Show Manifestation Instructions") {
                        withAnimation {
                            showInstructions = true
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.nightShiftGold.opacity(0.4), lineWidth: 0.5)
                    )
                    .padding(.top, 12)
                }
                
                Spacer()
             
                NavigationLink(destination: DreamView(viewModel: viewModel),
                               isActive: $navigateToNext) { EmptyView() }
                
              
                StaticCTA(navigateToNext: $navigateToNext)
                    .padding(.horizontal)
            }
            .padding()
        }
        // Sheets
        .sheet(isPresented: $showInfoSheet)      { InfoSheetView() }
        .sheet(isPresented: $showReminderSheet)  { ReminderSettingsView() }
    }
}

// MARK: – Static CTA (single fade-in)
private struct StaticCTA: View {
    @Binding var navigateToNext: Bool
    @State private var visible = false
    
    var body: some View {
        Button {
            navigateToNext = true
        } label: {
            Text("Begin Your Shift")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color.nightShiftGold.opacity(0.20))
                .cornerRadius(12)
                .foregroundColor(.nightShiftGold)
        }
        .opacity(visible ? 1 : 0)                          // fade
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                visible = true
            }
        }
      
    }
}

#Preview {
    OnboardingScreen(viewModel: OnboardingViewModel())
}
