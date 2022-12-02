//
//  StickyHeaderContentView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 2.12.2022.
//

import SwiftUI

struct StickyHeaderContentView: View {
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            
            AnimatedStickyHeaderView(safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }
        .preferredColorScheme(.dark)
    }
}

struct StickyHeaderContentView_Previews: PreviewProvider {
    static var previews: some View {
        StickyHeaderContentView()
    }
}
