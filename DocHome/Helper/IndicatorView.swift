//
//  FooterView.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/15.
//

import UIKit
import SnapKit

final class IndicatorView: UIView {
    
    private lazy var spinner = { () -> UIActivityIndicatorView in
        let spinner = UIActivityIndicatorView()
        spinner.center = self.center
        spinner.style = .medium
        spinner.startAnimating()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(spinner)
    }
}
