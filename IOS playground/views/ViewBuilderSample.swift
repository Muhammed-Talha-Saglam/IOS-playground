//
//  ViewBuilderSample.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 26.05.2022.
//

import SwiftUI

struct HeaderViewGeneric<Content: View> : View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 2)
        }
    }
}

struct ViewBuilderSample: View {
    var body: some View {
        HeaderViewGeneric(title: "Title") {
            HStack {
                Text("Content")
                Image(systemName: "heart.fill")
            }
        }
        .padding()
    }
}

struct ViewBuilderSample_Previews: PreviewProvider {
    static var previews: some View {
        ViewBuilderSample()
    }
}
