//
//  ViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/14.
//

import UIKit

class HomeViewController: UIViewController {
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    let homeView = HomeView()
        
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
    }
    
    func registerTableView() {
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        homeView.homeTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: Constants.TableView.Identifier.searchCell)
        homeView.homeTableView.register(RecommendTableViewCell.self, forCellReuseIdentifier: Constants.TableView.Identifier.recommendCell)
        homeView.homeTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: Constants.TableView.Identifier.categoryCell)
    }
}



//MARK: - 테이블뷰 관련
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테이블뷰 셀 클릭 \(indexPath.row)번째")
        switch indexPath.section {
        case 0:
            print("검색클릭")
            self.present(SearchViewController(), animated: true)
//            self.navigationController?.pushViewController(SearchVC(), animated: true)
            
        case 1:
            print("카테고리클릭")
            
        default:
            print( "병원클릭")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1

        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.searchCell, for: indexPath) as! SearchTableViewCell
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.categoryCell, for: indexPath) as! CategoryTableViewCell
            
            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.recommendCell, for: indexPath) as! RecommendTableViewCell
            
            let index = indexPath.row
            cell.configure(index: index)
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
