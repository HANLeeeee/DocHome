//
//  FavoriteButton.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/06.
//

import UIKit

protocol FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool)
}

class FavoriteButton: UIButton {
    
    var favoriteButtonDelegate: FavoriteButtonDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isSelected = false
        self.setImage(UIImage(systemName: "star"), for: .normal)
        self.setImage(UIImage(systemName: "star.fill"), for: .selected)
        changeFavoriteColor()
        
        self.addTarget(self, action: #selector(touchUpFavoriteButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 클릭이벤트
    @objc func touchUpFavoriteButton(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        print("FavoriteButton 즐겨찾기 버튼 클릭 \(btn.isSelected)")

        changeFavoriteColor()
        favoriteButtonDelegate?.actionFavoriteButton(isSelect: btn.isSelected)
    }
    
    func changeFavoriteColor() {
        self.tintColor = self.isSelected ? .systemYellow : .gray
    }
}
