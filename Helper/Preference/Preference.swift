//
//  Preference.swift
//  cycle
//
//  Created by Azmi Muhammad on 23/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import Foundation

enum PreferenceKey: String {
    case kSkipOnBoarding
    case kUserLogin
    case kUserName
    case kUserEmail
    case kUserAddress
    case kUserDOB
}

struct Preference {
    
    static func set(value: Any?, forKey key: PreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getString(forKey key: PreferenceKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    static func getInt(forKey key: PreferenceKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    static func getBool(forKey key: PreferenceKey) -> Bool? {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func hasSkippedIntro() -> Bool {
        return getBool(forKey: .kSkipOnBoarding) ?? false
    }
    
    static func hasLoggedIn() -> Bool {
        return getBool(forKey: .kUserLogin) ?? false
    }
}
