//
//  CheckedContinuationView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.06.2022.
//

import SwiftUI

class CheckedContinuationViewNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch  {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase() async -> UIImage {
        await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }

}

class CheckedContinuationViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationViewNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200")  else { return  }
        
        do {
            let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
            
        } catch  {
            print(error)
        }
    }
    
    func getHeartImage() async {
        image = await   networkManager.getHeartImageFromDatabase()
    }
}

struct CheckedContinuationView: View {
    
    @StateObject private var vm = CheckedContinuationViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            await vm.getImage()
            await vm.getHeartImage()
        }
    }
}

struct CheckedContinuationView_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationView()
    }
}
