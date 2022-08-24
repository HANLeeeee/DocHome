//
//  SearchVC.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/21.
//

import UIKit

class SearchViewController: UIViewController {
    let userLocation = UserDefaultsData.shared.getLocation()
    let searchView = SearchView()
    var searchResultData = [Document]()
        
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
        registerTableView()
        configureTarget()
    }
    
    func registerTableView() {
        searchView.resultTableView.delegate = self
        searchView.resultTableView.dataSource = self
        
        searchView.resultTableView.register(SearchKeywordTableViewCell.self, forCellReuseIdentifier: Constants.TableView.Identifier.searchKeywordCell)
    }
    
    
    func configureTarget() {
        searchView.searchTextField.becomeFirstResponder()
        
        searchView.searchTextField.addTarget(self,
                     action: #selector(didChangeSearchTF(_:)),
                     for: .editingChanged)
        searchView.searchBtn.addTarget(self,
                      action: #selector(didTabSearchBtn(_:)),
                      for: .touchUpInside)
    }
}


//MARK: - 테이블뷰 관련
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.searchKeywordCell, for: indexPath)as! SearchKeywordTableViewCell
        
        let searchResult = searchResultData[indexPath.row]
        cell.configureCell(searchResult: searchResult)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: - Action 관련
extension SearchViewController {
    @objc func didChangeSearchTF(_ sender: Any) {
        print("텍스트필드 입력중")
    }
    
    @objc func didTabSearchBtn(_ sender: Any) {
        print("검색 버튼 클릭")
        self.view.endEditing(true)
        Loading.showLoading()
        DispatchQueue.main.async { [self] in
            if let searchText = searchView.searchTextField.text {
                API.shared.searchKeywordAPI(keyword: searchText, x: userLocation.longitude ?? "0", y: userLocation.latitude ?? "0", completion: { [self] result in
                    switch result {
                    case .success(let result):
                        if result.documents.count == 0 {
                            searchResultData = []
                            searchView.resultTableView.isHidden = true
                            searchView.searchResultLabel.isHidden = false
                        } else {
                            searchResultData = result.documents
                            searchView.resultTableView.isHidden = false
                        }
                        searchView.resultTableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                })
                Loading.hideLoading()
                return
            }
        }
    }
}

