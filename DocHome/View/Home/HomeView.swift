//
//  HomeView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    lazy var topView = { () -> UIView in
        let view = UIView()
        return view
    }()
    
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
        btn.setTitle("피부과", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return btn
    }()
    
    lazy var cellButton5 = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        btn.setTitle("기타", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return btn
    }()
    
    lazy var homeTableView = { () -> UITableView in
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    

    //MARK: - init()
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
        self.addSubview(topView)
        topView.addSubview(searchBtn)
        topView.addSubview(searchBtnImage)
        
        topView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(cellButton)
        cellStackView.addArrangedSubview(cellButton2)
        cellStackView.addArrangedSubview(cellButton3)
        cellStackView.addArrangedSubview(cellButton4)
        cellStackView.addArrangedSubview(cellButton5)
        
        self.addSubview(homeTableView)
    }
    
    func makeConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(Constants.View.HomeView.TopView.size.maxHeight)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.View.HomeView.TopView.size.minHeight)
        }
        
        searchBtnImage.snp.makeConstraints { make in
            make.centerY.equalTo(searchBtn.snp.centerY)
            make.trailing.equalTo(searchBtn.snp.trailing).offset(-20)
        }
        
        cellStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBtn.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        cellButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        homeTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
