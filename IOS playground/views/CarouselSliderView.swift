//
//  CarouselSliderView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 25.06.2022.
//

import SwiftUI

struct CarouselSliderView: View {
    var images = ["thumb1","thumb2","thumb3","thumb4","thumb5",]
    @State var currentTab = "thumb1"
    
    var body: some View {
        ZStack {
            
            GeometryReader { proxy in
                let size = proxy.size
                
                Image(currentTab)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(1)
            }
            .ignoresSafeArea()
            .overlay(.ultraThinMaterial)
            .colorScheme(.dark)
            
            // Carousel List
            TabView(selection: $currentTab) {
                ForEach(images, id: \.self) { image in
                    CarouselBodyView(image: image)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct CarouselSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSliderView()
    }
}


struct CarouselBodyView: View {
    
    var image: String
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - 8, height: size.height / 1.2)
                    .cornerRadius(12)
                
                VStack {
                    
                    VStack(alignment: .leading, spacing: 10) {

                        Text("Human Integration Supervisor")
                            .font(.title2.bold())
                        // Letter spacing
                        
                        Text("The world's largest collection of animal facts, pictures, and more!")
                            .foregroundColor(.white)
                            .kerning(1.2)

                    }
                    .foregroundColor(.white)
                    .padding(.top)
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading ,spacing: 30.0) {
                        HStack(spacing: 15.0) {
                            Image("talha")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Talha")
                                    .font(.title2.bold())
                                
                                Text("Apple")
                                    .foregroundColor(.white)
                                
                            }
                            .foregroundColor(.black)
                        }
                        
                        HStack {
                            VStack {
                                Text("1303")
                                    .font(.title2.bold())
                                Text("Posts")
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Text("3103")
                                    .font(.title2.bold())
                                Text("Followers")
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Text("1503")
                                    .font(.title2.bold())
                                Text("Following")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.black)
                    }
                    .padding()
                    .padding(.horizontal, 10)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 4))
                }
                .padding(20)
            }
            .frame(width: size.width - 8, height: size.height / 1.2)
            .frame(width: size.width, height: size.height)
        }
        .tag(image)
        .rotation3DEffect(.init(degrees: getProgress() * 90), axis: (x: 0, y: 1, z: 0), anchor: offset > 0 ? .leading : .trailing, anchorZ: 0, perspective: 0.6)
        .modifier(ScrollViewOffsetModifier(anchorPoint: .leading, offset: $offset))
    }
    
    func getProgress() -> CGFloat {
        let progress = -offset / UIScreen.main.bounds.width
        return progress
    }
}

struct ScrollViewOffsetModifier: ViewModifier {
    
    var anchorPoint: Anchor = .top
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy -> Color in
                    
                    let frame = proxy.frame(in: .global)
                    
                    DispatchQueue.main.async {
                        switch anchorPoint {
                        case .top:
                            offset = frame.minY
                        case .bottom:
                            offset = frame.maxY
                        case .leading:
                            offset = frame.minX
                        case .trailing:
                            offset = frame.maxX
                        }
                    }
                    
                    return Color.clear
                }
            )
    }
}


enum Anchor {
    case top
    case bottom
    case leading
    case trailing
}
