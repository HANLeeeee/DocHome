//
//  SearchAPI.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation
import Alamofire


class API {
    static let shared: API = {
            return API()
    }()
//case searchKeyword(keyword: String)
//case searchCategory(x: String, y: String)
    func searchKeyword(keyword: String, x: String, y: String, completion: @escaping (Result<KeywordResponse, AFError>) -> Void) {
        AF.request(APIManager.searchKeyword(keyword: keyword, x: x, y: y))
            .validate()
            .responseDecodable(of: KeywordResponse.self) { response in
                debugPrint(response)
            switch response.result {
            case .success(let result):
                completion(.success(result))
                
            case .failure(let error):
                print("리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}
