//
//  Album.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 2.12.2022.
//

import Foundation

struct Album: Identifiable{
    var id = UUID().uuidString
    var albumName: String
}

var albums: [Album] = [
    Album(albumName: "In Between"),
    Album(albumName: "More"),
    Album(albumName: "Big Jet Plane"),
    Album(albumName: "Empty Floor"),
    Album(albumName: "Black Hole Nights"),
    Album(albumName: "Rain On ME"),
    Album(albumName: "Stuck With U"),
    Album(albumName: "7 Rings"),
    Album(albumName: "Bang Bang"),
    Album(albumName: "In Between"),
    Album(albumName: "More"),
    Album(albumName: "Big Jet Plane"),
    Album(albumName: "Empty Floor"),
    Album(albumName: "Black Hole Nights")
]
