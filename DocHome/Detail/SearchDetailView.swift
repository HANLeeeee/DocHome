//
//  SearchDetailView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import Foundation
import SnapKit

class SearchDetailView: UIView {
    
    lazy var mapView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var mapLocationView = { () -> MTMapView in
        let view = MTMapView.init(frame: CGRect(x: 0, y: 0,
                                                width: self.frame.size.width,
                                                height: self.frame.size.height
                                               ))
        view.baseMapType = .standard
        
        //현재위치트래킹
        view.currentLocationTrackingMode = .onWithoutHeading
        view.showCurrentLocationMarker = true
        
        return view
    }()
    
    //MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        makeConstraints()
    }
    
    
    //MARK: - func
    func addViews() {
        self.addSubview(mapView)
        mapView.addSubview(mapLocationView)
    }
    
    func makeConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Device.width)
            make.width.equalTo(Constants.Device.width)
        }
        
        mapLocationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
