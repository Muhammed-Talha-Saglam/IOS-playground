//
//  ParallaxCardEffectView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 15.11.2022.
//

import SwiftUI

struct ParallaxCardEffectView: View {
    //MARK: Gesture properties
    @State var offset: CGSize = .zero

    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageSize = size.width * 0.7
            VStack {
                Image("thumb3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize * 0.8)
                    .rotationEffect(.init(degrees: -30))
                    .zIndex(1)
                    .offset(x: offset2Angle().degrees * 5, y: offset2Angle(true).degrees * 5)
                    
                
                Text("Talha")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .padding(.top, -20)
                    .padding(.bottom, 50)
                    .foregroundColor(.white)
                    .zIndex(0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Saglam")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .fontWidth(.compressed)
                    
                    HStack {
                        
                        BlendedText("AIR JORDAN 1 MID SE")
                        
                        Spacer(minLength: 0)
                        
                        BlendedText("$128")
                    }
                    
                    HStack {
                        BlendedText("YOUR NEXT SHOES")
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            
                        } label: {
                            Text("BUY")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.yellow)
                                        .brightness(-0.1)
                                }
                        }
                        
                        
                    }
                    .padding(.top, 14)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            .padding(.top, 65)
            .frame(width: imageSize)
            .background(content: {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(.black.opacity(0.9))
                    
                    Circle()
                        .fill(.yellow)
                        .frame(width: imageSize, height: imageSize)
                        .scaleEffect(1.2, anchor: .leading)
                        .offset(x: imageSize * 0.3, y: -imageSize * 0.2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            })
            .rotation3DEffect(offset2Angle(true), axis: (x: -1, y: 0, z: 0))
            .rotation3DEffect(offset2Angle(), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(offset2Angle(true) * 0.1, axis: (x: 0, y: 0, z: 1))
            .scaleEffect(0.9)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = value.translation
                    })
                    .onEnded({ value in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)) {
                            offset = .zero
                        }
                    })
            )
        }
    }
    
    //MARK Converting Offset into X,Y Angles
    func offset2Angle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offset.height : offset.width) / (isVertical ? screenSize.height : screenSize.width)

        return .init(degrees: progress * 10)
    }
    
    //MARK: Device screen size
    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        return window.screen.bounds.size
    }()
    
    @ViewBuilder
    func BlendedText(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.condensed)
            .blendMode(.difference)

    }
 }

struct ParallaxCardEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxCardEffectView()
    }
}
