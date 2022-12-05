//
//  AppReviewRequest.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 5.12.2022.
//

import SwiftUI

enum AppReviewRequest{
    static let treshold = 3
    @AppStorage("runsSinceLastRequest") static var runsSinceLastRequest = 0
    @AppStorage("storedVersion") static var storedVersion = ""
    
    static func appUrl(id: String) -> URL? {
        guard let writeReviewURL = URL(string: "http://apps.apple.com/app/id\(id)?action=write-review") else {
            return nil
        }
        
        return writeReviewURL
    }
    
    static var showReviewButton: Bool{
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return appVersion == storedVersion
    }

    static var requestView: Bool {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        runsSinceLastRequest += 1
        
        guard storedVersion !=  appVersion else{
            runsSinceLastRequest = 0
            return false
        }
        
        if runsSinceLastRequest >= treshold{
            storedVersion = appVersion
            runsSinceLastRequest = 0
            return true
        }
        
        return false
    }
}
