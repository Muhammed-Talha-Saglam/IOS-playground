//
//  Message.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 10.07.2022.
//

import Foundation

struct Message: Identifiable {
    var id: String = UUID().uuidString
    var message: String
    var isReply: Bool = false
    var emojiValue: String = ""
    var isEmojiAdded: Bool = false
}
