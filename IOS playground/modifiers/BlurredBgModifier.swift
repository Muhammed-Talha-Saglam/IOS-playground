//
//  BlurredBgModifier.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 15.12.2022.
//

import SwiftUI

extension View {
    // MARK: Custom View Modifier
    func blurredSheet<Content: View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping ()->(), @ViewBuilder content: @escaping ()->Content) -> some View {
        
        self
            .sheet(isPresented: show, onDismiss: onDismiss) {
                content()
                    .background(RemoveBackgroundColor())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Rectangle()
                            .fill(style)
                            .ignoresSafeArea(.container, edges: .all)
                    }
            }
    }
}


fileprivate struct RemoveBackgroundColor: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
