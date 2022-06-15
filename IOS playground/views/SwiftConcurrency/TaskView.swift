//
//  TaskView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 10.06.2022.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
  
        // In a very long running Task, check if Task is cancelled.
//        for x in 1...10 {
//           try Task.checkCancellation()
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/200") else {return  }
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image = image
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else {return  }
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image2 = image
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
}


struct TaskHomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME! 😁") {
                    TaskView()
                }
            }
        }
    }
}

struct TaskView: View {
    
    @StateObject private var vm = TaskViewModel()
    @State private var fetchImagetask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40.0) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
        }
        .task {
            // task scope cancel any running Task automatically on disappear.
            await vm.fetchImage()
        }
//        .onDisappear(perform: {
//            fetchImagetask?.cancel()
//        })
//        .onAppear {
//            fetchImagetask = Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await vm.fetchImage()
//            }
//            Task {
//                await vm.fetchImage2()
//            }
            
            
//            Task(priority: .high) {
//
//            }
//            Task(priority: .userInitiated) {
//
//            }
//            Task(priority: .medium) {
//
//            }
//            Task(priority: .low) {
//
//            }
//            Task(priority: .utility) {
//
//            }
//            Task(priority: .background) {
//
//            }
         
        }
    }


struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}
