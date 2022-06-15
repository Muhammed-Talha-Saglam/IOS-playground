//
//  AsynPublisherView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 15.06.2022.
//

import SwiftUI
import Combine

actor AsynPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Grape")
    }
}

class AsynPublisherViewModel: ObservableObject {

    @MainActor @Published var dataArray: [String] = []
    let manager = AsynPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            for await value in await manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
        }
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsynPublisherView: View {
    
    @StateObject private var vm = AsynPublisherViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(vm.dataArray, id: \.self) {
                Text($0)
                    .font(.headline)
            }
        }
        .task {
            await vm.start()
        }
    }
}

struct AsynPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        AsynPublisherView()
    }
}
