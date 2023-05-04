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
    
    func setLocation(latitude: Double, longitude: Double) {
        UserDefaults.standard.setValue(latitude, forKey: "latitude")
        UserDefaults.standard.setValue(longitude, forKey: "longitude")
        UserDefaults.standard.synchronize()
    }
    
    func getLocation() -> UserLocation {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        return UserLocation(latitude: latitude, longitude: longitude)
    }
}
