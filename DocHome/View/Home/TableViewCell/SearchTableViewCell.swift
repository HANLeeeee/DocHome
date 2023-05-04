//
//  SearchTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
        
    lazy var searchBtn = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        btn.setTitle("검색", for: .normal)
        btn.setTitleColor(UIColor(named: "COLOR_PURPLE"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

        return btn
    }()
    
    lazy var searchBtnImage = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(named: "COLOR_PURPLE")
        return imageView
    }()
    
    
    //MARK: - init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        addLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 라이프사이클
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    //MARK: - UI 관련
    func addViews() {
        self.addSubview(searchBtn)
        self.addSubview(searchBtnImage)
    }
    
    func addLayoutConstraints() {
        searchBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        searchBtnImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25))
        }
    }
}
