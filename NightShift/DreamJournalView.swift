//
//  DreamJournalView.swift
//  NightShift
//
//  Created by Eva Madarasz on 24/05/2025.
//

import SwiftUI
import SwiftData

struct DreamJournalView: View {
    @Query(FetchDescriptor<Wish>()) var wishes: [Wish]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var selectedTag: String = "All"
    @State private var showToast = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Dream Journal")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    //MARK: Tag Cloud Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            let uniqueTags = ["All"] + Set(wishes.map { $0.tag }).sorted()

                            ForEach(uniqueTags, id: \.self) { tag in
                                Button(action: {
                                    selectedTag = tag
                                }) {
                                    Text(tag)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedTag == tag ? Color.nightShiftGold.opacity(0.3) : Color.white.opacity(0.1))
                                        .foregroundColor(selectedTag == tag ? .nightShiftGold : .white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedTag == tag ? Color.nightShiftGold : Color.clear, lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if filteredWishes().isEmpty {
                        Spacer()
                        Text("Your dream journal is empty.\nTap 'Make a Wish' to get started.")
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredWishes()) { wish in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(wish.text)
                                        .font(.body)
                                        .foregroundColor(.white)

                                    Text(wish.tag)
                                        .font(.caption2)
                                        .foregroundColor(.yellow.opacity(0.8))

                                    Text(wish.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.vertical, 6)
                                .listRowBackground(Color.clear)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            context.delete(wish)
                                            showToastMessage()
                                        }
                                    } label: {
                                        Label("Achieved", systemImage: "checkmark.seal")
                                    }
                                    .tint(.nightShiftGold)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.top)

            
                if showToast {
                    VStack {
                        Spacer()
                        Text("Dream marked as achieved!")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.nightShiftGold.opacity(0.9))
                            .cornerRadius(16)
                            .shadow(radius: 10)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 30)
                    }
                    .animation(.easeInOut(duration: 0.4), value: showToast)
                }
            }
        }
    }

    func showToastMessage() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showToast = false
            }
        }
    }

    func filteredWishes() -> [Wish] {
        if selectedTag == "All" {
            return wishes.sorted { $0.date > $1.date }
        } else {
            return wishes
                .filter { $0.tag == selectedTag }
                .sorted { $0.date > $1.date }
        }
    }
}




#Preview {
    DreamJournalView()
}
