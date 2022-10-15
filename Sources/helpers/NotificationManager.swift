//
//  userAuthorization.swift
//  Dynamic Island
//
//  Created by mac on 10/9/22.
//

import Foundation
import SwiftUI

struct NotificationManager {
    // Mark: Linking App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let notificationId = UUID().uuidString
    private let center = UNUserNotificationCenter.current()
    static let instance = NotificationManager()
    // MARK: Notifications request.
    func authorizeNotifications() {
        let options: UNAuthorizationOptions =  [.alert, .badge, .sound]
        center.requestAuthorization(
                options:options) {
                isAuth, error in
                    guard error == nil else {
                        return print("ERROR => \(error.debugDescription)")
                    }
                    print("Authed => \(isAuth.description)")
            }
    }
    
    func schedualNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hey from Dynamic Iceland!"
        content.subtitle = "This was so coooool!"
        content.sound = .default
        content.badge = 1
        
        let timeTriger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5.0,
            repeats: false)
        
        let request = UNNotificationRequest(
            identifier: notificationId,
            content: content,
            trigger: timeTriger)
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                center.add(request) { error in
                    print("ERROR \(error.debugDescription)")
                }
                print("FIRED 🚀")
            } else {
                authorizeNotifications()
            }
        }
        
    }
}
