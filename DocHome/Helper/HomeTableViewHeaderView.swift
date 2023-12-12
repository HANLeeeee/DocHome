//
//  HomeTableViewHeaderView.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/06.
//

import UIKit
import SnapKit

final class HomeTableViewHeaderView: UIView {
    
    let titleLabel = { () -> UILabel in
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .purpleColor
        label.textAlignment = .left
        return label
    }()

    let bottomView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .purpleColor
        return view
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
        self.addSubview(titleLabel)
        self.addSubview(bottomView)
    }
    
    private func makeConstraints() {
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
