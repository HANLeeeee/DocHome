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
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        btn.setTitle("병원명을 검색해보세요 !", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
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
    
    lazy var cellButton = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("전체", for: .normal)
        btn.tag = 0
        btn.isSelected = true
        btn.backgroundColor = UIColor(named: "COLOR_PURPLE")
        return btn
    }()
    
    lazy var cellButton2 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("외과", for: .normal)
        btn.tag = 1
        return btn
    }()
    
    lazy var cellButton3 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("내과", for: .normal)
        btn.tag = 2
        return btn
    }()
    
    lazy var cellButton4 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("치과", for: .normal)
        btn.tag = 3
        return btn
    }()
    
    lazy var cellButton5 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("기타", for: .normal)
        btn.tag = 4
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
    
    var categoryButtons = [CategoryButton]()

    //MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        makeConstraints()
        
        categoryButtons.append(cellButton)
        categoryButtons.append(cellButton2)
        categoryButtons.append(cellButton3)
        categoryButtons.append(cellButton4)
        categoryButtons.append(cellButton5)
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
