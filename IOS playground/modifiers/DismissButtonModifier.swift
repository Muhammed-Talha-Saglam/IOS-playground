//
//  DismissButtonModifier.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 8.11.2022.
//

import Foundation
import SwiftUI

struct DismissButtonModifier : ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    var withScroll: Bool
    func body(content: Content) -> some View {
        let view = ZStack {
            Color.clear
                .overlay(alignment: .topTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .imageScale(.large)
                            .padding()
                    }
                }
            content
        }
        if withScroll {
            ScrollView {
                view
            }
        } else {
            view
        }
        
    }
}

extension View {
    func withDismissButton(withScroll: Bool = false) -> some View {
        self.modifier(DismissButtonModifier(withScroll: withScroll))
    }
}
