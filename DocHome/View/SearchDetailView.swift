//
//  SearchDetailView.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/04.
//

import Foundation
import SnapKit
import UIKit

class SearchDetailView: UIView {
    lazy var scrollView = { () -> UIScrollView in
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var contentView = { () -> UIView in
        let view = UIView()
        return view
    }()
    
    lazy var mapView = { () -> UIView in
        let view = UIView()
        return view
    }()
    
    lazy var mapLocationView = { () -> MTMapView in
        let view = MTMapView.init(frame: CGRect(x: 0, y: 0,
                                                width: self.frame.size.width,
                                                height: self.frame.size.height
                                               ))
        view.baseMapType = .standard
        return view
    }()
    
    lazy var myLocationButton = { () -> UIButton in
        let btn = UIButton()
        btn.setTitle("내 위치", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.yellowColor, for: .normal)
        btn.setImage(UIImage(systemName: "location.fill"), for: .normal)
        btn.tintColor = .yellowColor
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        return btn
    }()
    
    lazy var destinationButton = { () -> UIButton in
        let btn = UIButton()
        btn.setTitle("목적지", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.yellowColor, for: .normal)
        btn.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        btn.tintColor = .yellowColor
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        return btn
    }()
    
    lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .purpleColor
        label.text = "병원명이 아주 길었을 경우를 대비하여 작성한 예시입니다."
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var categoryLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .purpleColor
        label.text = "병원명이 아주 길었을 경우를 대비하여 작성한 예시입니다."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var locationLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "스크롤 뷰 안에 컨텐츠 들이 들어가는 컨텐츠뷰를 하나 생성하였습니다. 애플 공식 문서에서도 정의되어있듯이 스크롤뷰 안에는 스크롤 되는 컨텐츠뷰가 존재해야 스크롤 뷰가 정상적으로 동작합니다. 따라서 컨텐츠 뷰라는 이름을 가진 UIView객체를 하나 생성하였습니다. 스크롤 되는 모든 컴포넌트들은 모두 여기의 자식뷰로 들어갈 예정입니다."
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var distanceLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "현재 위치에서의 거리"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var distanceValueLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .purpleColor
        label.text = "거리를 나타내는 라벨입니다."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var telLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "02-1234-5678"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var kakaoMapButton = { () -> UIButton in
        let btn = UIButton()
        btn.setTitle("카카오맵 바로가기", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    lazy var favoriteButton = { () -> FavoriteButton in
        let btn = FavoriteButton()
        return btn
    }()
    
    //MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubViews()
        makeConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    func addSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mapView)
        mapView.addSubview(mapLocationView)
        
        contentView.addSubview(myLocationButton)
        contentView.addSubview(destinationButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(distanceValueLabel)
        contentView.addSubview(telLabel)
        contentView.addSubview(kakaoMapButton)
    }
    
    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(Constants.Device.width)
            make.width.equalTo(Constants.Device.width)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(15)
            make.leading.equalTo(20)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        destinationButton.snp.makeConstraints { make in
            make.top.equalTo(myLocationButton.snp.top)
            make.leading.equalTo(myLocationButton.snp.trailing).offset(10)
            make.height.equalTo(myLocationButton.snp.height)
            make.width.equalTo(myLocationButton.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(myLocationButton.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.height.width.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        distanceValueLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.top)
            make.leading.equalTo(distanceLabel.snp.trailing).offset(5)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }

        telLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        kakaoMapButton.snp.makeConstraints { make in
            make.top.equalTo(telLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(-40)
        }
        
    }
}
