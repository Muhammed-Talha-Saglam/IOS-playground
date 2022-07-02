//
//  ResponsiveView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 2.07.2022.
//

import SwiftUI


struct ResponsiveViewSample: View {
    
    var body: some View {
        ResponsiveView { prop in
            Text(prop.isLandscape ? "Landscape" : "Portrait")
        }
    }
}

struct ResponsiveView<Content: View>: View {

    var content: (Properties) -> Content
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isLandScape = (size.width > size.height)
            let isiPad = UIDevice.current.userInterfaceIdiom == .pad
        
            
            content(Properties(isLandscape: isLandScape, isiPad: isiPad, isSplit: isSplit(), size: size))
                .frame(width: size.width, height: size.height, alignment: .center)
                .onAppear {
                    updateFraction(fraction: isLandScape && !isSplit() ?  0.3 : 0.5)
                }
                .onChange(of: isSplit(), perform: { newValue in
                    updateFraction(fraction: isLandScape  && !isSplit() ? 0.3 : 0.5)
                })
                .onChange(of: isLandScape) { newValue in
                    updateFraction(fraction: newValue  && !isSplit() ? 0.3 : 0.5)
                }
        }
        
    }
    
    // Solving UI for Split Apps
    func isSplit() -> Bool{
        // Easy way to find
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
        return screen.windows.first?.frame.size != UIScreen.main.bounds.size
    }
    
    func updateFraction(fraction: Double) {
        NotificationCenter.default.post(name: NSNotification.Name("UPDATEFRACTION"), object: nil, userInfo: ["fraction" : fraction])
    }
}



struct Properties {
    var isLandscape: Bool
    var isiPad: Bool
    var isSplit: Bool
    var size: CGSize
}


// MARK: Displaying side bar always like iPad Settings App
extension UISplitViewController{
    open override func viewDidLoad() {
        self.preferredDisplayMode = .twoOverSecondary
        self.preferredSplitBehavior = .displace
        
        // Updating Primary View column Fraction
        self.preferredPrimaryColumnWidthFraction = 0.3
        
        // Updating dynamically with the help of NotificationCenter calls
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notification:)), name: NSNotification.Name("UPDATEFRACTION"), object: nil)
    }
    
    @objc
    func updateView(notification: Notification) {
        if let info = notification.userInfo, let fraction = info["fraction"] as? Double{
            self.preferredPrimaryColumnWidthFraction = fraction
        }
    }
    
}
