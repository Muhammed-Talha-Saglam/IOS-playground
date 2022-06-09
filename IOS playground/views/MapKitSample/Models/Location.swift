//
//  Location.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 8.06.2022.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable {
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String    
    
    var id: String {
        name + cityName
    }

    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

}
