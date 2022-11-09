//
//  WalletAppView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 9.11.2022.
//

import SwiftUI

struct WalletAppView: View {
    var body: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            CardView()
                .padding(.top, 10)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color.black
                .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
    }
    
    
    // MARK: Card View
    @ViewBuilder
    func CardView(cardColor: Color = .white) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Image("Mastercard_Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
            
            HStack(spacing: 4) {
                Text("$")
                    .font(.title.bold())
            
                // MARK: Rolling Text
            }
        
        }
        .foregroundColor(.black)
        .padding(15)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        
    }
    
    // MARK: Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Text("My Cards")
                .font(.title.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.black)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white)
                    }

            }

        }
    }
}

struct WalletAppView_Previews: PreviewProvider {
    static var previews: some View {
        WalletAppView()
    }
}
