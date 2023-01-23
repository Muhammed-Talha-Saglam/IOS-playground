//
//  CustomPopOver.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 23.01.2023.
//


import Foundation
import SwiftUI


extension View{
    @ViewBuilder
    func iOSPopOver<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection, @ViewBuilder content: ()->Content) -> some View {
        self.background {
            PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
        }
    }
}

struct PopOverController<Content: View>: UIViewControllerRepresentable{
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    
    @State private var alreadyPresented: Bool = false

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
        
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if alreadyPresented{
            if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content>{
                hostingController.rootView = content
                hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
            }
            
            if !isPresented{
                uiViewController.dismiss(animated: true){
                    alreadyPresented = false
                }
            }
        } else {
            if isPresented{
                let controller = CustomHostingView(rootView: content)
                controller.view.backgroundColor = .clear
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
                controller.presentationController?.delegate = context.coordinator
                controller.popoverPresentationController?.sourceView = uiViewController.view
                uiViewController.present(controller, animated: true)
            }
        }
    }
    
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: PopOverController
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return .none
        }
        
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
        
        func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
            DispatchQueue.main.async {
                self.parent.alreadyPresented = true
            }
        }
    }
}

class CustomHostingView<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        preferredContentSize = view.intrinsicContentSize
    }
}
