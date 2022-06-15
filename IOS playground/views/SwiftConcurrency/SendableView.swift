//
//  SendableView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 13.06.2022.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: UserInfo) {
        
    }
}

struct UserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    
    let queue = DispatchQueue(label: "dev.bytecode.MyApp")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {

        let info = UserInfo(name: "Jim")

        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableView: View {
    
    @StateObject private var vm = SendableViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SendableView_Previews: PreviewProvider {
    static var previews: some View {
        SendableView()
    }
}
