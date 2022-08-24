//
//  SettingVC.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/14.
//

import UIKit

class SettingViewController: UIViewController {
    
    convenience init(title: String) {
        self.init()
        self.title = title
        self.view.backgroundColor = .white
    }
    
    //MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
