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
    var detailData = Document()
    
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.title = detailData.placeName
        self.view = searchDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTarget()
        configureLocation()
        addCurrentLocationMarker()
        addDestinationMarker()
        setViewData()
    }
    
    func configureTarget() {
        searchDetailView.myLocationBtn.addTarget(self,
                                                 action: #selector(didTabMyLocationBtn(_:)),
                                                 for: .touchUpInside)
        searchDetailView.destinationBtn.addTarget(self,
                                                 action: #selector(didTabDestinationBtn(_:)),
                                                 for: .touchUpInside)
        searchDetailView.linkBtn.addTarget(self,
                                           action: #selector(didTabLinkBtn(_:)),
                                           for: .touchUpInside)
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

    func setViewData() {
        searchDetailView.titleLabel.text = detailData.placeName
        searchDetailView.locationLabel.text = detailData.roadAddressName
        searchDetailView.distanceLabel.text = "현재 위치에서의 거리 \(detailData.distance)m"
        searchDetailView.telLabel.text = detailData.phone
    }
}

//MARK: - Action 관련
extension SearchDetailViewController {
    @objc func didTabMyLocationBtn(_ sender: Any) {
        print("내 위치로 버튼 클릭")
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }

    @objc func didTabDestinationBtn(_ sender: Any) {
        print("목적지로 버튼 클릭")
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Double(detailData.y) ?? 0,
            longitude: Double(detailData.x) ?? 0
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }

    @objc func didTabLinkBtn(_ sender: Any) {
        print("카카오맵 버튼 클릭")
        guard let url = NSURL(string: detailData.placeURL) else { return }
        let urlView: SFSafariViewController = SFSafariViewController(url: url as URL)
        self.present(urlView, animated: true, completion: nil)
    }
}
