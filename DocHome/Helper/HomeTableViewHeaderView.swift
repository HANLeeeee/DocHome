//
//  HomeTableViewHeaderView.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/06.
//

import UIKit
import SnapKit

class HomeTableViewHeaderView: UIView {
    
    lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "COLOR_PURPLE")
        label.textAlignment = .left
        return label
    }()

    lazy var bottomView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = UIColor(named: "COLOR_PURPLE")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(bottomView)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(10)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        bottomView.snp.makeConstraints{ make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.bottom.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(titleLabel.intrinsicContentSize.width+10)
        }
    }
}
