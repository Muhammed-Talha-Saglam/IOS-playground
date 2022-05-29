//
//  VideoPlayerViewModel.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import Foundation
import SwiftUI

class VideoPlayerViewModel: ObservableObject {
    
    @Published var showPlayer = false
    
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height: CGFloat = 0
    @Published var isMiniPlayer = false
}
