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
    
    func searchKeywordAPI(keyword: String, x: String, y: String, completion: @escaping (Result<SearchResponse, AFError>) -> Void) {
        AF.request(APIManager.searchKeyword(keyword: keyword, x: x, y: y))
            .validate()
            .responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
                
            case .failure(let error):
                print("리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
    
    func searchCategoryAPI(x: String, y: String, completion: @escaping (Result<SearchResponse, AFError>) -> Void) {
        AF.request(APIManager.searchCategory(x: x, y: y))
            .validate()
            .responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
                
            case .failure(let error):
                print("리스폰스에러 \(error.localizedDescription)")
            }
        }
    }
}
