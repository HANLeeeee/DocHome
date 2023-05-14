//
//  FavoriteTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/05.
//

import UIKit
import SnapKit

protocol FavoriteTableViewCellDelegate {
    func getCollectionViewIndex(index: Int)
}

class FavoriteTableViewCell: UITableViewCell {
    
    var favoriteTableViewCellDelegate: FavoriteTableViewCellDelegate?
    
    lazy var collectionView = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.backgroundColor = .white
        cView.showsHorizontalScrollIndicator = false
        return cView
    }()

    //MARK: - init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        addSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: Constants.CollectionView.Identifier.favoriteCollectionViewCell)
    }
    
    
    //MARK: - UI 관련
    func addSubViews() {
        self.contentView.addSubview(collectionView)
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-10)
            make.height.equalTo(Constants.CollectionView.FavoriteCollectionViewCell.size.height+10)
        }
    }
    
    func reloadFavoriteCollectionView() {
        collectionView.reloadData()
    }
}

//MARK: - 컬렉션뷰 관련
extension FavoriteTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteSearchResultDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.Identifier.favoriteCollectionViewCell, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if favoriteSearchResultDatas.isEmpty == false {
            cell.configureCell(favoriteSearchResult: favoriteSearchResultDatas[indexPath.row], index: indexPath.row)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Constants.CollectionView.FavoriteCollectionViewCell.size.width, height: Constants.CollectionView.FavoriteCollectionViewCell.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        favoriteTableViewCellDelegate?.getCollectionViewIndex(index: indexPath.row)
    }
}
