//
//  UserDefaultsData.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import Foundation

class UserDefaultsData {
    enum Key: String, CaseIterable {
        case latitude, longitude
    }
    
    static let shared: UserDefaultsData = {
            return UserDefaultsData()
    }()
    
    func removeAll() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    func setLocation(latitude: String, longitude: String) {
        UserDefaults.standard.setValue(latitude, forKey: "위도")
        UserDefaults.standard.setValue(longitude, forKey: "경도")
        UserDefaults.standard.synchronize()
    }
    
    func getLocation() -> UserLocation {
        let latitude = UserDefaults.standard.string(forKey: "위도") ?? "0"
        let longitude = UserDefaults.standard.string(forKey: "경도") ?? "0"
        return UserLocation(latitude: latitude, longitude: longitude)
    }
}
