//
//  UserDefaults+Extensions.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 5.06.2022.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
}


extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
        case switchIsOn
        case signedInUser
    }
    
    var switchIsOn: Bool {
        get {
            bool(forKey: UserDefaultsKeys.switchIsOn.rawValue)
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.switchIsOn.rawValue)
        }
    }
    
    var isSignedInUser: User? {
        get {
            if let data = object(forKey: UserDefaultsKeys.signedInUser.rawValue) as? Data {
                let user = try? JSONDecoder().decode(User.self, from: data)
                return user
            } else {
                return nil
            }
        }
        
        set {
            if newValue == nil {
                removeObject(forKey: UserDefaultsKeys.signedInUser.rawValue)
            } else {
                let data = try? JSONEncoder().encode(newValue)
                setValue(data, forKey: UserDefaultsKeys.signedInUser.rawValue)
            }
        }
    }
    
    
}
