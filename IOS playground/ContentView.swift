//
//  ContentView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 3.05.2022.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        WalletAppView()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct PickerTintColorTest: View {
    let colors: [Color] = [.purple, .green, .orange]
    @State private var selectedColor: Color = .green

    var colorList: some View {
            ForEach(colors, id: \.self) { color in
                Text(color.description)
                    .foregroundColor(color)
            }
        }
    
    var body: some View {
        List {
            Picker("Default style", selection: $selectedColor) { colorList }
            // <- doesn't have a tint color at all
            Picker("Menu style", selection: $selectedColor) { colorList }
                .pickerStyle(.menu)
                .foregroundColor(selectedColor)
                    .tint(selectedColor) // <- forcing to .menu style gives picker a tint color BUT it doesn't update
            Button("Action") { } // <- tint as expected, updates as expected
        }
        .tint(selectedColor)
    }
}
