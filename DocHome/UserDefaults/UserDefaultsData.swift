//
//  UserDefaultsData.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import Foundation

final class UserDefaultsData {
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
        UserDefaults.standard.setValue(latitude, forKey: Key.latitude.rawValue)
        UserDefaults.standard.setValue(longitude, forKey: Key.longitude.rawValue)
    }
    
    func getLocation() -> CurrentLocation {
        let latitude = UserDefaults.standard.double(forKey: Key.latitude.rawValue)
        let longitude = UserDefaults.standard.double(forKey: Key.longitude.rawValue)
        return CurrentLocation(latitude: latitude, longitude: longitude)
    }
}
