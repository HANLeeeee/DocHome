//
//  CategoryTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

class CategoryTableViewCell: UITableViewCell {
    
    lazy var cellStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var cellButton = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        btn.setTitle("외과", for: .normal)
//        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        return btn
    }()
    
    lazy var cellButton2 = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        btn.setTitle("내과", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        return btn
    }()
    
    lazy var cellButton3 = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        btn.setTitle("치과", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return btn
    }()
    
    lazy var cellButton4 = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        btn.setTitle("안과", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return btn
    }()
    
    lazy var cellButton5 = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        btn.setTitle("한의원", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return btn
    }()

    lazy var cellTitle = { () -> UILabel in
        let label = UILabel()
        label.text = "내 주변 병원"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = UIColor(named: "COLOR_PURPLE")
        
        return label
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
        self.addSubview(cellStackView)
        cellStackView.addArrangedSubview(cellButton)
        cellStackView.addArrangedSubview(cellButton2)
        cellStackView.addArrangedSubview(cellButton3)
        cellStackView.addArrangedSubview(cellButton4)
        cellStackView.addArrangedSubview(cellButton5)
        
        self.addSubview(cellTitle)
    }
    
    func addLayoutConstraints() {
        cellStackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0).inset(UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15))
            make.height.equalTo(50)
        }
        
        cellButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        cellTitle.snp.makeConstraints { make in
            make.top.equalTo(cellStackView.snp.bottom).offset(30)
            make.left.equalTo(20)
            make.bottom.equalTo(-5)
        }
    }

}
