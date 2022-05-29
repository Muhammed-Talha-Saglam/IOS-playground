//
//  CustomShapesView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 22.05.2022.
//

import SwiftUI

struct CustomShapesView: View {
    var body: some View {
        ZStack {
            
            Triangle()
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10]))
                .foregroundColor(.blue)
//                .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .bottom))
                .frame(width: 300, height: 300)
        }
    }
}

struct CustomShapesView_Previews: PreviewProvider {
    static var previews: some View {
        CustomShapesView()
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            
        }
    }
    
        
}
