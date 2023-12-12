//
//  MapView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

final class MapView: UIView {
    
    lazy var searchMapView = { () -> MTMapView in
        let view = MTMapView.init(frame: CGRect(x: 0, y: 0,
                                                width: self.frame.size.width,
                                                height: self.frame.size.height
                                               ))
        view.baseMapType = .standard
        return view
    }()

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
        self.addSubview(searchMapView)
    }
    
    private func makeConstraints() {
        searchMapView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
