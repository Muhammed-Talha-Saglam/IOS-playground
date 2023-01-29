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
    
    //Mark: Previous, current offset to find the direction of swipe
    @ViewBuilder
    func offsetY(completion: @escaping (CGFloat, CGFloat)->()) -> some View {
        self
            .modifier(OffsetHelper(onChange: completion))
    }
    
}

// Mark: Offset Helper. https://www.youtube.com/watch?v=heVnQvJbd4I
struct OffsetHelper: ViewModifier {
    var onChange: (CGFloat, CGFloat) -> ()
    
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .global).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset,currentOffset)
                        }
                }
            }
    }
}

//// Mark: Offset key
//struct OffsetKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
