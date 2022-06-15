//
//  TaskGroupView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.06.2022.
//

import SwiftUI

class TaskGroupDataManager {

    func fetchImageWithAsyncLet() async throws -> [UIImage] {
        async let fetchedImage1 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchedImage2 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchedImage3 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchedImage4 = fetchImage(urlString: "https://picsum.photos/200")

        let (image1, image2, image3, image4) = await (try fetchedImage1, try fetchedImage2, try fetchedImage3, try fetchedImage4)
        
        return [image1, image2, image3, image4]
    }
    
    func fetchImageWithTaskGroup() async throws -> [UIImage] {

        let urlStrings = [
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200"
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                group.addTask {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
            
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
}

class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImageWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupView: View {
    
    @StateObject private var vm = TaskGroupViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group ")
            .task {
                await vm.getImages()
            }
        }
    }
}

struct TaskGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupView()
    }
}
