//
//  SearchDetailView.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/04.
//

import SnapKit
import UIKit

final class SearchDetailView: UIView {
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let contentView: UIView = UIView()
    
    private let mapView: UIView = UIView()
    
    lazy var mapLocationView = { () -> MTMapView in
        let view = MTMapView.init(frame: CGRect(x: 0, y: 0,
                                                width: self.frame.size.width,
                                                height: self.frame.size.height
                                               ))
        view.baseMapType = .standard
        return view
    }()
    
    let myLocationButton = { () -> UIButton in
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
    
    let destinationButton = { () -> UIButton in
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
    
    private let titleLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .purpleColor
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let categoryLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .purpleColor
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let distanceLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "현재 위치에서의 거리"
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let distanceValueLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .purpleColor
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let telLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let kakaoMapButton = { () -> UIButton in
        let btn = UIButton()
        btn.setTitle("카카오맵 바로가기", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    let favoriteButton: FavoriteButton = FavoriteButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubViews()
        makeConstraints()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
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
    
    private func makeConstraints() {
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
    
    func setupLabelText(title: String, category: String, location: String, distance: String, tel: String) {
        titleLabel.text = title
        categoryLabel.text = category
        locationLabel.text = location
        distanceValueLabel.text = distance
        telLabel.text = tel
    }
}
