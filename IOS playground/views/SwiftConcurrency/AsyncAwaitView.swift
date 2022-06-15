//
//  AsyncAwaitView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 10.06.2022.
//

import SwiftUI


class AsyncAwaitViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1: \(Thread.current)")
        }
    }

    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let threadName = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(threadName)
                self.dataArray.append("Title3: \(Thread.current)")
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let author2 = "Author2: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        }
        
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something1: \(Thread.main)"
        await MainActor.run {
            self.dataArray.append(something1)
            let something2 = "Something2: \(Thread.main)"
            self.dataArray.append(something2)
        }

    }

}

struct AsyncAwaitView: View {
    
    @StateObject private var vm = AsyncAwaitViewModel()
    
    var body: some View {
        List {
            ForEach(vm.dataArray, id: \.self, content: { data in
                Text(data)
            })
        }
        .onAppear {
//            vm.addTitle1()
//            vm.addTitle2()
            Task {
                await vm.addAuthor1()
                await vm.addSomething()
                
                let finalText = "Final Text: \(Thread.current)"
                vm.dataArray.append(finalText)
            }
        }
    }
}

struct AsyncAwaitView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitView()
    }
}
