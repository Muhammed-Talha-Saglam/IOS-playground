//
//  ContentView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.05.2022.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        
        ZStack(alignment: .center){
            MarqueeText(text: "This is a sample text for the marquee effect.", duration: 5)
                .frame(width: 300, height: 50)
        
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MarqueeText: View {
    let text: String
    let duration: Double
    @State private var offset: CGFloat = 0
    var body: some View {
        GeometryReader { geometry in
            Text(self.text)
                .lineLimit(1)
                .offset(x: self.offset, y: 0)
                .onAppear {
                    withAnimation(Animation.linear(duration: self.duration).repeatForever(autoreverses: false)) {
                        self.offset = -geometry.size.width
                    }
                }
        }
    }
}

//func textSize()-> CGFloat {
//    let attributes = [NSAttributedString.Key.font: font]
//    let size = (text as NSString).size(withAttributes: attributes)
//
//    return size.width
//}
