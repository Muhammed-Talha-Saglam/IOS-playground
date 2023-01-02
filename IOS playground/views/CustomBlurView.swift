//
//  CustomBlurView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 2.01.2023.
//

import SwiftUI

struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var onChanged: (UIVisualEffectView)->()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        onChanged(uiView)
    }
    
}

extension UIVisualEffectView{
    
    var backDrop: UIView? {
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    
    var gaussianBlur: NSObject?{
        return backDrop?.value(key: "filter", filter: "gaussianBlur")
    }
    
    var saturation: NSObject?{
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    var gaussianBlurRadius: CGFloat{
        get{
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        }
        set{
            gaussianBlur?.values?["inputRadius"] = newValue
            applyNewEffects()
        }
    }
    
    func applyNewEffects(){
        UIVisualEffectView.animate(withDuration: 0.5) { [self] in
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
        }
    }
    
    var saturationAmount: CGFloat{
        get{
            return saturation?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set{
            saturation?.values?["inputAmount"] = newValue
            applyNewEffects()
        }
    }
}

extension UIView{
    func subView(forClass: AnyClass?) -> UIView?{
        return subviews.first { view in
            type(of: view) == forClass
        }
    }
}

extension NSObject{
    var values: [String: Any]?{
        get{
            return value(forKey: "requestedValues") as? [String: Any]
        }
        set{
            setValue(newValue, forKey: "requestedValues")
        }
    }
    
    func value(key: String, filter: String)->NSObject?{
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            return obj.value(forKeyPath: "filtertype") as? String == filter
        })
    }
}
