//
//  MapVC.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/14.
//

import UIKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController, MTMapViewDelegate {
    
    //MARK: - 프로퍼티
    let userLocation = UserDefaultsData.shared.getLocation()
    let mapView = MapView()
    var locationManger = CLLocationManager()
    
    
    //MARK: - init()
    convenience init(title: String) {
        self.init()
        self.title = title
        self.view.backgroundColor = .white
    }
    
    
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        addCurrentLocationMarker()
    }
    
    func configureLocation() {
        mapView.searchMapView.delegate = self
        //위치설정
        mapView.searchMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: userLocation.latitude, longitude: userLocation.longitude)), zoomLevel: 1, animated: true)
        
        locationManger.delegate = self
        // 거리 정확도 설정
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        getLocationPermission()
        
        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManger.startUpdatingLocation() //위치 정보 받아오기 시작
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    
    // 사용자에게 허용 받기 alert 띄우기
    func getLocationPermission() {
        self.locationManger.requestWhenInUseAuthorization()
    }
    
    //현재위치 마커 추가
    func addCurrentLocationMarker() {
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: userLocation.latitude, longitude: userLocation.longitude))
        let poiItem = MTMapPOIItem()
        poiItem.markerType = MTMapPOIItemMarkerType.bluePin
        poiItem.mapPoint = mapPoint
        poiItem.itemName = "현재 위치"
        mapView.searchMapView.add(poiItem)
    }
}



//MARK: - CoreLocation 위치 관련
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            UserDefaultsData.shared.setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    // 위도 경도 받아오기 에러
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
