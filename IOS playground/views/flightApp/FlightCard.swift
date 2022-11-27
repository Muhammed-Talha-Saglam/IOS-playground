//
//  FlightCard.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 27.11.2022.
//

import Foundation

struct FlightCard: Identifiable {
    var id: UUID = .init()
    var cardImage: String
    
}

var sampleFlightCards: [FlightCard] = [
    .init(cardImage: "thumb1"),
    .init(cardImage: "thumb2"),
    .init(cardImage: "thumb3"),
    .init(cardImage: "thumb4"),
    .init(cardImage: "thumb5"),
    .init(cardImage: "thumb1"),
    .init(cardImage: "thumb2"),
    .init(cardImage: "thumb3"),
    .init(cardImage: "thumb4"),
    .init(cardImage: "thumb5")
]
