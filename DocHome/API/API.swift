//
//  SearchAPI.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation
import Alamofire


class API {
    
//case searchKeyword(keyword: String)
//case searchCategory(x: String, y: String)
    func searchKeyword(keyword: String) {
        AF.request(APIManager.searchKeyword(keyword: keyword))
            .validate()
            .responseDecodable(of: KeywordResponse.self) { response in
                debugPrint(response)
            switch response.result {
            case .success(let result):
                print(result)
                
            case .failure(let error):
                print("에러에러리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}
