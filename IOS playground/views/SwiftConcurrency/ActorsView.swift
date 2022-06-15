//
//  ActorsView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.06.2022.
//

import SwiftUI
import MapKit

class MyDataManager {
    static let instance = MyDataManager()
    
    private init() {}
    
    var data: [String] = []
    private let lock = DispatchQueue(label: "com.myApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
    
}

// Thread safe, precents race conditions
actor MyActorManager {
    static let instance = MyActorManager()
    
    private init() {}
    
    var data: [String] = []
    nonisolated let staticText = "Some data"
    
    func getRandomData() -> String? {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            return self.data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "New Data"
    }
    
}

struct ActorsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ActorsView_Previews: PreviewProvider {
    static var previews: some View {
        ActorsView()
    }
}
