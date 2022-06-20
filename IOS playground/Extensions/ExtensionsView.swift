//
//  ExtensionsView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 19.06.2022.
//

import Foundation
import SwiftUI

extension View {
        
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
    
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }

    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
}
