//
//  Video.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import Foundation

struct Video: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
}

var videos = [
    Video(image: "thumb1", title: "Advanced Map Kit Tutorials"),
    Video(image: "thumb2", title: "Realm DB Crud Operations"),
    Video(image: "thumb3", title: "SwiftUI Complex Chat App UI"),
    Video(image: "thumb4", title: "Animated Sticky Header"),
    Video(image: "thumb5", title: "Shared App for Both MacOS And IOS")
]
