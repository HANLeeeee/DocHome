//
//  Bundle+Extension.swift
//  DocHome
//
//  Created by 최하늘 on 12/12/23.
//

import Foundation

extension Bundle {
    var kakaoAuthKey: String {
        guard let file = self.path(forResource: "KakaoAPIKey", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["KAKAO_AUTH_KEY"] as? String else {
            fatalError("KEY를 찾을수없음")
        }
        return key
    }
}
