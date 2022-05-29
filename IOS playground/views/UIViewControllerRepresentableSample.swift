//
//  UIViewControllerRepresentableSample.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import SwiftUI

struct UIViewControllerRepresentableSample: View {
    
    @State private var showScreen: Bool = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack {
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
            Button {
                showScreen.toggle()
            } label: {
                Text("Click here")
            }
            .sheet(isPresented: $showScreen) {
                UIImagePickerControllerRepresentable(image: $image, showScreen: $showScreen)
//                BasicUIViewControllerRepresentable(labelText: "New label")
            }

        }
    }
}

struct UIViewControllerRepresentableSample_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerRepresentableSample()
    }
}

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var showScreen: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        return vc
    }
        
    // From SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, showScreen: $showScreen)
    }

    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        @Binding private var showScreen: Bool

        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let newImage = info[.originalImage] as? UIImage else {
                return
            }
            image = newImage
            showScreen = false
        }
    }
}

struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {

    let labelText: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MyFirstViewController()
        vc.labelText = labelText
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}


class MyFirstViewController: UIViewController {
    
    var labelText: String = "Starting value"
    
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text = labelText
        label.textColor = .white
        
        view.addSubview(label)
        label.frame = view.frame
    }
}
