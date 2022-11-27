//
//  FlightAppHomeView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 27.11.2022.
//

import SwiftUI

struct FlightAppHomeView: View {
    // MARK: View Bound
    var size: CGSize
    var safeArea: EdgeInsets
    // Gesture Properties
    @State var offsetY: CGFloat = 0
    @State var currentCardIndex: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 5)
                            )
                    }
                    .offset(x: -15, y: 15)

                })
                .zIndex(1)
            PaymentCardsView()
                .zIndex(0)
        }
    }
    
    // MARK: Top Header View
    @ViewBuilder
    func HeaderView()->some View{
        VStack {
            Image("Mastercard_Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4, height: 40)
                .frame(maxWidth: .infinity, alignment: .leading)
        
            HStack {
                FlightDetailsView(place: "Los Angeles", code: "LAS", timing: "23 Nov, 03.30")

                VStack(spacing: 8) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    
                    Text("4h 15m")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
                FlightDetailsView(alignment: .trailing,place: "New York", code: "NYC", timing: "23 Nov, 07.15")
            }
            .padding(.top, 20)
            
            Image("airplane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                .padding(.bottom, -20)
        }
        .padding([.horizontal, .top],15)
        .padding(.top, safeArea.top)
        .background {
            Rectangle()
                .fill(LinearGradient(colors: [.blue, .blue, .blue.opacity(0.6)], startPoint: .top, endPoint: .bottom))
        }
    }
    
    // MARK: Credit Cards View
    @ViewBuilder
    func PaymentCardsView()->some View{
        VStack {
            Text("Select Payment Method")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
        
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ForEach(sampleFlightCards.indices,id: \.self) { index in
                        CardView(index: index)
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200.0)
                
                // MARK: Gradient View
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.8),
                        .white,
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false)
                
                // MARK: Purchase Button
                Button {
                    
                } label: {
                    Text("Confirm $1,536.00")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.blue.gradient)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)

            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    // Decreasing speed
                    offsetY = value.translation.height * 0.3
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    
                    withAnimation(.easeInOut){
                        // MARK: Increasing/Decreasing Index based on Condition
                        // 100 -> since card height = 200
                        if translation > 0 && translation > 100 && currentCardIndex > 0 {
                            currentCardIndex -= 1
                        }
                        if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleFlightCards.count-1){
                            currentCardIndex += 1
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .background{
            Color.white
                .ignoresSafeArea()
        }
    }
    
    // MARK: Card View
    @ViewBuilder
    func CardView(index: Int)->some View{
        GeometryReader { proxy in
            let size = proxy.size
            let miny = proxy.frame(in: .named("SCROLL")).minY
            let progress = miny / size.height
            let constraintProgress =  progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleFlightCards[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
            // Shadow
                .shadow(color: .black.opacity(0.14), radius: 8, x: 6, y: 6)
                .rotation3DEffect(.degrees(constraintProgress * 40.0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
            // Stacked Card Animation
                .padding(.top, progress * -160.0)
            // Moving current card to the top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleFlightCards.count - index))
        .onTapGesture {
            
        }
    }
    
}

struct FlightAppHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FlightAppContentView()
    }
}

struct FlightDetailsView: View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    var body: some View{
        VStack(alignment: alignment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        
            
        }
        .frame(maxWidth: .infinity)

    }
}

// MARK: Detail View UI
struct FlightDetailView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image("")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    Text("Your order has been submitted.")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    Text("We are waiting for booking confirmation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.bottom, 40)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.white.opacity(0.1))
                )
                
                HStack {
                    FlightDetailsView(place: "Los Angeles", code: "LAS", timing: "23 Nov, 03.30")
                    
                    VStack(spacing: 8) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                        
                        Text("4h 15m")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    FlightDetailsView(alignment: .trailing,place: "New York", code: "NYC", timing: "23 Nov, 07.15")
                }
                .padding(15)
                .padding(.bottom, 70)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .padding(.top, -20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, safeArea.bottom + 15)
            .padding([.horizontal, .bottom], 15)
            .background(
                Rectangle()
                    .fill(.blue)
                    .padding(.bottom,80)
            )
            // MARK: Contact information view
            GeometryReader { proxy in
                // Responsive UI For smaller devices
                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical, showsIndicators: false) {
                        ContactInformation()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func ContactInformation()->some View{
        VStack(spacing: 15) {
            HStack{
                InfoView(title: "Flight", subtitle: "AR 580")
                InfoView(title: "Class", subtitle: "Premium")
                InfoView(title: "Aircraft", subtitle: "B 737-900")
                InfoView(title: "Possibility", subtitle: "AR 580")

            }
            
            ContactView(name: "iJustine", email: "justine@apple.com", profile: "talha")
                .padding(.top, 30)

            ContactView(name: "Jenna", email: "jenna@apple.com", profile: "talha")
                .padding(.top, 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Price")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("$1,536.00")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 15)
            
            // MARK: Home screen button
            Button {
                
            } label: {
                Text("Go to home screen")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(.blue.gradient)
                    )
            }
            .padding(.top,15)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
        }
        .padding(15)
        .padding(.top,20)
    }
    
    // MARK: Contact View
    @ViewBuilder
    func ContactView(name: String, email: String, profile: String)->some View{
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(email)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profile)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
        .padding(.horizontal, 15)
    }
    
    // MARK: Info View
    @ViewBuilder
    func InfoView(title: String, subtitle: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)

            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.black)

        }
        .frame(maxWidth: .infinity)
    }
}
 
