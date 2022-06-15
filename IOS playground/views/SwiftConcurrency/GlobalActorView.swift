//
//  GlobalActorView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.06.2022.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["one", "two", "three"]
    }
}

//@MainActor
class GlobalActorViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
   
    @MyFirstGlobalActor
    func getData() async {
        
        // HEAVY COMPLEX METHODS
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run(body: {
                self.dataArray = data
            })
        }
    }
}

struct GlobalActorView: View {
    
    @StateObject private var vm = GlobalActorViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
}

struct GlobalActorView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorView()
    }
}
