//
//  SearchDetailView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import Foundation
import SnapKit

class SearchDetailView: UIView {
    
    lazy var mapView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .red
        return view
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
        self.addSubview(mapView)
    }
    
    func makeConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
    }
}
