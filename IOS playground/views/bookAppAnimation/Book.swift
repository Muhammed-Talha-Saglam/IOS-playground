//
//  Book.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 12.11.2022.
//

import Foundation

struct Book: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var imageName: String
    var author: String
}

var sampleBooks: [Book] = [
    .init(title: "Five Feet Apart", imageName: "thumb1", author: "Racher Lippincott"),
    .init(title: "The Alchemist", imageName: "thumb2", author: "William B.Irvine"),
    .init(title: "Booke Of Happiness", imageName: "thumb3", author: "Anne"),
    .init(title: "Five Feet Apart", imageName: "thumb4", author: "William Lippincott"),
    .init(title: "Living Alone", imageName: "thumb5", author: "Jenna Lippincott"),
]
