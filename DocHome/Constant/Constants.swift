//
//  constant.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation

struct Constants {
    
    //MARK: - View
    struct View {
        
    }
    
    
    //MARK: - VC
    struct ViewController {
        struct Identifier {
            static let homeVC = "HomeViewController"
            static let mapVC = "MapViewController"
            static let settingVC = "SettingViewController"
            
            static let searchVC = "SearchViewController"
        }
    }
    
    
    //MARK: - TableViewCell
    struct TableView {
        struct Identifier {
            static let searchCell = "SearchTableViewCell"
            static let recommendCell = "RecommendTableViewCell"
            static let categoryCell = "CategoryTableViewCell"
            
            static let searchKeywordCell = "SearchKeywordTableViewCell"
        }
    }
    
    
    //MARK: - APIURL
    struct APIURL {
        struct KakaoAPI {
            static let searchURL = "https://dapi.kakao.com/v2/local/search"
            
            struct category_group_code {
                static let bigMart = "MT1" //대형마트
                static let convenienceStore = "CS2" //편의점
                static let hospital = "HP8" //병원
                static let drugStore = "PM9" //약국
            }
        }
    }
}
