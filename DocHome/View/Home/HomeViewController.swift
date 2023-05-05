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
    
    let userLocation = UserDefaultsData.shared.getLocation()
    let homeView = HomeView()
    var tableViewSectionHeader = ["즐겨찾기", "내 주변 병원"]
    var searchResultData = [Document]()
    var favoriteSearchResultData = [Document]()
    let refreshControl = UIRefreshControl()
        
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        registerTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("홈뷰 viewWillAppear")
        getHospitalInfo()
    }
    
    //MARK: - UI 메소드
    func setUI() {
        homeView.searchBtn.addTarget(self, action: #selector(touchUpSearchBtn), for: .touchUpInside)
    }
    
    //MARK: - 테이블뷰등록 메소드
    func registerTableView() {
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        homeView.homeTableView.register(HomeTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.homeTableViewCell)
        homeView.homeTableView.register(RecommendTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.recommendCell)
        
        //refreshControl 설정
        refreshControl.endRefreshing()
        homeView.homeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    //테이블뷰 당겨서 새로고침
    @objc func refreshAction() {
        print("새로고침")
        //병원정보를 가져오는 것이 아니라 여기서 위치를 다시 받아오기
        //그리고 위치를 받아오는 곳에서 병원정보를 가져오기
        getHospitalInfo()
    }
    
    //MARK: - 병원정보 가져오는 메소드
    func getHospitalInfo() {
        Loading.showLoading()
        searchResultData.removeAll()
        DispatchQueue.global().async { [self] in
            API.shared.searchCategoryAPI(x: userLocation.longitude, y: userLocation.latitude, completion: { [self] result in
                
                guard result.documents.count != 0 else { return }
                searchResultData = result.documents
                
                DispatchQueue.main.async { [self] in
                    homeView.homeTableView.reloadData()
                    refreshControl.endRefreshing()
                }
                Loading.hideLoading()
                
            })

            /* alamofire 사용 시
            API.shared.searchCategoryAPI(x: userLocation.longitude ?? "0", y: userLocation.latitude ?? "0", completion: { [self] result in
                switch result {
                case .success(let result):
                    if result.documents.count != 0 {
                        searchResultData = result.documents
                    }
                    homeView.homeTableView.reloadData()
                    refreshControl.endRefreshing()
                    Loading.hideLoading()
                case .failure(let error):
                    print(error)
                }
            })
             */
        }
    }
}

//MARK: - 버튼이벤트
extension HomeViewController {
    @objc func touchUpSearchBtn() {
        print("검색클릭")
       let searchVC = SearchViewController()
       searchVC.searchViewDelegate = self
       self.present(searchVC, animated: true)
    }
}


//MARK: - 테이블뷰 관련
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionHeader.count
    }
    //섹션의 타이틀 텍스트
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSectionHeader[section]
    }
    //섹션의 타이틀 텍스트 폰트 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 20, y: 10, width: 320, height: 30)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor(named: "COLOR_PURPLE")
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        titleLabel.textAlignment = .left

        let headerView = UIView()
        headerView.backgroundColor = .white
        
        headerView.addSubview(titleLabel)
        return headerView
    }
    //섹션의 타이틀 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("즐겨찾기")
            
        default:
            print("병원클릭")
            goSearchDetailVC(data: searchResultData[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1

        default:
            return searchResultData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.homeTableViewCell, for: indexPath) as! HomeTableViewCell
            
            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.recommendCell, for: indexPath) as! RecommendTableViewCell
            
            let searchResult = searchResultData[indexPath.row]
            cell.configureCell(searchResult: searchResult, index: indexPath.row)
            cell.selectionStyle = .none
            
            cell.recommendTableViewCellDelegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: - SearchView 델리게이트
extension HomeViewController: SearchViewDelegate {
    func goSearchDetailVC(data: Document) {
        let searchDetailVC = SearchDetailViewController()
        searchDetailVC.detailData = data
        self.navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}

//MARK: - RecommendTableViewCell 델리게이트
extension HomeViewController: RecommendTableViewCellDelegate {
    func touchUpfavoriteButton(index: Int) {
        searchResultData[index].isFavorite = true
        favoriteSearchResultData.append(searchResultData[index])
        
    }
}
