//
//  AppStorageCodable.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 11.11.2022.
//

// This is an example of how to use any Data class in AppStorage.

import SwiftUI


typealias PinnedRecipes = [UUID]
extension PinnedRecipes: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(PinnedRecipes.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct SampleView: View {
    @AppStorage("pinnedRecipes") var pinnedRecipes = PinnedRecipes()
    
    var body: some View {
        List {
            Section(header: Text("Pinned Recipes")) {
                ForEach(pinnedRecipes, id: \.self) { id in
                    Text("\(id)")
                }
            }
        }
    }
}
