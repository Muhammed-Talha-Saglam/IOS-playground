//
//  CustomCorner.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.12.2022.
//

import SwiftUI

struct CustomCorner: Shape{
    var corners: UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
