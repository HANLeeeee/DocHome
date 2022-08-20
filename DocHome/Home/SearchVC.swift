//
//  SearchVC.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/21.
//

import UIKit

class SearchVC: UIViewController {
    let searchView = SearchView()
        
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVC()
    }
    
    func configureVC() {
        searchView.searchTextField.becomeFirstResponder()
    }
}
