//
//  MapView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit

class MapView: UIView {
    
    lazy var searchMapView = { () -> MTMapView in
        let view = MTMapView.init(frame: CGRect(x: 0, y: 0,
                                                width: self.frame.size.width,
                                                height: self.frame.size.height
                                               ))
        view.baseMapType = .standard
        view.currentLocationTrackingMode = .onWithoutHeading
        view.showCurrentLocationMarker = true
        print("RU")
        return view
    }()

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
    
    func addViews() {
        self.addSubview(searchMapView)
    }
    
    func makeConstraints() {
        searchMapView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
