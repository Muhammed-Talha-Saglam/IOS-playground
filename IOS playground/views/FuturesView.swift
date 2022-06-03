//
//  FuturesView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.06.2022.
//

import SwiftUI
import Combine

class FuturesViewModel: ObservableObject {
    
    @Published var title: String = "Starting Title"
    let url = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        download()
    }
    
    func download() {
//        getCombinePublisher()
//            .sink(receiveCompletion: {_ in
//
//            }, receiveValue: { [weak self] returnedValue in
//                self?.title = returnedValue
//            })
//            .store(in: &cancellables)
        
//        getEscapingClosure { [weak self] value, error in
//            self?.title = value
//        }
        
//        getFuturePublisher()
//            .sink(receiveCompletion: {_ in
//                }, receiveValue: { [weak self] returnedValue in
//                        self?.title = returnedValue
//                })
//                .store(in: &cancellables)
        

    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New Value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?)  -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("New value 2", nil)
            
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error>{
        return Future { promise in
            self.getEscapingClosure { returnedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
    }
    
    func doSomething(completion: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion("NEW STRING")
        }
    }
    
    
    func doSomethingInTheFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }

}

struct FuturesView: View {
    
    @StateObject private var vm = FuturesViewModel()
    
    var body: some View {
        Text(vm.title)
    }
    
   
}

struct FuturesView_Previews: PreviewProvider {
    static var previews: some View {
        FuturesView()
    }
}
