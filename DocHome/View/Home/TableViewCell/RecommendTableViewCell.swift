//
//  RecommendTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

protocol RecommendTableViewCellDelegate {
    func touchUpfavoriteButton(index: Int)
}

class RecommendTableViewCell: UITableViewCell {
    var recommendTableViewCellDelegate: RecommendTableViewCellDelegate?
    var index = -1
    
    //MARK: - UI 프로퍼티
    lazy var cellView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        return view
    }()
    
    lazy var hospitalNameLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "가을로 가슴속에 하나에 불러 내린 릴케 언덕 멀리 까닭입니다. 이름을 다하지 이런 오면 언덕 듯합니다. 동경과 잔디가 때 가을 추억과 있습니다. 마리아 릴케 별에도 언덕 부끄러운 헤는 거외다. 못 위에도 오면 까닭입니다."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hospitalLocationLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "가을로 가슴속에 하나에 불러 내린 릴케 언덕 멀리 까닭입니다. 이름을 다하지 이런 오면 언덕 듯합니다. 동경과 잔디가 때 가을 추억과 있습니다. 마리아 릴케 별에도 언덕 부끄러운 헤는 거외다. 못 위에도 오면 까닭입니다."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hospitalPhoneLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "010-1234-1223232323232323232323234999"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        
        return label
    }()
    
    lazy var hospitalDistanceLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "거리거리다당"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "COLOR_PURPLE")
        
        return label
    }()
    
    lazy var favoriteButton = { () -> UIButton in
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        btn.setImage(UIImage(systemName: "star.fill"), for: .selected)
        btn.tintColor = .gray
        btn.addTarget(self, action: #selector(touchUpFavoriteButton), for: .touchUpInside)
        return btn
    }()
        
    //MARK: - init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 버튼이벤트
    @objc func touchUpFavoriteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        changeFavoriteButton(sender.isSelected)
        recommendTableViewCellDelegate?.touchUpfavoriteButton(index: self.index)
    }
    
    //MARK: - UI 관련
    func addViews() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(hospitalNameLabel)
        cellView.addSubview(hospitalLocationLabel)
        cellView.addSubview(hospitalPhoneLabel)
        cellView.addSubview(hospitalDistanceLabel)
        cellView.addSubview(favoriteButton)
    }
    
    func makeConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalTo(0).inset(UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15))
//            make.height.equalTo(120)
        }
        
        hospitalNameLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(hospitalNameLabel.snp.top)
            make.trailing.equalTo(-10)
            make.height.width.equalTo(30)
        }
        
        hospitalLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(hospitalNameLabel.snp.leading)
            make.trailing.equalTo(-10)
        }
        
        hospitalPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalLocationLabel.snp.bottom).offset(10)
            make.leading.equalTo(hospitalLocationLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(hospitalDistanceLabel.snp.leading)
        }
        
        hospitalDistanceLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalPhoneLabel.snp.top)
            make.trailing.equalTo(hospitalLocationLabel.snp.trailing).offset(-5)
            make.bottom.equalTo(-10)
        }
    }
    
    func configureCell(searchResult: Document, index: Int) {
        self.index = index
        hospitalNameLabel.text = searchResult.placeName
        hospitalLocationLabel.text = searchResult.roadAddressName
        hospitalPhoneLabel.text = searchResult.phone
        hospitalDistanceLabel.text = "\(searchResult.distance) m"
        
        changeFavoriteButton(searchResult.isFavorite)
    }
    
    //즐겨찾기버튼 변경
    func changeFavoriteButton(_ isSelect: Bool) {
        if favoriteButton.isSelected {
            favoriteButton.tintColor = .systemYellow
        } else {
            favoriteButton.tintColor = .gray
        }
    }
}
