//
//  UIViewRepresentableSample.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 28.05.2022.
//

import SwiftUI

// Convert UIView from UIKit to SwiftUI
struct UIViewRepresentableSample: View {
    
    @State private var text: String
    
    var body: some View {
        UITextFieldViewRepresentable(text: $text, placeHolder: "Type Here...", placeHolderColor: .red)
    }
}


struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    @Binding var text: String
    var placeHolder: String
    let placeHolderColor: UIColor
    
    init(text: Binding<String>, placeHolder: String = "Default placeholder...", placeHolderColor: UIColor = .red) {
        self._text = text
        self.placeHolder = placeHolder
        self.placeHolderColor = placeHolderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    // From SwiftUI to UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    private func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeHolder = NSAttributedString(
            string: placeHolder,
            attributes: [.foregroundColor: placeHolderColor])
        
        textField.attributedPlaceholder = placeHolder
        return textField
    }
    
    func updatePlaceHolder(_ text: String) -> UITextFieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeHolder = text
        return viewRepresentable
    }
    
    // from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

struct BasicUIViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
            
    }
}
