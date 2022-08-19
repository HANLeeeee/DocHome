//
//  RecommendTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

class RecommendTableViewCell: UITableViewCell {
    
    static let identifier = "RecommendTableViewCell"
    
    lazy var cellTitle = { () -> UILabel in
        let label = UILabel()
        label.text = "내 주변 병원"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "COLOR_PURPLE")
        
        return label
    }()
    
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
    
    lazy var hostipalNameLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "나누리병원"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    
    
    var cellViewTopConstraint : Constraint? = nil


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
    
    override func prepareForReuse() {
        cellTitle.isHidden = false
    }

    //MARK: - UI 관련
    func addViews() {
        self.addSubview(cellTitle)
        self.addSubview(cellView)
        cellView.addSubview(hostipalNameLabel)
    }
    
    func addLayoutConstraints() {
        cellTitle.snp.makeConstraints { make in
            make.top.left.equalTo(20)
        }
        
        cellView.snp.makeConstraints { make in
            self.cellViewTopConstraint = make.top.equalTo(cellTitle.snp.bottom).offset(0).constraint
            make.left.right.bottom.equalTo(0).inset(UIEdgeInsets(top: 0, left: 15, bottom: 3, right: 15))
            make.height.equalTo(100)
        }
        
        hostipalNameLabel.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            
        }
    }
    
    func configure(index: Int) {
        if index == 0 {
            cellTitle.isHidden = false
            self.cellViewTopConstraint?.update(offset: 10)
        } else {
            cellTitle.isHidden = true
            self.cellViewTopConstraint?.update(offset: -13)
        }
    }
}
