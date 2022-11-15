//
//  BoomerangCardView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 14.11.2022.
//

import SwiftUI

struct BoomerangCardView: View {
    @State var cards: [BoomerangCard] = []
    @State var isBlurEnabled: Bool = false
    @State var isRotationEnabled: Bool = true

    var body: some View {
        VStack {
            Toggle("Enable Blur", isOn: $isBlurEnabled)
            Toggle("Turn On Rotation", isOn: $isRotationEnabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            BoomerangCardViewItem(isBlurEnabled: isBlurEnabled, isRotationEnabled: isRotationEnabled, cards: $cards)
                .frame(height: 220)
                .padding(.horizontal, 15)
        }
        .padding(15)
        .background(
            Color.black
        )
        .preferredColorScheme(.dark)
        .onAppear {
            setUpCards()
        }
        
    }
    
    func setUpCards() {
        for index in 1...5 {
            cards.append(.init(imageName: "thumb\(index)"))
        }
        
        // For infinite card
        // Logic is simpl. Place the firs car at last
        // When the last card is arrived, set index to 0
        
        if var first = cards.first {
            first.id = UUID().uuidString
            cards.append(first)
        }
    }
}

struct BoomerangCardView_Previews: PreviewProvider {
    static var previews: some View {
        BoomerangCardView()
    }
}


// MARK: Boomerang Card View
struct BoomerangCardViewItem: View {
    var isBlurEnabled: Bool = false
    var isRotationEnabled: Bool = true
    @Binding var cards: [BoomerangCard]
    
    // MARK: Gesture Properties
    @State var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(cards.reversed()) { card in
                    CardView(card: card, size: size)
                    // Moving Only Current Active Card
                        .offset(y: currentIndex == indexOf(card: card) ? offset : 0)
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: offset == .zero)
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged(onChanged(value:))
                    .onEnded(onEnded(value:))
            )
        }
    }
    
    
    // MARK: Gesture Calls
    func onChanged(value: DragGesture.Value){
        // For safety
        offset = currentIndex == (cards.count - 1) ? 0 : value.translation.height
    }
    
    func onEnded(value: DragGesture.Value){
        var translation = value.translation.height
        // Since we only need translation
        translation = (translation < 0 ? -translation : 0)
        translation = (currentIndex == (cards.count-1)) ? 0 : translation
        // Since our card height = 220
        if translation > 110 {
            // Doing Boomerang effect and updating current index.
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6)) {
                // Applying rotation and extra offset
                cards[currentIndex].isRotated = true
                // Give slightly bigger than card height
                cards[currentIndex].extraOffset = -350
                cards[currentIndex].scale = 0.7
            }
            
            // After a little delay Resetting Gesture offset and extra offset
            // Pushin card into back using Zindex
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6)) {
                    cards[currentIndex].zIndex = -100
                    for index in cards.indices {
                        cards[index].extraOffset = 0
                    }
                    // MARK: Updating current index
                    if currentIndex != (cards.count-1){
                        currentIndex += 1
                    }
                    offset = .zero
                }
            }
            
            // After animation completed resetting rotation, scaling and setting proper zindex value
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for index in cards.indices {
                    if index == currentIndex {
                        // MARK: Placing the card at the right index
                        // NOTE: Since the current index is updated +1 previously
                        // So the current index will be -1 now
                        if cards.indices.contains(currentIndex-1) {
                            cards[currentIndex-1].zIndex = ZIndex(card: cards[currentIndex-1])
                        }
                        
                    } else {
                        cards[index].isRotated = false
                        withAnimation(.linear) {
                            cards[index].scale = 1
                        }
                    }
                }
                
                if currentIndex == (cards.count - 1) {
                    // Resetting index to 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        for index in cards.indices {
                            // Resetting ZIndex
                            cards[index].zIndex = 0
                        }
                        currentIndex = 0
                    }
                }

            }
            
        } else {
            offset = .zero
        }
    }
    
    func ZIndex(card: BoomerangCard) -> Double{
        let index = indexOf(card: card)
        let totalCount = cards.count
        
        return currentIndex > index ? Double(index - totalCount): cards[index].zIndex
    }

    
    @ViewBuilder
    func CardView(card: BoomerangCard, size: CGSize) -> some View {
        let index = indexOf(card: card)
        
        Image(card.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .blur(radius: card.isRotated && isBlurEnabled ? 6.5 : 0)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(card.scale, anchor: card.isRotated ? .center : .top)
            .rotation3DEffect(.init(degrees: isRotationEnabled && card.isRotated ? 360 : 0), axis: (x: 0, y: 0, z: 1))
            .offset(y: -offsetFor(index: index))
            .offset(y: card.extraOffset)
            .scaleEffect(scaleFor(index: index), anchor: .top)
            .zIndex(card.zIndex)
    }
    
    // MARK: Scale and offset values for each card
    // Addressing negative indexes
    func scaleFor(index value: Int) -> Double {
        let index = Double(value - currentIndex)
        // MARK: I'm showing only 3 cards (your wish)
        
        if index >= 0{
            if index > 3 {
                return 0.8
            }
            
            return 1 - (index / 15)
        } else {
            if -index > 3 {
                return 0.8
            }
            
            return 1 + (index / 15)
        }
        
    }

    func offsetFor(index value: Int) -> Double {
        let index = Double(value - currentIndex)
        // MARK: I'm showing only 3 cards (your wish)
        if index >= 0{
            if index > 3 {
                return 30
            }
            
            return (index * 15)
        } else {
            if -index > 3 {
                return 30
            }
            
            return (-index * 15)
        }
    }

    
    func indexOf(card: BoomerangCard) -> Int {
        if let index = cards.firstIndex(where: { CCard in
            card.id == CCard.id
        }) {
            return index
        }
        
        return 0
    }
 }


