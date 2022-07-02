//
//  AccessSwiftUIValueFromUIKit.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 28.06.2022.
//

import SwiftUI

import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController, ObservableObject {

    @Published var rating: Int? = 3
    var cancellable: AnyCancellable?

    
    lazy var ratingLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
        
    }()
    
    private struct HolderView: View {
        
        @ObservedObject var vc: ViewController
        
        var body: some View {
            RatingView(rating: $vc.rating)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let hostingController = UIHostingController(rootView: HolderView(vc: self))
        
        guard let ratingView = hostingController.view else { return }
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(hostingController)
        
        self.view.addSubview(ratingView)
        
        self.cancellable = $rating.sink { [weak self] rating in
            if let rating = rating {
                self?.ratingLabel.text = "\(rating)"
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: [ratingLabel, ratingView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
              
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

}

struct RatingView: View {
    
    @Binding var rating: Int?
    
    private func starType(index: Int) -> String {
        
        if let rating = self.rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
        
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundColor(Color.orange)
                    .onTapGesture {
                        self.rating = index
                }
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
