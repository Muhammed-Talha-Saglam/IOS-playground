//
//  AnimatedNumberText.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 14.07.2022.
//

import SwiftUI

struct AnimatedNumberText: Animatable, View{
    
    var value: CGFloat

    var animatableData: CGFloat{
        get{value}
        set{
            value = newValue
        }
    }
    
    var body: some View{
        Text("\(value)")
    }
}
