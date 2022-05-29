//
//  VideoPlayerView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()

        let bundle_url =  Bundle.main.path(forResource: "video", ofType: "mp4")
        let video_url = URL(fileURLWithPath: bundle_url!)
        
        let player = AVPlayer(url: video_url)
        
        controller.player = player
        controller.showsPlaybackControls = false
        controller.player?.play()
        controller.videoGravity = .resizeAspectFill
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

