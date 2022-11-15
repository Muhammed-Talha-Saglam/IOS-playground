//
//  APIService.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 13.11.2022.
//

import Combine
import Foundation

// Model
struct MyUser: Codable {
  struct Address: Codable {
    struct Geo: Codable {
      let lat: String
      let lng: String
    }

    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
  }

  struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
  }

  let id: Int
  let name: String
  let username: String
  let email: String
  let address: Address
  let phone: String
  let website: String
  let company: Company
}

// Generic Service
struct APIService {
    static func get<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// Use case
struct UserService {
    static func getUsers() -> AnyPublisher<[MyUser], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        return APIService
            .get(for: url)
    }
}



// Sample ViewModel
final class ContentViewModel: ObservableObject {
    @Published var value = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        load()
    }
    
    func load() {
        UserService
            .getUsers()
            .receive(on: RunLoop.main)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] (users) in
                self?.value = users.first!.name
            }
            .store(in: &cancellables)
    }
}
