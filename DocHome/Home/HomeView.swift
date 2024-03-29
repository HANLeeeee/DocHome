//
//  HomeView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    private let titleString = "DocHome"
    
    let headerView = { () -> UIView in
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var headerTitleLabel = { () -> UILabel in
        let label = UILabel()
        label.text = titleString
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let headerSearchButton = { () -> UIButton in
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = .purpleColor
        return btn
    }()
    
    let topView: UIView = UIView()
    
    private lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.text = titleString
        label.font = .systemFont(ofSize: 38, weight: .black)
        label.textColor = .purpleColor
        return label
    }()
    
    let searchButton = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.purpleColor?.cgColor
        btn.setTitle("병원명을 검색해보세요 !", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        return btn
    }()

    private let searchButtonImage = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .purpleColor
        return imageView
    }()
    
    private let cellStackView = { () -> UIStackView in
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let cellButton = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("전체", for: .normal)
        btn.tag = 0
        btn.isSelected = true
        btn.backgroundColor = .purpleColor
        return btn
    }()
    
    private let cellButton2 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("외과", for: .normal)
        btn.tag = 1
        return btn
    }()
    
    private let cellButton3 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("내과", for: .normal)
        btn.tag = 2
        return btn
    }()
    
    private let cellButton4 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("치과", for: .normal)
        btn.tag = 3
        return btn
    }()
    
    private let cellButton5 = { () -> CategoryButton in
        let btn = CategoryButton()
        btn.setTitle("기타", for: .normal)
        btn.tag = 4
        return btn
    }()
    
    let homeTableView = { () -> UITableView in
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
    
    let searchResultLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .darkGray
        label.isHidden = true
        return label
    }()
    
    lazy var categoryButtons: [CategoryButton] = [cellButton, cellButton2, cellButton3, cellButton4, cellButton5]

    //MARK: - init()
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
        self.addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(searchButton)
        topView.addSubview(searchButtonImage)
        
        self.addSubview(headerView)
        headerView.addSubview(headerTitleLabel)
        headerView.addSubview(headerSearchButton)
        
        topView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(cellButton)
        cellStackView.addArrangedSubview(cellButton2)
        cellStackView.addArrangedSubview(cellButton3)
        cellStackView.addArrangedSubview(cellButton4)
        cellStackView.addArrangedSubview(cellButton5)
        
        self.addSubview(homeTableView)
        homeTableView.addSubview(searchResultLabel)
    }
    
    private func makeConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(Constants.View.HomeView.TopView.topAnchor)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(Constants.View.HomeView.TopView.size.maxHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.View.HomeView.TopView.size.minHeight)
        }
        
        searchButtonImage.snp.makeConstraints { make in
            make.centerY.equalTo(searchButton.snp.centerY)
            make.trailing.equalTo(searchButton.snp.trailing).offset(-20)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(Constants.View.HomeView.TopView.size.minHeight)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(headerView)
        }
        
        headerSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerView)
            make.height.width.equalTo(headerView.snp.height)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
        cellStackView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(20)
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
        
        searchResultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
    }
}
