//
//  DraggableBottomSheetView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.07.2022.
//

import SwiftUI

// IOS 16+
extension View{
    
    @ViewBuilder
    func bottomSheet<Content: View>(
//        presentationDetents: Set<UISheetPresentationController.Detent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = false,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> ()
    ) -> some View {
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                content()
//                    .presentationDetents(presentationDetents)
//                    .presentationDragIndicator(dragIndicator)
                    .interactiveDismissDisabled(interactiveDisabled)
                    .onAppear {
                        guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        if let controller = windows.windows.first?.rootViewController?.presentedViewController,
                           let sheet = controller.presentationController as? UISheetPresentationController
                         {
                            
                            if isTransparentBG{
                                controller.view.backgroundColor = .clear
                            }
                    
                            controller.presentingViewController?.view.tintAdjustmentMode = .normal
                            
                            sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                            sheet.preferredCornerRadius = sheetCornerRadius
                            
                        } else {
                            print("NO CONTROLLER FOUND")
                        }
                    }
            }

    }
}
