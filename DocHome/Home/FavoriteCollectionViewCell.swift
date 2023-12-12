//
//  FavoriteCollectionViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/05.
//

import UIKit
import SnapKit

final class FavoriteCollectionViewCell: UICollectionViewCell {
    
    private var index: Int = -1
    private var favoriteSearchResult = Document()
        
    private let cellView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        return view
    }()

    private let hospitalNameLabel = { () -> UILabel in
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let hospitalLocationLabel = { () -> UILabel in
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    private let hospitalPhoneLabel = { () -> UILabel in
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    private lazy var favoriteButton = { () -> FavoriteButton in
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.contentView.addSubview(cellView)
        cellView.addSubview(hospitalNameLabel)
        cellView.addSubview(hospitalLocationLabel)
        cellView.addSubview(hospitalPhoneLabel)
        cellView.addSubview(favoriteButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hospitalNameLabel.text = ""
        hospitalLocationLabel.text = ""
        hospitalPhoneLabel.text = ""
    }
    
    private func makeConstraints() {
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
        if index < 0 { return }
        if isSelect {
            favoriteSearchResultDatas.insert(favoriteSearchResult, at: index)
        } else {
            favoriteSearchResultDatas.remove(at: index)
        }
    }
}
