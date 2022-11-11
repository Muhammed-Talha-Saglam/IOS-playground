//
//  AnimatedCarousel.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.11.2022.
//

import SwiftUI

struct AnimatedCarousel: View {
    
    @State var cards: [Card] = []
    
    var body: some View {
        VStack{
            Carousel3D(cardSize: CGSize(width: 150, height: 220), items: cards, id: \.id,
                    content: { card in
                CardView(card: card)
            })
            .padding(.bottom, 100)
            
            HStack {
                Button {
                    // MARK: Adding Next Card
                    if cards.count != 6 {
                        cards.append(.init(imageFile: "talha"))
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .tint(.blue)

                Button {
                    cards.removeLast()
                } label: {
                    Label("delete", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
                .tint(.red)

            }
        }
        .onAppear {
            for index in 1...5 {
                cards.append(.init(imageFile: "thumb\(index)"))
            }
            cards.append(.init(imageFile: "talha"))
        }

    }
}

// MARK: Card View
struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            Image(card.imageFile)
                .resizable()
                .aspectRatio(contentMode: .fill)
            }
        .frame(width: 150, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct AnimatedCarousel_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCarousel()
    }
}

struct Carousel3D<Content: View, ID, Item> : View where Item: RandomAccessCollection, Item.Element: Identifiable, Item.Element: Equatable, ID: Hashable  {
    
    var cardSize: CGSize
    var items: Item
    var id: KeyPath<Item.Element, ID>
    var content: (Item.Element) -> Content
    
    var hostingViews: [UIView] = []
    
    // MARK: Gesture Properties
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @State var animationDuration: CGFloat = 0
    
    init(cardSize: CGSize, items: Item, id: KeyPath<Item.Element, ID>, @ViewBuilder content: @escaping (Item.Element) -> Content) {
        self.cardSize = cardSize
        self.items = items
        self.id = id
        self.content = content

        for item in items {
            let hostingView = convertToUIView(item: item).view!
            hostingViews.append(hostingView)
            
        }
    }
    
    var body: some View {
        CarouselHelper(views: hostingViews, cardSize: cardSize, offset: offset, animationDuration: animationDuration )
            .frame(width: cardSize.width, height: cardSize.height)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        animationDuration = 0
                        // MARK: Slowing Down
                        offset = (value.translation.width * 0.35) + lastStoredOffset
                    })
                    .onEnded({ value in
                        guard items.count > 0 else {
                            lastStoredOffset = offset
                            return
                        }
                        
                        // MARK: Adding Animation
                        animationDuration = 0.2
                        let anglePerCard = 360.0 / CGFloat(items.count)
                        offset = CGFloat(Int((offset / anglePerCard).rounded())) * anglePerCard
                        lastStoredOffset = offset
                    })
            )
            .onChange(of: items.count) { newValue in
                guard newValue > 0 else { return }
                // MARK: Animating When item is removed or inserted.
                animationDuration = 0.2
                let anglePerCard = 360.0 / CGFloat(newValue)
                offset = CGFloat(Int((offset / anglePerCard).rounded())) * anglePerCard
                lastStoredOffset = offset

            }
    }
    
    // MARK: Converting SwiftUI view into UIKit view
    func convertToUIView(item: Item.Element) -> UIHostingController<Content> {
        let hostingView = UIHostingController(rootView: content(item))
        hostingView.view.frame.origin = .init(x: cardSize.width/2, y: cardSize.height/2)
            
        hostingView.view.backgroundColor = .clear
            return hostingView
    }
}


// MARK: UIKit unwrapper
struct CarouselHelper: UIViewRepresentable {
    var views: [UIView]
    var cardSize: CGSize
    var offset: CGFloat
    var animationDuration: CGFloat

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Mark: Adding Views as Subviews
        // Only adding single time
        // Since we want cards to form a circle shape
        let circleAngle = 360.0 / CGFloat(views.count)
        var angle: CGFloat = offset

        if uiView.subviews.count > views.count {
            // MARK: Remove last subview
            uiView.subviews[uiView.subviews.count-1].removeFromSuperview()
        }
        
        for (view, index) in zip(views, views.indices) {
            if uiView.subviews.indices.contains(index) {
                // Already Added
                // Since It's already added, do the modifications here
                apply3DTransform(view: uiView.subviews[index], angle: angle)
                // MARK: We need disable all other card rather than our center to enable proper button/taps
                let completeRotation = CGFloat(Int(angle / 360)) * 360.0
                if (angle - completeRotation) == 0 {
                    uiView.subviews[index].isUserInteractionEnabled = true
                } else {
                    uiView.subviews[index].isUserInteractionEnabled = false
                }
                
                angle += circleAngle

            } else {
                // Add for the first time
                let hostView = view
                hostView.frame = .init(origin: .zero, size: cardSize)
                uiView.addSubview(hostView)
                
                apply3DTransform(view: uiView.subviews[index], angle: angle)
                angle += circleAngle
            }
        }
    }
    
    func apply3DTransform(view: UIView, angle: CGFloat) {
        // MARK: Adding 3D Transform
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / 500
        
        // MARK: Calculating Angle
        
        // MARK: Transform Uses Radians
        transform3D = CATransform3DRotate(transform3D, degToRadian(deg: angle), 0, 1, 0)
        transform3D = CATransform3DTranslate(transform3D, 0, 0, 150)
        
        UIView.animate(withDuration: animationDuration) {
            view.transform3D = transform3D
        }
    }
}

func degToRadian(deg: CGFloat) -> CGFloat {
    return (deg * .pi ) / 180
}
