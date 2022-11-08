//
//  BoundsPreference.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 10.07.2022.
//

import SwiftUI

struct BoundsPreference: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}

