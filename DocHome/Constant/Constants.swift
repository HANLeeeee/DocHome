//
//  constant.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/24.
//

import Foundation
import UIKit

struct Constants {
    
    //MARK: - 디바이스
    struct Device {
        static let height = UIScreen.main.bounds.size.height
        static let width = UIScreen.main.bounds.size.width
    }
    
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
            static let searchDetailVC = "SearchDetailViewController"
        }
    }
    
    
    //MARK: - TableViewCell
    struct TableView {
        struct Identifier {
            static let favoriteTableViewCell = "FavoriteTableViewCell"
            static let recommendCell = "RecommendTableViewCell"
            
            
            static let searchKeywordCell = "SearchKeywordTableViewCell"
        }
    }
    
    //MARK: - CollectionViewCell
    struct CollectionView {
        struct Identifier {
            static let favoriteCollectionViewCell = "FavoriteCollectionViewCell"
        }
        
        struct FavoriteCollectionViewCell {
            struct size {
                static var width: Double = 240
                static var height: Double = 100
            }
        }
    }
    
    //MARK: - APIURL
    struct APIURL {
        struct KakaoAPI {
            static let searchURL = "https://dapi.kakao.com"
            
            struct category_group_code {
                static let bigMart = "MT1" //대형마트
                static let convenienceStore = "CS2" //편의점
                static let hospital = "HP8" //병원
                static let drugStore = "PM9" //약국
            }
        }
    }
}
