//
//  NavigationStataManager.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 15.11.2022.
//

import Foundation
import Combine

enum SelectionState: Hashable, Codable {
    case movie(String)
    case song(String)
    case book(String)
    case settings
}


class NavigationStateManager: ObservableObject {
    @Published var selectionPath =  [SelectionState]()
    
    // Usu this in the UIView with @SceneStorage("navigationState") var navigationStateData: Data?
    var data: Data? {
        get {
            try? JSONEncoder().encode(selectionPath)
        }
        set {
            guard let data = newValue,
                  let path = try? JSONDecoder().decode([SelectionState].self, from: data) else {
                return
            }
            
            selectionPath = path
        }
    }
    
    
    func popToRoot() {
        selectionPath = []
    }
    
    func goToSettings(){
        selectionPath = [SelectionState.settings]
    }
    
    //
    var objectWillChangeSequebce: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
}

/*
    @StateObject var navigationStateManager = NavigationStateManager()
    @SceneStorage("navigationState") var navigationStateData: Data?
    
    var body: some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
        ...
    }
    .onReceive(navigationStateManager.objectWillChange.dropFirst()) { _ in
        // save state to userdefaults
        navigationStateData = navigationStateManager.data
    }
    .onAppear {
        // reset during launch
        navigationStateManager.data = navigationStateData
    }
 */


