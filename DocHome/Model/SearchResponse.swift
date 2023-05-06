//
//  SearchResponse.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//
import Foundation

struct SearchResponse: Codable {
    let documents: [Document]
    let meta: Meta
}

struct Document: Codable {
    var addressName: String = ""
    var categoryGroupCode: String = ""
    var categoryGroupName: String = ""
    var categoryName: String = ""
    var distance: String = ""
    var id: String = ""
    var phone: String = ""
    var placeName: String = ""
    var placeURL: String = ""
    var roadAddressName: String = ""
    var x: String = ""
    var y: String = ""
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}

struct Meta: Codable {
    var isEnd: Bool
    let pageableCount: Int
    let sameName: SameName?
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case sameName = "same_name"
        case totalCount = "total_count"
    }
}

struct SameName: Codable {
    let keyword: String?
    let region: [String?]
    let selectedRegion: String?

    enum CodingKeys: String, CodingKey {
        case keyword, region
        case selectedRegion = "selected_region"
    }
}

var favoriteSearchResultDatas = [Document]()

