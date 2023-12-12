//
//  MapViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/14.
//

import UIKit
import SnapKit
import CoreLocation

final class MapViewController: UIViewController, MTMapViewDelegate {
    
    private let userLocation = UserDefaultsData.shared.getLocation()
    private let mapView = MapView()
    private var locationManger = CLLocationManager()
    
    convenience init(title: String) {
        self.init()
        self.title = title
        self.view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("맵뷰 viewDidLoad")
        configureLocation()
        addCurrentLocationMarker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("맵뷰 viewWillAppear")
        setCurrentLocation()
    }
    
    private func configureLocation() {
        mapView.searchMapView.delegate = self
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        getLocationPermission()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManger.startUpdatingLocation()
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    
    private func setCurrentLocation() {
        mapView.searchMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: userLocation.latitude, longitude: userLocation.longitude)), zoomLevel: 1, animated: true)
    }
    
    private func getLocationPermission() {
        self.locationManger.requestWhenInUseAuthorization()
    }
    
    private func addCurrentLocationMarker() {
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: userLocation.latitude, longitude: userLocation.longitude))
        let poiItem = MTMapPOIItem()
        poiItem.markerType = MTMapPOIItemMarkerType.bluePin
        poiItem.mapPoint = mapPoint
        poiItem.itemName = "현재 위치"
        mapView.searchMapView.add(poiItem)
    }
}

//MARK: - CoreLocation 위치 관련
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            UserDefaultsData.shared.setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("권한 설정 허용")
            
        case .restricted, .notDetermined:
            print("권한 설정 안됨")
            getLocationPermission()
            
        case .denied:
            print("권한 설정 거부")
            getLocationPermission()
            
        @unknown default:
            print("권한 설정 이상")
        }
    }
}
