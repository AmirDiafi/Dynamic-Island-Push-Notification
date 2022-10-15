//
//  ContentView.swift
//  Dynamic Island
//
//  Created by mac on 10/9/22.
//

import SwiftUI

struct NotificationValue: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let content: UNNotificationContent?
    let dateCreated: Date = Date()
    let showNotification: Bool = false
    let imageName: String?
}


struct ContentView: View {
    let notificationManager = NotificationManager.instance
    @State var isOpen: Bool = false
    @State var notifications: [NotificationValue] = []
    
    var body: some View {
        VStack {
            if UIApplication.shared.hasDynamicIsland {
                ZStack {
                    ForEach(notifications) { item in
                        DynamicIslandNotification(value: item)
                            .ignoresSafeArea()
                    }
                }
            }
            
            Spacer()
            Text("Dynamic Island Preview")
                .font(.title)
            
            Button(action:{
                notifications.append(fireNotification())
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    if let index = notifications.firstIndex(of: fireNotification()) {
                        print("remove index \(index)")
                        notifications.remove(at: index)
                    }
                }
            }) {
                Text("Fire Notification")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
        }.onAppear(perform: {
            notificationManager.authorizeNotifications()
        })
        .onReceive(
            NotificationCenter.default
            .publisher(for: NSNotification.dynamicIslandAlert))
        { obj in
            
            if let content = obj.userInfo?["content"] as? UNNotificationContent {
                let newNotification = NotificationValue(
                    content: content,
                    imageName: nil)
                notifications.append(newNotification)
           }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func fireNotification() -> NotificationValue {
    
    let newNotification = NotificationValue(
        content: nil,
        imageName: nil)
    return newNotification
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        if UIApplication.shared.hasDynamicIsland {
            // Mark: Animated custom Dynamic Screen.
            NotificationCenter.default.post(
                name: NSNotification.dynamicIslandAlert,
                object: nil,
                userInfo: [
                    "info": "Test",
                    "content": notification.request.content
                ]
            )
            return [.sound]
        } else {
            //Mark: Normal Notification.
            return [.sound, .badge]
        }
    }
}

extension UIApplication {
    var hasDynamicIsland: Bool {
        return deviceName == "iPhone 14 Pro" || deviceName == "iPhone 14 Pro Max"
    }
    var deviceName:String {
        UIDevice.current.name
    }
}


extension NSNotification {
    static let dynamicIslandAlert = Notification.Name.init("dynamicIslandAlert")
}
