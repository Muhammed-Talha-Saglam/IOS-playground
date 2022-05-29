//
//  MatchedGeometryEffectView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 21.05.2022.
//

import SwiftUI

struct MatchedGeometryEffectView: View {
    
    @State private var isClicked: Bool = false
    @Namespace private var namespace
    
    var body: some View {

        VStack {
            if !isClicked {
                RoundedRectangle(cornerRadius: 25.0)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 100, height: 100)

            }
            
            Spacer()

            if isClicked {
                RoundedRectangle(cornerRadius: 25.0)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 200, height: 200)

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isClicked.toggle()
            }
        }
    }
}


struct MatchedGeometryEffectView2: View {
    
    let categories: [String] = ["Home", "Popular", "Saved"]
    @State private var selected: String = "Home"
    @Namespace private var namespace2
    
    var body: some View {
        HStack {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    if selected == category {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.5))
                            .matchedGeometryEffect(id: "category_bg", in: namespace2)
                    }
                    
                    Text(category)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selected = category
                    }
                }
            }
        }
        .padding()
    }
    
}
    


struct MatchedGeometryEffectView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryEffectView2()
    }
}

