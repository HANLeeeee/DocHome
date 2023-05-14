//
//  FooterView.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/15.
//

import UIKit
import SnapKit

class IndicatorView: UIView {
    
    lazy var spinner = { () -> UIActivityIndicatorView in
        let spinner = UIActivityIndicatorView()
        spinner.center = self.center
        spinner.startAnimating()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    func addSubViews() {
        self.addSubview(spinner)
    }
}
