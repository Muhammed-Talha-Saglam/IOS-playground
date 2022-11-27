//
//  FlightAppView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 27.11.2022.
//

import SwiftUI

struct FlightAppContentView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets
            FlightAppHomeView(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}

struct FlightAppView_Previews: PreviewProvider {
    static var previews: some View {
        FlightAppContentView()
    }
}
