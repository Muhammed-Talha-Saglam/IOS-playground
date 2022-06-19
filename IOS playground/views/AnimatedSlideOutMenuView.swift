//
//  AnimatedSlideOutMenuView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 19.06.2022.
//

import SwiftUI

struct AnimatedSlideOutMenuView: View {
    
    @State var showMenu: Bool = false
    @State var animatePath: Bool = false
    @State var animateBG: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 15.0) {
             
                HStack {
                    
                    Button {
                        withAnimation {
                            animateBG.toggle()
                        }
                        
                        withAnimation(.spring()) {
                            showMenu.toggle()
                        }
                        
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3).delay(0.2)) {
                            animatePath.toggle()
                        }
                    } label: {
                        Image(systemName: "menucard")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .shadow(radius: 1)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.square.on.square")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .shadow(radius: 1)
                    }
                }
                .overlay(
                    Text("Stories")
                        .font(.title2.bold())
                )
                .foregroundColor(Color.white.opacity(0.8))
                .padding([.horizontal, .top])
                .padding(.bottom, 5)
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 25) {
                        ForEach(stories) { story in
                            CardView(story: story)
                        }
                    }
                    .padding()
                    .padding(.top, 20)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                
                LinearGradient(
                    colors: [.blue, .indigo],
                    startPoint: .top,
                    endPoint: .bottom)
                    .ignoresSafeArea()
            )
        
            Color.black.opacity(animateBG ? 0.25 : 0)
                .ignoresSafeArea()
            
            MenuView(showMenu: $showMenu, animatePath: $animatePath, animateBG: $animateBG)
                .offset(x: showMenu ? 0 : -getRect().width)
        
        }
    }
    
    
    @ViewBuilder
    func CardView(story: Story) -> some View {
        VStack(alignment: .leading, spacing: 12.0) {
            
            GeometryReader { proxy in
                let size = proxy.size
                Image(story.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(15)
            }
            .frame(height: 200)
    
            Text(story.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
        
            Button {
                
            } label: {
                Text("Read Now")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(
                        Capsule()
                            .fill(Color.red)
                    )
            }

        }
    }
}

struct AnimatedSlideOutMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedSlideOutMenuView()
    }
}



var stories = [
    
    Story(image: "thumb1", title: "Jack the Persian and the Black Castel"),
    Story(image: "thumb2", title: "The dreaming Moon"),
    Story(image: "thumb3", title: "Fallen In Love"),
    Story(image: "thumb4", title: "Hounted Ground"),

    
]

struct Story: Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var title: String
    
}


struct MenuView: View {
    
    @Binding var showMenu: Bool
    @Binding var animatePath: Bool
    @Binding var animateBG: Bool

    var body: some View {
        
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
            
            // Content
            VStack(alignment: .leading, spacing: 25.0) {
                
                Button {
                    
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3)) {
                        animatePath.toggle()
                    }
                    
                    withAnimation {
                        animateBG.toggle()
                    }
                    
                    withAnimation(.spring().delay(0.1)) {
                        showMenu.toggle()
                    }
                    
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                }
                .foregroundColor(Color.white.opacity(0.8))
                
                // Menu buttons
                MenuButton(title: "Premium Access", image: "square.grid.2x2", offset: 0)
                    .padding(.top, 40)
                MenuButton(title: "Upload Content", image: "square.and.arrow.up.on.square", offset: 10)
                MenuButton(title: "My Account", image: "talha", offset: 30)
                MenuButton(title: "Make Money", image: "dollarsign.circle", offset: 10)
                MenuButton(title: "Help", image: "questionmark.circle", offset: 0)

                Spacer()
                
                MenuButton(title: "LOGOUT", image: "rectangle.portrait.and.arrow.right", offset: 0)

            }
            .padding(.trailing, 120)
            .padding()
            .padding(.top, getSafeArea().top)
            .padding(.bottom, getSafeArea().bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
        }
        .clipShape(MenuShape(value: animatePath ? 150 : 0))
        .background(
            MenuShape(value: animatePath ? 150 : 0)
                .stroke(
                    .linearGradient(.init(colors: [
                        Color.purple,
                        Color.purple.opacity(0.7),
                        Color.purple.opacity(0.5)
                    ]), startPoint: .top, endPoint: .bottom),
                    lineWidth: animatePath ? 7 : 0
                )
                .padding(.leading, -50)
        )
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func MenuButton(title: String, image: String, offset: CGFloat) -> some View {
        Button {
            
        } label: {
            
            HStack(spacing: 12.0){
                if image == "talha" {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                } else {
                    Image(systemName: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(title == "LOGOUT" ? .semibold : .medium)
                    .kerning(title == "LOGOUT" ? 1.2 : 0.8)
                    .foregroundColor(.white.opacity(title == "LOGOUT" ? 0.9 : 0.65))
            }
            .padding(.vertical)
        }
        .offset(x: offset)
    }
}


struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
    
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct MenuShape: Shape {
    
    var value: CGFloat
    
    // Animating Path
    var animatableData: CGFloat {
        get { return value }
        set { value = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            
            let width = rect.width - 100
            let height = rect.height
            
            path.move(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: 0))
            
            // Curve
            path.move(to: CGPoint(x: width, y: 0))
            path.addCurve(
                to: CGPoint(x: width, y: height + 100),
                control1: CGPoint(x: width + value, y: height / 3),
                control2: CGPoint(x: width - value, y: height / 2))

        }
    }
}
