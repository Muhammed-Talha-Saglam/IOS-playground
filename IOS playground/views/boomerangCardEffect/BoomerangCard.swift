//
//  CardView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 14.11.2022.
//

import SwiftUI

struct BoomerangCard: Identifiable {
    var id: String = UUID().uuidString
    var imageName: String
    var isRotated: Bool = false
    var extraOffset: CGFloat = 0
    var scale: CGFloat = 1
    var zIndex: Double = 0
}

