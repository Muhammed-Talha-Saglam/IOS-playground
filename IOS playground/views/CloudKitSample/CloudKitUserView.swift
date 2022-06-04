//
//  CloudKitUserView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.06.2022.
//

import SwiftUI
import CloudKit
import Combine

class CloudKitUserViewModel: ObservableObject {
    
    @Published var permissionStatus: Bool = false
    @Published var isSignedInToIcloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getICloudStatus()
        getCurrentUserName()
    }
    
    private func getICloudStatus() {
        CloudKitUtility.getICloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSignedInToIcloud = success
            }
            .store(in: &cancellables)
    }
        
    func requestPermission() {
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }
    
    func getCurrentUserName() {
        CloudKitUtility.discoverUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedName in
                self?.userName = returnedName
            }
            .store(in: &cancellables)
    }
    
}

struct CloudKitUserView: View {
    
    @StateObject private var vm = CloudKitUserViewModel()
    
    var body: some View {
        VStack {
            Text("Is Signed In: \(vm.isSignedInToIcloud.description)")
            Text(vm.error)
            Text("Permission: \(vm.permissionStatus.description.uppercased())")
            Text("NAME: \(vm.userName)")
        }
    }
}

struct CloudKitUserView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUserView()
    }
}
