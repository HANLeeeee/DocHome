//
//  SearchDetailView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import Foundation
import SnapKit
import UIKit

class SearchDetailView: UIView {
    
    lazy var scrollView = { () -> UIScrollView in
        let view = UIScrollView()
        return view
    }()
    
    lazy var contentView = { () -> UIView in
        let view = UIView()
        return view
    }()

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
    
    lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor(named: "COLOR_PURPLE")
        label.text = "어머니 프랑시스 북간도에 한 위에 나는 지나가는 이국 듯합니다. 이름과 하나에 어머님, 거외다. 너무나 불러 쉬이 봄이 다하지 까닭입니다. 하나 아이들의 않은 시와 둘 듯합니다. 까닭이요, 사랑과 아침이 까닭이요, 아이들의 하나의 라이너 까닭입니다. 흙으로 많은 아침이 슬퍼하는 하나에 밤이 하나의 덮어 옥 까닭입니다."
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var locationLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "어머니 프랑시스 북간도에 한 위에 나는 지나가는 이국 듯합니다. 이름과 하나에 어머님, 거외다. 너무나 불러 쉬이 봄이 다하지 까닭입니다. 하나 아이들의 않은 시와 둘 듯합니다. 까닭이요, 사랑과 아침이 까닭이요, 아이들의 하나의 라이너 까닭입니다. 흙으로 많은 아침이 슬퍼하는 하나에 밤이 하나의 덮어 옥 까닭입니다."
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
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
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mapView)
        mapView.addSubview(mapLocationView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
    }
    
    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.height.equalTo(Constants.Device.width)
            make.width.equalTo(Constants.Device.width)
        }
        
        mapLocationView.snp.makeConstraints { make in
            make.edges.equalTo(self.mapView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }
}
