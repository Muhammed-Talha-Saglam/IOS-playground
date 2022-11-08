//
//  Coffee.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 8.11.2022.
//

import SwiftUI

struct Coffee: Identifiable {
    var id: UUID = .init()
    var imageName: String
    var title: String
    var price: String
}

var coffees: [Coffee] = [
    .init(imageName: "coffee1", title: "Caramel\nCold Drink", price: "$3.90"),
    .init(imageName: "coffee1", title: "Caramel\nMacchiato", price: "$2.30"),
    .init(imageName: "coffee1", title: "Iced Coffee\nMocha", price: "$9.20"),
    .init(imageName: "coffee1", title: "Toffee Nut\nCrunh Latte", price: "$12.30"),
    .init(imageName: "coffee1", title: "Styled Cold\nCoffee", price: "$8.90"),
    .init(imageName: "coffee1", title: "Classic Irish\nCoffee", price: "$6.10"),
    .init(imageName: "coffee1", title: "Black Tea\nLatte", price: "$2.20"),
    .init(imageName: "coffee1", title: "Iced Coffee\nMocha", price: "$5.90")
]
