//
//  IsometricView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 12.11.2022.
//

import SwiftUI

struct IsometricView<Content: View, Bottom: View, Side: View>: View {
    var content: Content
    var bottom: Bottom
    var side: Side
    
    // Isometric Depth
    var depth: CGFloat

    init(depth: CGFloat, @ViewBuilder content: @escaping() -> Content, @ViewBuilder bottom: @escaping() -> Bottom, @ViewBuilder side: @escaping() -> Side) {
        self.depth = depth
        self.content = content()
        self.bottom = bottom()
        self.side = side()
    }
    
    var body: some View {
        Color.clear
        // For Geometry to take the specified space
            .overlay {
                GeometryReader {
                    let size = $0.size
                    
                    ZStack{
                        content
                        DepthView(isBottom: true, size: size)
                        DepthView(size: size)
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
    }
    
    // MARK: Depth View's
    @ViewBuilder
    func DepthView(isBottom: Bool = false, size: CGSize) -> some View{
        ZStack{
            if isBottom {
                bottom
                    .scaleEffect(y: depth, anchor: .bottom)
                    // If you don't want original image but strech at the side use alignment else remove
                    .frame(height: depth, alignment: .bottom)
                    //MARK: Dimming Content With Blur
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    // Applying transforms
                    .projectionEffect(.init(.init(1, 0, 1, 1, 0, 0)))
                    .offset(y: depth)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else{
                side
                    .scaleEffect(x: depth, anchor: .trailing)
                    // If you don't want original image but strech at the side use alignment else remove
                    .frame(width: depth, alignment: .trailing)
                    //MARK: Dimming Content With Blur
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(0.25))
                            .blur(radius: 2.5)
                    })
                    .clipped()
                    // Applying transforms
                    .projectionEffect(.init(.init(1, 1, 0, 1, 0, 0)))
                    // Change Offset and Transform values as you wish
                    .offset(x: depth)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct CustomProjectionPair: GeometryEffect {
    var b: CGFloat
    var c: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat>{
        get{
            return AnimatablePair(b, c)
        }
        set{
            b = newValue.first
            c = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return .init(.init(1, b, c, 1, 0, 0))
    }
}

struct CustomProjection: GeometryEffect {
    var value: CGFloat
    
    var animatableData: CGFloat{
        get{
            return value
        }
        set{
            value = newValue
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        var transform = CATransform3DIdentity
        transform.m11 = (value == 0 ? 0.0001 : value )
        return .init(transform)
    }
}
