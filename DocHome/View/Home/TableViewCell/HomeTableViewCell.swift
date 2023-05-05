//
//  HomeTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/05.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    
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
        registerCollectionView()
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: Constants.CollectionView.Identifier.homeCollectionViewCell)
    }
    
    
    //MARK: - UI 관련
    func addViews() {
        self.contentView.addSubview(collectionView)
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-10)
            make.height.equalTo(Constants.CollectionView.HomeCollectionViewCell.size.height+10)
        }
    }
}

//MARK: - 컬렉션뷰 관련
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.Identifier.homeCollectionViewCell, for: indexPath) as! HomeCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Constants.CollectionView.HomeCollectionViewCell.size.width, height: Constants.CollectionView.HomeCollectionViewCell.size.height)
    }
}
