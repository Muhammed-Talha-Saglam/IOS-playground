//
//  VideoCardView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 29.05.2022.
//

import SwiftUI

struct VideoCardView: View {
    var video: Video
    
    var body: some View {
        VStack(spacing: 10) {
            
            Image(video.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            
            HStack(spacing: 15) {
                
                Image("talha")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6, content: {
                    Text(video.title)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("Byte Code")
                            .fontWeight(.bold)
                        
                        Text(".14K Views.5 days ago")
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                })
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct VideoCardView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeHomeView()
    }
}
