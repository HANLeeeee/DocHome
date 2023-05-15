//
//  SearchVC.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/21.
//

import UIKit

protocol SearchViewDelegate {
    func goSearchDetailVC(data: Document)
}

class SearchViewController: UIViewController {
    
    let userLocation = UserDefaultsData.shared.getLocation()
    let searchView = SearchView()
    var searchResultData = [Document]()
    var searchViewDelegate: SearchViewDelegate?
        
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
        setupTableView()
        setupButtons()
    }
    
    func setupTableView() {
        searchView.resultTableView.delegate = self
        searchView.resultTableView.dataSource = self
        
        searchView.resultTableView.register(SearchKeywordTableViewCell.self,
                                            forCellReuseIdentifier: Constants.TableView.Identifier.searchKeywordCell)
    }
    
    
    func setupButtons() {
        searchView.searchTextField.becomeFirstResponder()
        
        searchView.searchTextField.addTarget(self,
                     action: #selector(didChangeSearchTextField(_:)),
                     for: .editingChanged)
        searchView.searchButton.addTarget(self,
                      action: #selector(touchupSearchButton(_:)),
                      for: .touchUpInside)
    }
}


//MARK: - 테이블뷰 관련
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테이블뷰 셀 클릭 \(indexPath.row)번째")
        searchViewDelegate?.goSearchDetailVC(data: searchResultData[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.searchKeywordCell, for: indexPath) as? SearchKeywordTableViewCell else {
            return UITableViewCell()
        }
        
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
    @objc func didChangeSearchTextField(_ sender: Any) {
        updateSearchKeywordResults()
    }
    
    @objc func touchupSearchButton(_ sender: Any) {
        self.view.endEditing(true)
        updateSearchKeywordResults()
    }
    
    func updateSearchKeywordResults() {
        guard let searchText = searchView.searchTextField.text, !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        searchView.resultTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        searchKeywordResults(keyword: searchText)
    }
    
    func searchKeywordResults(keyword: String) {
        APIExecute.shared.searchKeywordRequest(keyword: keyword, x: userLocation.longitude, y: userLocation.latitude, completion: { [self] (result: Result<SearchResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.documents.isEmpty {
                        self.clearSearchResult()
                    } else {
                        self.updateSearchResult(response.documents)
                    }
                }
            case .failure(let error):
                print("통신 에러 \(error)")
                return
            }
        })
    }
    
    func clearSearchResult() {
        searchResultData.removeAll()
        searchView.resultTableView.isHidden = true
        searchView.searchResultLabel.isHidden = false
        searchView.resultTableView.reloadData()
    }
    
    func updateSearchResult(_ documents: [Document]) {
        searchResultData = documents
        searchView.resultTableView.isHidden = false
        searchView.searchResultLabel.isHidden = true
        searchView.resultTableView.reloadData()
    }
}

