//
//  AdvancedCombineView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.06.2022.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
//    @Published var basicPublisher: String = "First Publish"
//    let currentValuePublisher = CurrentValueSubject<String, Error>("First Publish")
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intThroughPublisher = PassthroughSubject<Int, Error>()

    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items: [Int] = Array(0..<11)
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
                self.passThroughPublisher.send(items[x])
                if x > 4 && x < 8 {
                    self.boolPublisher.send(true)
                    self.intThroughPublisher.send(99)
                }
                
                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
    }
    
}


class AdvancedCombineViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var dataBools: [Bool] = []
    @Published var error: String = ""
    
    let dataService = AdvancedCombineDataService()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
//        dataService.passThroughPublisher
        // Sequnce Operations
        /*
//            .first()
//            .first(where: { $0 > 4})
//            .tryFirst { int in
//                if int == 3  {
//                    throw URLError(.badServerResponse)
//                }
//
//                return int > 1
//            }
//            .last()
//            .last(where: { $0 > 4})
//            .dropFirst()
//            .dropFirst(3)
//            .prefix(4)
//            .output(at: 2)
//            .output(in: 2..<4)
            */
        
        // Math Opertaions
        /*
//            .max()
//            .max(by: {int1, int2 in
//                return int1 < int2
//            })
//
        */
        
        // Filter / Reducing Operations
        /*
        //    .map({ String($0)})
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return String(int)
//            })
            // Ignore some values
//            .compactMap({ int in
//                if int == 5 {
//                    return nil
//                }
//
//                return String(int)
//            })
//            .filter({ ($0 > 3) && ($0 < 7)})
//            .removeDuplicates()
//            .replaceNil(with: 0)
//            .replaceEmpty(with: 0)
//            .replaceError(with: 0)
//            .scan(0, {existingValue, nextValue in
//                return existingValue + nextValue
//            })
//            .scan(0, { $0 + $1 })
        // waits until completion, then returns final value
//            .reduce(0, {existingValue, nextValue in
//                return existingValue + nextValue
//            })
//            .collect()
//            .collect(3)
//            .allSatisfy({$0 == 5})
  */
        
        //Timning Operations
        /*
//            .debounce(for: 1, scheduler: DispatchQueue.main)
//            .delay(for: 2, scheduler: DispatchQueue.main)
//            .throttle(for: 10, scheduler: DispatchQueue.main, latest: true)
//            .retry(3)
//            .timeout(0.75, scheduler: DispatchQueue.main)
        */
        
        //Multiple Publishers
        /*
//            .combineLatest(dataService.boolPublisher, dataService.intThroughPublisher)
//            .compactMap({(int1, bool, int2) in
//                if bool {
//                    return "\(int1), \(int2)"
//                }
//                return nil
//            })
//            .compactMap({ $1 ? "\($0)" : nil })
//            .merge(with: dataService.intThroughPublisher)
//            .zip(dataService.boolPublisher)
//            .map({ tuple in
//                return "\(tuple.0) - \(tuple.1)"
//            })
//            .tryMap({ _ in
//                throw URLError(.badServerResponse)
//            })
//            .catch({error in
//                return self.dataService.intThroughPublisher
//            })
        */

        let sharedPublisher =         dataService.passThroughPublisher
            .dropFirst(3)
            .share()

        sharedPublisher
            .map({ String($0)})
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "Error: \(error)"
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)

        sharedPublisher
            .map({ $0 > 5 ? true : false})
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "Error: \(error)"
                }
            } receiveValue: { [weak self] returnedValue in
                self?.dataBools.append(returnedValue)
            }
            .store(in: &cancellables)

    }
}

struct AdvancedCombineView: View {
    
    @StateObject private var vm = AdvancedCombineViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    ForEach(vm.data, id: \.self) { data in
                        Text(data)
                            .bold()
                    }
                    
                    if !vm.error.isEmpty {
                        Text(vm.error)
                    }
                }
                
                VStack {
                    ForEach(vm.dataBools, id: \.self) { data in
                        Text("\(data)")
                            .bold()
                    }
                }
            }
        }
    }
}

struct AdvancedCombineView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineView()
    }
}
