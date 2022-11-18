//
//  Font+Extention.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 18.11.2022.
//

import SwiftUI

extension Font {
    static func custom(_ font: CustomFont, size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(font.rawValue, size: size)
    }
}
