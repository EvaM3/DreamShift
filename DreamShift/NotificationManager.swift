//
//  NotificationManager.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func scheduleDailyReminder(at hour: Int, minute: Int) {
        cancelNotifications() 

        let content = UNMutableNotificationContent()
        content.title = "NightShift Reminder"
        content.body = "Time to visualize your wish 🌙"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "nightlyReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["nightlyReminder"])
    }
}

