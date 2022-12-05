//
//  CustomEnvironmentKey.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 5.12.2022.
//

import SwiftUI

struct SafeAreaValue: EnvironmentKey{
    static var defaultValue: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
}

extension EnvironmentValues{
    var safeArea: EdgeInsets{
        get{
            self[SafeAreaValue.self]
        }
        set{
            self[SafeAreaValue.self] = newValue
        }
    }
}
