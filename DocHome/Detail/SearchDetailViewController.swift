//
//  SeachDetailViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import UIKit
import SafariServices
import CoreLocation

final class SearchDetailViewController: UIViewController, MTMapViewDelegate {
    
    private let userLocation = UserDefaultsData.shared.getLocation()
    private let searchDetailView = SearchDetailView()
    
    private let index: Int
    private var detailData: Document
    
    init(detailData: Document, index: Int) {
        self.detailData = detailData
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
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
    
    private func setupButtons() {
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

    private func configureLocation() {
        searchDetailView.mapLocationView.delegate = self
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Double(detailData.y) ?? 0,
            longitude: Double(detailData.x) ?? 0
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }

    private func addCurrentLocationMarker() {
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: userLocation.latitude, longitude: userLocation.longitude))
        let poiItem = MTMapPOIItem()
        poiItem.markerType = MTMapPOIItemMarkerType.bluePin
        poiItem.mapPoint = mapPoint
        poiItem.itemName = "현재 위치"
        searchDetailView.mapLocationView.add(poiItem)
    }
    
    private func addDestinationMarker() {
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(detailData.y) ?? 0, longitude: Double(detailData.x) ?? 0))
        let poiItem = MTMapPOIItem()
        poiItem.markerType = MTMapPOIItemMarkerType.redPin
        poiItem.mapPoint = mapPoint
        poiItem.itemName = detailData.placeName
        searchDetailView.mapLocationView.add(poiItem)
    }

    private func setupViewData() {
        searchDetailView.setupLabelText(title: detailData.placeName, category: detailData.categoryName, location: detailData.roadAddressName, distance: "\(detailData.distance)m", tel: detailData.phone)
    }
    
    private func updateFavoriteButton() {
        searchDetailView.favoriteButton.isSelected = favoriteSearchResultDatas.contains(where: { $0.id == detailData.id })
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
        urlView.modalPresentationStyle = .formSheet
        self.present(urlView, animated: true, completion: nil)
    }
}

//MARK: - FavoriteButtonDelegate
extension SearchDetailViewController: FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool) {
        if isSelect {
            detailData.isFavorite = true
            favoriteSearchResultDatas.insert(detailData, at: index)
        } else {
            favoriteSearchResultDatas.remove(at: index)
        }
    }
}
