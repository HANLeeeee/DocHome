//
//  FavoriteCollectionViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/05.
//

import UIKit
import SnapKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    var index = -1
    var favoriteSearchResult = Document()
        
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
        label.numberOfLines = 1
        return label
    }()

    lazy var hospitalLocationLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "가을로 가슴속에 하나에 불러 내린 릴케 언덕 멀리 까닭입니다. 이름을 다하지 이런 오면 언덕 듯합니다. 동경과 잔디가 때 가을 추억과 있습니다. 마리아 릴케 별에도 언덕 부끄러운 헤는 거외다. 못 위에도 오면 까닭입니다."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    lazy var hospitalPhoneLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "010-1234-1223232323232323232323234999"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    lazy var favoriteButton = { () -> FavoriteButton in
        let btn = FavoriteButton()
        btn.favoriteButtonDelegate = self
        return btn
    }()
    
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
        self.contentView.addSubview(cellView)
        cellView.addSubview(hospitalNameLabel)
        cellView.addSubview(hospitalLocationLabel)
        cellView.addSubview(hospitalPhoneLabel)
        cellView.addSubview(favoriteButton)
    }
    
    func makeConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hospitalNameLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.lessThanOrEqualTo(favoriteButton.snp.leading).offset(-10)
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
            make.trailing.equalTo(hospitalLocationLabel.snp.trailing).offset(-5)
            make.bottom.equalTo(-10)
        }
    }
    
    func configureCell(favoriteSearchResult: Document, index: Int) {
        self.index = index
        self.favoriteSearchResult = favoriteSearchResult
        hospitalNameLabel.text = favoriteSearchResult.placeName
        hospitalLocationLabel.text = favoriteSearchResult.roadAddressName
        hospitalPhoneLabel.text = favoriteSearchResult.phone
        favoriteButton.isSelected = favoriteSearchResult.isFavorite
        favoriteButton.changeFavoriteButtonColor()
    }
}

//MARK: - FavoriteButtonDelegate
extension FavoriteCollectionViewCell: FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool) {
        if isSelect {
            favoriteSearchResultDatas.insert(favoriteSearchResult, at: index)
        } else {
            favoriteSearchResultDatas.remove(at: index)
        }
    }
}
