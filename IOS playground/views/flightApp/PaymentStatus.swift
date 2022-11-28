//
//  PaymentStatus.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 27.11.2022.
//

import Foundation

enum PaymentStatus: String, CaseIterable {
    case started = "Connected..."
    case initated = "Secure Payment..."
    case finished = "Purchaed"
    
    var symbolImage: String{
        switch self {
        case .started:
            return "wifi"
        case .initated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
