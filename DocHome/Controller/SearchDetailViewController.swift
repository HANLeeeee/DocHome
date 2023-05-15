//
//  SeachDetailViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import UIKit
import SafariServices
import CoreLocation

class SearchDetailViewController: UIViewController, MTMapViewDelegate {
    
    //MARK: - 프로퍼티
    let userLocation = UserDefaultsData.shared.getLocation()
    let searchDetailView = SearchDetailView()
    var index = -1
    var detailData = Document()
    
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.title = detailData.placeName
        self.view = searchDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        configureLocation()
        addCurrentLocationMarker()
        addDestinationMarker()
        setupViewData()
        updateFavoriteButton()
    }
    
    func setupButtons() {
        searchDetailView.myLocationButton.addTarget(self,
                                                 action: #selector(touchUpMyLocationButton(_:)),
                                                 for: .touchUpInside)
        searchDetailView.destinationButton.addTarget(self,
                                                 action: #selector(touchUpDestinationButton(_:)),
                                                 for: .touchUpInside)
        searchDetailView.kakaoMapButton.addTarget(self,
                                           action: #selector(touchUpLinkButton(_:)),
                                           for: .touchUpInside)
        searchDetailView.favoriteButton.favoriteButtonDelegate = self
    }

    func configureLocation() {
        searchDetailView.mapLocationView.delegate = self
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Double(detailData.y) ?? 0,
            longitude: Double(detailData.x) ?? 0
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }

    //현재위치 마커 추가
    func addCurrentLocationMarker() {
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: userLocation.latitude, longitude: userLocation.longitude))
        let poiItem = MTMapPOIItem()
        poiItem.markerType = MTMapPOIItemMarkerType.bluePin
        poiItem.mapPoint = mapPoint
        poiItem.itemName = "현재 위치"
        searchDetailView.mapLocationView.add(poiItem)
    }
    
    //목적지 마커 추가
    func addDestinationMarker() {
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(detailData.y) ?? 0, longitude: Double(detailData.x) ?? 0))
        let poiItem = MTMapPOIItem()
        poiItem.markerType = MTMapPOIItemMarkerType.redPin
        poiItem.mapPoint = mapPoint
        poiItem.itemName = detailData.placeName
        searchDetailView.mapLocationView.add(poiItem)
    }

    func setupViewData() {
        searchDetailView.titleLabel.text = detailData.placeName
        searchDetailView.categoryLabel.text = detailData.categoryName
        searchDetailView.locationLabel.text = detailData.roadAddressName
        searchDetailView.distanceValueLabel.text = "\(detailData.distance)m"
        searchDetailView.telLabel.text = detailData.phone
    }
    
    func updateFavoriteButton() {
        print(index)
        print("원래 \(searchDetailView.favoriteButton.isSelected)")
        if index < 0 { return }
        searchDetailView.favoriteButton.isSelected = favoriteSearchResultDatas.contains(where: { $0.id == detailData.id })
        print("변경후 \(searchDetailView.favoriteButton.isSelected)")
        searchDetailView.favoriteButton.changeFavoriteButtonColor()
    }
}

//MARK: - Action 관련
extension SearchDetailViewController {
    @objc func touchUpMyLocationButton(_ sender: Any) {
        print("내 위치로 버튼 클릭")
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }

    @objc func touchUpDestinationButton(_ sender: Any) {
        print("목적지로 버튼 클릭")
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Double(detailData.y) ?? 0,
            longitude: Double(detailData.x) ?? 0
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }

    @objc func touchUpLinkButton(_ sender: Any) {
        print("카카오맵 버튼 클릭")
        guard let url = NSURL(string: detailData.placeURL) else { return }
        let urlView: SFSafariViewController = SFSafariViewController(url: url as URL)
        self.present(urlView, animated: true, completion: nil)
    }
}


//MARK: - FavoriteButtonDelegate
extension SearchDetailViewController: FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool) {
        if index < 0 { return }
        if isSelect {
            detailData.isFavorite = true
            favoriteSearchResultDatas.insert(detailData, at: index)
        } else {
            favoriteSearchResultDatas.remove(at: index)
        }
    }
}
