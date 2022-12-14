//
//  SearchView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/21.
//

import Foundation
import SnapKit

class SearchView: UIView {
    
    lazy var searchView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return view
    }()
    
    lazy var searchBtn = { () -> UIButton in
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = UIColor(named: "COLOR_PURPLE")
        
        return btn
    }()
    
    lazy var searchTextField = { () -> UITextField in
        let tf = UITextField()
        tf.placeholder = "병원명을 입력하세요"
        
        return tf
    }()
    
    lazy var resultTableView = { () -> UITableView in
        let tableView = UITableView()
//        tableView.backgroundColor = .brown
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
    }()
    
    lazy var searchResultLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .darkGray
        label.isHidden = true
        
        return label
    }()
    
    
    //MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        makeConstraints()
    }
    
    
    //MARK: - func
    func addViews() {
        self.addSubview(searchView)
        searchView.addSubview(searchBtn)
        searchView.addSubview(searchTextField)
        
        self.addSubview(searchResultLabel)
        self.addSubview(resultTableView)
    }
    
    func makeConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10))
        }
        
        searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 50))
        }
        
        searchResultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(50)
        }
        
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).inset(-15)
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        }
    }
}
