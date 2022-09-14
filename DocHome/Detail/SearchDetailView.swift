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
        label.text = "병원명"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var locationLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "스크롤 뷰 안에 컨텐츠 들이 들어가는 컨텐츠뷰를 하나 생성하였습니다. 애플 공식 문서에서도 정의되어있듯이 스크롤뷰 안에는 스크롤 되는 컨텐츠뷰가 존재해야 스크롤 뷰가 정상적으로 동작합니다. 따라서 컨텐츠 뷰라는 이름을 가진 UIView객체를 하나 생성하였습니다. 스크롤 되는 모든 컴포넌트들은 모두 여기의 자식뷰로 들어갈 예정입니다."
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var distanceLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "현재 위치에서의 거리"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var telLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "02-1234-5678"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var linkBtn = { () -> UIButton in
        let btn = UIButton()
        btn.setTitle("카카오맵 바로가기", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        //버튼 title 왼쪽정렬
        btn.contentHorizontalAlignment = .left
        return btn
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
        contentView.addSubview(distanceLabel)
        contentView.addSubview(telLabel)
        contentView.addSubview(linkBtn)
    }
    
    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.equalTo(frame.width)
            make.height.equalTo(frame.height)
        }
        
        mapView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(Constants.Device.width)
            make.width.equalTo(Constants.Device.width)
        }
        
        mapLocationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        telLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        linkBtn.snp.makeConstraints { make in
            make.top.equalTo(telLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
    }
}
