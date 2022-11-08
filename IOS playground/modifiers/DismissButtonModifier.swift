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
    
    func body(content: Content) -> some View {
        ZStack {
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
    }
}

extension View {
    func withDismissButton() -> some View {
        self.modifier(DismissButtonModifier())
    }
}
