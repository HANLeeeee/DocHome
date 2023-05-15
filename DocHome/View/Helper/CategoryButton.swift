//
//  CategoryButton.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/06.
//

import UIKit

class CategoryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.setTitleColor(.purpleColor, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.purpleColor?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCategoryButtonColor() {
        self.backgroundColor = self.isSelected ? .purpleColor : .white
    }
}
