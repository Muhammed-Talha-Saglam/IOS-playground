//
//  PhotoCacheManager.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 20.05.2022.
//

import Foundation
import UIKit

class PhotoCacheManager {
    
    static let instance = PhotoCacheManager()
    private init() {}
    
    var photoCache: NSCache<NSString, UIImage> = {
        var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 200 // 200 mb
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        return photoCache.object(forKey: key as NSString)
    }
}
