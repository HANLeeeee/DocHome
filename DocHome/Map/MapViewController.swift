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
        setVC()
    }
    
    func setVC() {
        mapView.searchMapView.delegate = self
        //위치설정
        mapView.searchMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.456518177069526, longitude: 126.70531256589555)), zoomLevel: 1, animated: true)
        
        
        locationManger.delegate = self
        // 거리 정확도 설정
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        // 사용자에게 허용 받기 alert 띄우기
        locationManger.requestWhenInUseAuthorization()
  
        // 아이폰 설정에서의 위치 서비스가 켜진 상태라면
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManger.startUpdatingLocation() //위치 정보 받아오기 시작
//            print(locationManger.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
}



//MARK: - CoreLocation 위치 관련
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        }
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
