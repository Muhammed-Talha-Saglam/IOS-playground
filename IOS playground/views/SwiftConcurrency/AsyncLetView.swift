//
//  AsyncLetView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.06.2022.
//

import SwiftUI

struct AsyncLetView: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp")
            .onAppear {
                Task {
                    do {
                        // Syncrounous way
//                        let image = try await fetchImage()
//                        self.images.append(image)
//
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//
//                        let image4 = try await fetchImage()
//                        self.images.append(image4)
                        
                        // Async way
                        async let fetchedImage1 = fetchImage()
                        async let fetchedTitle = fetchTitle()
                        async let fetchedImage2 = fetchImage()
                        async let fetchedImage3 = fetchImage()
                        async let fetchedImage4 = fetchImage()

                        let (image1, image2, image3, image4, title) = await (
                            try fetchedImage1,
                            try fetchedImage2,
                            try fetchedImage3,
                            try fetchedImage4,
                            fetchedTitle
                        )
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        
                    } catch  {
                        
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "NEW TITLE"
    }
    
    func fetchImage() async throws -> UIImage {
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

struct AsyncLetView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetView()
    }
}
