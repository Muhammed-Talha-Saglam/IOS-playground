//
//  ResponsiveView2.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.12.2022.
//

import SwiftUI

struct ResponsiveView2<Content: View>: View {

    var content: (Properties2) -> Content
    
    init(@ViewBuilder content: @escaping (Properties2) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isLandScape = (size.width > size.height)
            let isiPad = UIDevice.current.userInterfaceIdiom == .pad
            let isMaxSplit = isSplit() && size.width < 400
            // hide side bar completely in vertical
            // show side bar for 0.75 fraction in horizontal
            let isAdoptable = isiPad && (isLandScape ? !isMaxSplit : !isSplit())
            
            let properties = Properties2(isLandscape: isLandScape, isiPad: isiPad, isSplit: isSplit(), isMaxSplit: isMaxSplit, isAdoptable: isAdoptable, size: size)
            
            content(properties)
                .frame(width: size.width, height: size.height)
        }
        
    }
    
    func isSplit() -> Bool{
        // Easy way to find
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
        return screen.windows.first?.frame.size != UIScreen.main.bounds.size
    }
    
}



struct Properties2 {
    var isLandscape: Bool
    var isiPad: Bool
    var isSplit: Bool
    var isMaxSplit: Bool
    var isAdoptable: Bool
    var size: CGSize
}

