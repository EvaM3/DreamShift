//
//  ReminderSettingsView.swift
//  NightShift
//
//  Created by Eva Madarasz
//
import SwiftUI

struct ReminderSettingsView: View {
    @AppStorage("reminderEnabled") private var reminderEnabled = true
    @AppStorage("reminderHour") private var reminderHour = 22
    @AppStorage("reminderMinute") private var reminderMinute = 0

    @State private var selectedTime = Date()

    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Nightly Reminder")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.nightShiftGold)
                    .padding(.top)

                Toggle(isOn: $reminderEnabled) {
                    Text("Enable Reminder")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .toggleStyle(SwitchToggleStyle(tint: .nightShiftGold))
                .onChange(of: reminderEnabled) { enabled in
                    if enabled {
                        scheduleNotification()
                    } else {
                        NotificationManager.shared.cancelNotifications()
                    }
                }

                if reminderEnabled {
                    DatePicker("Reminder Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .colorScheme(.dark)
                        .onChange(of: selectedTime) { _ in
                            saveTimeAndReschedule()
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                }

                Spacer()

                Button(action: {
                    saveTimeAndReschedule()
                }) {
                    Text("Save Reminder")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.nightShiftGold.opacity(0.2))
                        .foregroundColor(.nightShiftGold)
                        .cornerRadius(12)
                        .shadow(color: Color.nightShiftGold.opacity(0.6), radius: 10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
            selectedTime = getStoredTime()
        }
    }

    func saveTimeAndReschedule() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        reminderHour = components.hour ?? 22
        reminderMinute = components.minute ?? 0
        scheduleNotification()
    }

    func scheduleNotification() {
        NotificationManager.shared.scheduleDailyReminder(at: reminderHour, minute: reminderMinute)
    }

    func getStoredTime() -> Date {
        var components = DateComponents()
        components.hour = reminderHour
        components.minute = reminderMinute
        return Calendar.current.date(from: components) ?? Date()
    }
}

#Preview {
    ReminderSettingsView()
}
