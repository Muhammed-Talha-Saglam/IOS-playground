//
//  NotificationView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 20.06.2022.
//

import SwiftUI

struct NotificationsListView: View {
    
    @StateObject private var lnManager = LocalNotificationManager()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            VStack {
                
                if lnManager.isGranted {
                    
                    GroupBox("Schedule") {
                        Button("Interval Notification") {
                            Task {
                                let notification = LocalNotification(identifier: UUID().uuidString, title: "Some title", body: "Some body", timeInterval: 5, repeats: false)
                                await lnManager.schedule(localNotification: notification)
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Calendar Notification") {
                            
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(width: 300)
                    
                    List {
                        ForEach(lnManager.pendingRequest, id: \.identifier) { request in
                            VStack(alignment: .leading) {
                                Text(request.content.title)
                                HStack {
                                    Text(request.identifier)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions {
                                Button("DELETE", role: .destructive) {
                                    lnManager.removeRequest(withIdentifier: request.identifier)
                                }
                            }
                        }
                    }
                    
                } else {
                    Button("Enable Notification") {
                        lnManager.openSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .navigationTitle("Local Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        lnManager.clearRequest()
                    } label: {
                        Image(systemName: "clear.fill")
                            .imageScale(.large)
                    }

                }
            }
        }
        .navigationViewStyle(.stack)
        .environmentObject(lnManager)
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        }

    }
}

struct NotificationsListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsListView()
    }
}
