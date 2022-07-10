//
//  ChatView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 10.07.2022.
//

import SwiftUI

struct ChatView: View {
    @State var chat: [Message] = [
        Message(message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
        Message(message: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.", isReply: true)
    ]
    @State var showHighlight: Bool = false
    @State var highlightChat: Message?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12.0) {
                    ForEach(chat) { chat in
                        VStack(alignment: chat.isReply ? .leading : .trailing){
                            
                            if chat.isEmojiAdded{
                                AnimatedEmoji(emoji: chat.emojiValue, color: chat.isReply ? .blue : Color.gray )
                                    .offset(x: chat.isReply ? -15 : 15)
                                    .padding(.bottom, -25)
                                    .zIndex(1)
                                    .opacity(showHighlight ? 0 : 1)
                            }
                            
                            ChatView(message: chat)
                                .zIndex(0)
                                .anchorPreference(key: BoundsPreference.self, value: .bounds) { anchor in
                                    return [chat.id: anchor]
                                }
                            
                        }
                        .padding(chat.isReply ? .leading : .trailing, 60)
                        .onLongPressGesture {
                            withAnimation(.easeInOut) {
                                showHighlight = true
                                highlightChat = chat
                                }
                            }

                    }
                }
                .padding()
            }
            .navigationTitle("Transitions")
        }
        .overlay(content: {
            if showHighlight {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showHighlight = false
                            highlightChat = nil
                        }
                    }
            
            }
        })
        .overlayPreferenceValue(BoundsPreference.self) { values in
            if let highlightChat = highlightChat, let preference = values.first(where: { item in
                item.key == highlightChat.id
            }) {
                GeometryReader{proxy in
                    let rect = proxy[preference.value]
                    ChatView(message: highlightChat, showLike: true)
                        .frame(width: rect.width, height: rect.height)
                        .id(highlightChat.id)
                        .frame(width: rect.width, height: rect.height)
                        .offset(x: rect.minX, y: rect.minY)
                }
                .transition(.asymmetric(insertion: .identity, removal: .offset(x: 1)))
            }
        }
    }
    
    @ViewBuilder
    func ChatView(message: Message, showLike: Bool = false) -> some View {
        ZStack(alignment: .bottomLeading) {
            Text(message.message)
                .padding(15)
                .background(message.isReply ? Color.gray: Color.blue)
                .foregroundColor(message.isReply ? Color.black: Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        
            if showLike{
                EmojiView(hideView: $showHighlight, chat: message) { emoji in
                    
                    withAnimation(.easeInOut) {
                        showHighlight = false
                        highlightChat = nil
                    }
                    
                    if let index = chat.firstIndex(where: {chat in
                        chat.id == message.id
                    }) {
                        withAnimation(.easeInOut.delay(0.3)) {
                            chat[index].isEmojiAdded = true
                            chat[index].emojiValue = emoji
                        }
                    }
                }
                .offset(y: 55)
            }
        }
    }
}


struct AnimatedEmoji: View {
    var emoji: String
    var color: Color = .blue
    @State var animationValues: [Bool] = Array(repeating: false, count: 6)
    
    var body: some View{
        ZStack{
            Text(emoji)
                .font(.system(size: 25))
                .padding(6)
                .background {
                    Circle()
                        .fill(color)
                }
                .scaleEffect(animationValues[2] ? 1 : 0)
                .overlay {
                    Circle()
                        .stroke(color, lineWidth: animationValues[1] ? 0 : 100)
                        .clipShape(Circle())
                        .scaleEffect(animationValues[0] ? 1.6 : 0.01)
                }
                .overlay {
                    ZStack {
                        ForEach(1...20, id: \.self){index in
                            Circle()
                                .fill(color)
                                .frame(width: .random(in: 3...5), height: .random(in: 3...5))
                                .offset(x: .random(in: -5...5), y: .random(in: -5...5))
                                .offset(x:animationValues[0] ? 45 : 10)
                                .rotationEffect(.init(degrees: Double(index) * 18.0))
                                .scaleEffect(animationValues[2] ? 1 : 0.01)
                                .opacity(animationValues[4] ? 0 : 1)
                        }
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    animationValues[0] = true
                }
                withAnimation(.easeInOut(duration: 0.45).delay(0.06)) {
                    animationValues[1] = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.3)) {
                    animationValues[2] = true
                }
                withAnimation(.easeInOut(duration: 0.35).delay(0.4)) {
                    animationValues[3] = true
                }
                withAnimation(.easeInOut(duration: 0.55).delay(0.55)) {
                    animationValues[4] = true
                }
            }
        }
    }
}

struct EmojiView: View {
    @Binding var hideView: Bool
    var chat: Message
    var onTap: (String) -> ()
    var emojis: [String] = ["😁", "❤️", "🥲"]
    @State var animateEmoji: [Bool] = Array(repeating: false, count: 3)
    @State var animateView: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(emojis.indices, id: \.self){index in
                Text(emojis[index])
                    .font(.system(size: 25))
                    .scaleEffect(animateEmoji[index] ? 1 : 0.01)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut.delay(Double(index)*0.1)) {
                                animateEmoji[index] = true
                            }
                        }
                    }
                    .onTapGesture {
                        onTap(emojis[index])
                    }
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.white)
                .mask {
                    Capsule()
                        .scaleEffect(animateView ? 1 : 0, anchor: .leading)
                }
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                animateView = true
            }
        }
        .onChange(of: hideView) { newValue in
            if !newValue {
                withAnimation(.easeInOut(duration: 0.2).delay(0.15)) {
                    animateView = false
                }
                
                for index in emojis.indices{
                    withAnimation(.easeInOut) {
                        animateEmoji[index] = false
                    }
                }
                
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
