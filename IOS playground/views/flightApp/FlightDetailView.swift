//
//  FlightDetailView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 27.11.2022.
//

import SwiftUI

struct FlightDetailView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    @EnvironmentObject var animator: Animator
    
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
            .offset(y: animator.showFinalView ? 0 : 300)
            .background(
                Rectangle()
                    .fill(.blue)
                    .scaleEffect(y: animator.showFinalView ? 1 : 0.001, anchor: .top)
                    .padding(.bottom,80)
            )
            .clipped()
            
            // MARK: Contact information view
            GeometryReader { proxy in
                // Responsive UI For smaller devices
                ViewThatFits {
                    ContactInformation()
                    ScrollView(.vertical, showsIndicators: false) {
                        ContactInformation()
                    }
                }
                .offset(y: animator.showFinalView ? 0 : size.height)
            }
        }
        .animation(.easeInOut(duration: animator.showFinalView ? 0.7 : 0.3).delay(animator.showFinalView ? 0.7 : 0), value: animator.showFinalView)
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
            Button(action: resetAnimationAndView){
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
    
    /// Reseting  animation
    func resetAnimationAndView(){
        animator.currentPaymentStatus = .started
        animator.showClouds = false
        withAnimation(.easeInOut(duration: 0.3)){
            animator.showFinalView = false
        }
        
        animator.ringAnimation = [false, false]
        animator.showLoadingView = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            withAnimation(.easeInOut){
                animator.startAnimation = false
            }
        }
    }

}

