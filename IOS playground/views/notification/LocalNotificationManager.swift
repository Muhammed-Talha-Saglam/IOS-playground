//
//  LocalNotificationManager.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 20.06.2022.
//

import Foundation
import UserNotifications
import UIKit

@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    @Published var pendingRequest: [UNNotificationRequest] = []
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // Delegate func
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
        
    }
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: localNotification.timeInterval, repeats: localNotification.repeats)
        
        let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
        try? await notificationCenter.add(request)
        await getPendingRequests()
    }
    
    func getPendingRequests() async {
        pendingRequest = await notificationCenter.pendingNotificationRequests()
    }
    
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequest.firstIndex(where: { $0.identifier == identifier }) {
            pendingRequest.remove(at: index)
        }
    }
    
    func clearRequest() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequest.removeAll()
    }
}
