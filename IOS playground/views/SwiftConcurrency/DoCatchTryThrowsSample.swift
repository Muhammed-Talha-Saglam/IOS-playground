//
//  DoCatchTryThrowsSample.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 10.06.2022.
//

import SwiftUI

class DoCatchTryThrowsDataManager {
    
    let isActive = false
    
    func getTitle() -> (title:String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Text"
        } else {
            throw URLError(.badURL)
        }
    }

}

class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text = "Starting text..."
    let manager = DoCatchTryThrowsDataManager()

    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            text = newTitle
        } else if let error = returnedValue.error {
            text = error.localizedDescription
        }
        */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newText):
            text = newText
        case .failure(let error):
            text = error.localizedDescription
        }
        */
        
        do {
            text = try manager.getTitle3()
        } catch let error {
            text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsSample: View {
    
    @StateObject private var vm = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsSample_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsSample()
    }
}
