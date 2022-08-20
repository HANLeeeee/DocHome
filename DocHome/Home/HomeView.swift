//
//  HomeView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit

class HomeView: UIView {
    
    lazy var homeTableView = { () -> UITableView in
        let tableView = UITableView()
//        tableView.backgroundColor = .brown
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tableView
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
        self.addSubview(homeTableView)
    }
    
    func makeConstraints() {
        homeTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
