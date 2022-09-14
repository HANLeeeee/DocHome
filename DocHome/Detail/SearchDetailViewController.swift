//
//  SeachDetailViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import UIKit
import SafariServices

class SearchDetailViewController: UIViewController, MTMapViewDelegate {
    
    //MARK: - 프로퍼티
    let userLocation = UserDefaultsData.shared.getLocation()
    let searchDetailView = SearchDetailView()
    var detailData = Document()
    
    var mapPoint: MTMapPoint?
    var poiItem: MTMapPOIItem?
    
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
        addMarker()
        setViewData()
    }
    
    func configureTarget() {
        searchDetailView.linkBtn.addTarget(self,
                      action: #selector(didTabLinkBtn(_:)),
                      for: .touchUpInside)
    }
    
    func configureLocation() {
        searchDetailView.mapLocationView.delegate = self
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Double(detailData.y)!,
            longitude: Double(detailData.x)!
        )), zoomLevel: MTMapZoomLevel(0.1), animated: true)
    }
    
    func addMarker() {
        mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(detailData.y)!, longitude: Double(detailData.x)!))
        poiItem = MTMapPOIItem()
        poiItem?.markerType = MTMapPOIItemMarkerType.redPin
        poiItem?.mapPoint = mapPoint
        poiItem?.itemName = detailData.placeName
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
    @objc func didTabLinkBtn(_ sender: Any) {
        print("검색 버튼 클릭")
        let url = NSURL(string: detailData.placeURL)
        let urlView: SFSafariViewController = SFSafariViewController(url: url! as URL)
        self.present(urlView, animated: true, completion: nil)
    }
}
