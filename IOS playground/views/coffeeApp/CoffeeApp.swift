//
//  CoffeeApp.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 8.11.2022.
//

import SwiftUI

struct CoffeeApp: View {

    @State var offsetY: CGFloat = 0
    @State var currentIndex: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            // MARK: Since Card Size is the Size of the Screen With
            let cardSize = size.width * 1
            
            // MARK: Bottom Gradient Background
            LinearGradient(colors: [
                .clear,
                Color.brown.opacity(0.2),
                Color.brown.opacity(0.45),
                Color.brown,
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            
            // MARK: Header View
            HeaderView()
            
            VStack(spacing: 0) {
                ForEach(coffees) { coffee in
                    CoffeeView(coffee: coffee, size: size)
                }
            }
            .frame(width: size.width)
            .padding(.top, size.height-cardSize)
            .offset(y: offsetY)
            .offset(y: -currentIndex * cardSize)
        }
        .coordinateSpace(name: "SCROLL")
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    // Slowing down the gesture
                    offsetY = value.translation.height * 0.4
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    
                    withAnimation(.easeInOut) {
                    
                        if translation > 0 {
                            if currentIndex > 0 && translation > 250 {
                                currentIndex -= 1
                            }
                        } else {
                            if currentIndex < CGFloat(coffees.count-1) && -translation > 250 {
                                currentIndex += 1
                            }
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .preferredColorScheme(.light)
    }
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "cart.fill")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                }
            }
            
                
            // Animated Slider
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 0) {
                    ForEach(coffees) { coffee in
                        VStack(spacing: 15) {
                            Text(coffee.title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            
                            Text(coffee.price)
                                .font(.title)
                        }
                        .frame(width: size.width)
                        
                    }
                }
                .offset(x: currentIndex * -size.width)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: currentIndex)
            }
            .padding(.top, -5)
            
        }
        .padding(15)
    }
}

struct CoffeeApp_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeApp()
    }
}


struct CoffeeView: View {
    var coffee: Coffee
    var size: CGSize
    
    var body: some View {
        // MARK: If you want to decrease the size of the image, then change it's card size
        let cardSize = size.width * 1
        // Since I want To Show 3 Cards on the Display
        // Since We Used Scaling To Decrease The view Size, Add Extra One
        let maxCardDisplaySize = size.width * 4

        GeometryReader { proxy in
            let _size = proxy.size
                
            // Current Card Offset
            let offset = proxy.frame(in: .named("SCROLL")).minY - (size.height - cardSize)
            let scale = offset <= 0 ? (offset / maxCardDisplaySize) : 0
            let reducedScale = 1 + scale
            let currentCardScale = offset / cardSize
            
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: _size.width, height: _size.height)
                // MARK: Updating Anchor Based on the Current Card Scale
                .scaleEffect(reducedScale < 0 ? 0.001 : reducedScale, anchor: .init(x: 0.5, y: 1 - (currentCardScale/2.4)))
                // MARK: When it's Coming from bottom Animating the Scale from large to Actual
                .scaleEffect(offset > 0 ? 1 + currentCardScale : 1, anchor: .top)
                // MARK: To Remove the Excess Next View Using Offset to Move the View in Real Time
                .offset(y: offset > 0 ? currentCardScale * 200 : 0)
                // Making it More Compact
                .offset(y: currentCardScale * -130)

        }
        .frame(height: cardSize)
    }
}
