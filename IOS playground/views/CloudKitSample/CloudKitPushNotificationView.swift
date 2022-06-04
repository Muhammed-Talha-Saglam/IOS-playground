//
//  CloudKitPushNotificationView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 4.06.2022.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationViewModel: ObservableObject {
    
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error: \(error)")
            } else if success {
                print("Notification Permission success")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification Permission unknown error")
            }
        }
    }
    
    func subscribeToNotification() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Fruit", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There is a new fruit!"
        notification.alertBody = "Open the app to check your fruits. "
        notification.soundName = "default"
        
        
        subscription.notificationInfo = notification
     
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print("Error: \(error)")
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
        
    }
    
    func unsubscribeToNotification() {
        
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print("Error: \(error)")
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }

}

struct CloudKitPushNotificationView: View {
    
    @StateObject private var vm = CloudKitPushNotificationViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Button("Request Notification Permission") {
                vm.requestNotificationPermission()
            }
            
            Button("Subscribe to Notifications") {
                vm.subscribeToNotification()
            }
            
            Button("Unsubscribe to Notifications") {
                vm.unsubscribeToNotification()
            }
        }
    }
}

struct CloudKitPushNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitPushNotificationView()
    }
}
