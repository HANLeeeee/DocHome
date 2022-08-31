//
//  SeachDetailViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import UIKit

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
        configureLocation()
    }
    
    func configureLocation() {
        searchDetailView.mapLocationView.delegate = self
        searchDetailView.mapLocationView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(
            latitude: Double(detailData.y)!,
            longitude: Double(detailData.x)!
        )), zoomLevel: 1, animated: true)
        
    }
}
