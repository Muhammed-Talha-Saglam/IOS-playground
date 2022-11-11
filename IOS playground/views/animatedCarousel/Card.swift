//
//  Card.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.11.2022.
//

import Foundation

struct Card: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var imageFile: String
}
