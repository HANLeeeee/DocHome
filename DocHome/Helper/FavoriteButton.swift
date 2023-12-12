//
//  FavoriteButton.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/06.
//

import UIKit

protocol FavoriteButtonDelegate: AnyObject {
    func actionFavoriteButton(isSelect: Bool)
}

final class FavoriteButton: UIButton {
    
    weak var favoriteButtonDelegate: FavoriteButtonDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.isSelected = false
        self.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        changeFavoriteButtonColor()
        
        self.addTarget(self, action: #selector(touchUpFavoriteButton), for: .touchUpInside)
    }
    
    @objc func touchUpFavoriteButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        print("FavoriteButton 즐겨찾기 버튼 클릭 \(button.isSelected)")

        changeFavoriteButtonColor()
        favoriteButtonDelegate?.actionFavoriteButton(isSelect: button.isSelected)
    }
    
    func changeFavoriteButtonColor() {
        self.tintColor = self.isSelected ? .purpleColor : .gray
    }
}
