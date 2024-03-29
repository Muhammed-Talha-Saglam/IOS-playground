//
//  MiniPlayerView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import SwiftUI

struct MiniPlayerView: View {
    
    @EnvironmentObject var player: VideoPlayerViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                VideoPlayerView()
                    .frame(width: player.isMiniPlayer ? 150 : player.width, height: player.isMiniPlayer ? 70 : getFrame())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                VideoControls()
            )
            
            GeometryReader { reader in
                ScrollView {
                    VStack(spacing: 18) {
                    
                        VStack(alignment: .leading, spacing: 8) {
                            Text("M1 MacBook Unboxing And First Impressions")
                                .font(.callout)
                            
                            Text("1.4M Views")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth:.infinity)
                        
                        HStack {
                            PlayBackVideoButtons(image: "hand.thumbsup", text: "123K")
                            PlayBackVideoButtons(image: "hand.thumbsdown", text: "1K")
                            PlayBackVideoButtons(image: "square.and.arrow.up", text: "Share")
                            PlayBackVideoButtons(image: "square.and.arrow.down", text: "Download")
                            PlayBackVideoButtons(image: "message", text: "Live Chat")
                        }
                        
                        Divider()
                        
                        VStack(spacing: 15) {
                            ForEach(videos) { video in
                                VideoCardView(video: video)
                            }
                        }
                        
                    }
                    .padding()
                }
                .onAppear {
                    player.height = reader.frame(in: .global).height + 250
                }
            }
            .background(Color.white)
            .opacity( player.isMiniPlayer ? 0 : getOpacity())
            .frame(height: player.isMiniPlayer ? 0 : nil)
        }
        .background(
            Color.white
                .ignoresSafeArea(.all, edges: .all)
                .onTapGesture {
                    withAnimation {
                        player.width = UIScreen.main.bounds.width
                        player.isMiniPlayer.toggle()
                    }
                }
        )
    }
    
    func getFrame() -> CGFloat {
        let progress = player.offset / (player.height - 100)
        
        if (1 - progress) <= 1.0 {
            let videoHeight: CGFloat = (1 - progress) * 250
            
            if videoHeight <= 70 {
                
                let percent = videoHeight / 70
                let videoWidth = percent * UIScreen.main.bounds.width
                
                DispatchQueue.main.async {
                    if videoWidth >= 150 {
                        player.width = videoWidth
                    }
                }
                
                return 70
            }
            
            DispatchQueue.main.async {
                player.width = UIScreen.main.bounds.width
            }
            
            return videoHeight
        }
        
        return 250
    }
    
    func getOpacity() -> Double {
        let progress = player.offset / player.height
        
        if progress <= 1 {
            return Double(1 - progress)
        }
        return 1
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeHomeView()
    }
}

struct PlayBackVideoButtons: View {
    
    var image: String
    var text: String
    
    var body: some View {
        Button {
            
        } label: {
            VStack(spacing: 8) {
                
                Image(systemName: image)
                    .font(.title3)
                
                Text(text)
                    .fontWeight(.semibold)
                    .font(.caption)
                
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
        }
    }
}

struct VideoControls: View {
    
    @EnvironmentObject var player: VideoPlayerViewModel
    
    var body: some View {

        HStack(spacing: 15) {
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 150, height: 70)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("M1 MacBook Unboxing And First Impressions")
                    .font(.callout)
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text("Byte Code")
                    .fontWeight(.bold)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
                        
            Button {
            } label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            Button {
                player.showPlayer.toggle()
                player.offset = 0
                player.isMiniPlayer.toggle()                
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .padding(.trailing)
    }
}
