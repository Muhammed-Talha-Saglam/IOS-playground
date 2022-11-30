//
//  magnificationView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 30.11.2022.
//

import SwiftUI

struct magnificationView: View {
    // Magnification Properties
    @State var scale: CGFloat = 0
    @State var rotation: CGFloat = 0
    @State var size: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader {
                let size = $0.size
                
                Image("talha")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    /// Adding magnification Modifier
                    .magnificationEffect(scale, rotation, self.size, tint: .white)
            }
            .padding(50)
            .contentShape(Rectangle())
            
        
            // MARK: Customization Option
            VStack(alignment: .leading,spacing: 0){
                Text("Customizations")
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(.bottom, 20)
                
                HStack(spacing: 14) {
                    Text("Scale")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35, alignment: .leading)
                        
                    Slider(value: $scale)
                    
                    Text("Rotation")
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                    Slider(value: $rotation)
                }
                .tint(.black)
                
                HStack(spacing: 14) {
                    Text("Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(width: 35, alignment: .leading)

                    Slider(value: $size, in: -20...100)
                }
                .tint(.black)
                .padding(.top)
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white)
                    .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(content: {
            Color.black
                .opacity(0.08)
                .ignoresSafeArea()
        })
        .preferredColorScheme(.light)
    }
}

struct magnificationView_Previews: PreviewProvider {
    static var previews: some View {
        magnificationView()
    }
}

// MARK: Custom View Modifier
extension View{
    @ViewBuilder
    func magnificationEffect(_ scale: CGFloat, _ rotation: CGFloat, _ size: CGFloat = 0,tint: Color = .white)->some View{
        MagnificationEffectHelper(scale: scale, rotation: rotation, size: size, tint: tint) {
            self
        }
    }
}

// Magnification Effect Helper
fileprivate struct MagnificationEffectHelper<Content: View>: View{
    var scale: CGFloat
    var rotation: CGFloat
    var size: CGFloat
    var tint: Color  = .white
    var content: Content

    init(scale: CGFloat, rotation: CGFloat, size: CGFloat, tint: Color = .white, @ViewBuilder content: @escaping ()->Content) {
        self.scale = scale
        self.rotation = rotation
        self.size = size
        self.tint = tint
        self.content = content()
    }
    
    // MARK: Gesture Properties
    @State var offset: CGSize = .zero
    @State var lastStoredOffset: CGSize = .zero
    
    var body: some View{
        content
        // MARK: Applying Reverse Mask for Clipping the current Highlighting Spot
            .reverseMask(content: {
                let newCircleSize = 150 + size
                Circle()
                    .frame(width: newCircleSize, height: newCircleSize)
                    .offset(offset)
            })
            .overlay {
                GeometryReader {
                    let newCircleSize = 150 + size
                    let size = $0.size
                    
                    content
                        .frame(width: size.width, height: size.height)
                        //Moving Content inside (reversing)
                        .offset(x: -offset.width, y: -offset.height)
                        .frame(width: newCircleSize, height: newCircleSize)
                        .scaleEffect(1 + scale)
                        .clipShape(Circle())
                        .offset(offset)
                        /// Making it center
                        .frame(width: size.width, height: size.height)
                    
                    
                    /// MARK: Optional Magnifyingglass Image Overlay
                    Circle()
                        .fill(.clear)
                        .frame(width: newCircleSize, height: newCircleSize)
                        .overlay(alignment: .topLeading,content: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(1.4, anchor: .topLeading)
                                .offset(x: -10, y: -5)
                                .foregroundColor(tint)
                        })
                        .rotationEffect(.init(degrees: rotation * 360.0))
                        .offset(offset)
                        .frame(width: size.width, height: size.height)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = CGSize(width: lastStoredOffset.width + value.translation.width, height: lastStoredOffset.height + value.translation.height)
                    })
                    .onEnded({ value in
                        lastStoredOffset = offset
                    })
            )
    }
}

extension View{
    // MARK: ReverseMask modifier
    @ViewBuilder
    func reverseMask<Content: View>(@ViewBuilder content: @escaping ()->Content)->some View{
        self
            .mask {
                Rectangle()
                    .overlay {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}
