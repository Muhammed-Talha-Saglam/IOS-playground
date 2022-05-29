//
//  YoutubeHomeView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import SwiftUI

struct YoutubeHomeView: View {
    
    @StateObject var player = VideoPlayerViewModel()
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(videos) { video in
                        VideoCardView(video: video)
                            .onTapGesture {
                                withAnimation {
                                    player.showPlayer.toggle()
                                }
                            }
                    }
                }
            }
            
            if player.showPlayer {
                MiniPlayerView()
                    .transition(.move(edge: .bottom))
                    .offset(y: player.offset)
                    .gesture(DragGesture()
                                .updating($gestureOffset, body: { (value, state, _) in
                        state = value.translation.height
                    })
                                .onEnded(onEnd(value:)))
            }
        })
            .onChange(of: gestureOffset) { value in
                onChanged()
            }
            .environmentObject(player)
        
    }
    
    func onChanged()  {
        if gestureOffset > 0 && !player.isMiniPlayer && player.offset + 70 <= player.height {
            player.offset = gestureOffset
        }
    }
    
    func onEnd(value: DragGesture.Value)  {
        withAnimation {
            
            if !player.isMiniPlayer {
                player.offset = 0

                if value.translation.height > UIScreen.main.bounds.height / 3 {
                    player.isMiniPlayer = true
                } else {
                    player.isMiniPlayer = false
                }
            }
        }
    }
}

struct YoutubeHomeView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeHomeView()
    }
}
