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
    var tableViewSectionHeader = ["즐겨찾기", "내 주변 병원"]
    var searchResultData = [Document]()
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
        homeView.homeTableView.register(FavoriteTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.favoriteTableViewCell)
        homeView.homeTableView.register(RecommendTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.recommendCell)
        
        //refreshControl 설정
        refreshControl.endRefreshing()
        homeView.homeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    //테이블뷰 당겨서 새로고침
    @objc func refreshAction() {
        getHospitalInfo()
    }
    
    //MARK: - 병원정보 가져오는 메소드
    func getHospitalInfo() {
        searchResultData.removeAll()
        DispatchQueue.global().async { [self] in
            let userLocation = UserDefaultsData.shared.getLocation()
            API.shared.searchCategoryAPI(x: userLocation.longitude, y: userLocation.latitude, completion: { [self] result in
                
                guard result.documents.count != 0 else { return }
                searchResultData = result.documents
                
                DispatchQueue.main.async { [self] in
                    homeView.homeTableView.reloadData()
                    refreshControl.endRefreshing()
                }
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
        let headerView = HomeTableViewHeaderView()
        headerView.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.bottomView.constraints[1].constant = headerView.titleLabel.intrinsicContentSize.width+10
        
        return headerView
    }
    
    //섹션의 타이틀 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if favoriteSearchResultDatas.count == 0 {
                return 0
            }
            return 50
        
        default:
            return 50
        }
        
    }
    
    //테이블뷰셀 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goSearchDetailVC(data: searchResultData[indexPath.row])
    }
    
    //섹션별 테이블뷰셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if favoriteSearchResultDatas.count == 0 {
                return 0
            }
            return 1

        case 1:
            return searchResultData.count
            
        default:
            return 0
        }
    }
    
    //테이블뷰셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.favoriteTableViewCell, for: indexPath) as? FavoriteTableViewCell else {
                return UITableViewCell()
            }
            cell.reloadFavoriteCollectionView()
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.recommendCell, for: indexPath) as? RecommendTableViewCell else {
                return UITableViewCell()
            }
            
            let searchResult = searchResultData[indexPath.row]
            cell.configureCell(searchResult: searchResult, index: indexPath.row)
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    //테이블뷰셀 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //테이블뷰 스크롤 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollY = homeView.topView.constraints[0].constant - scrollOffset
        let maxHeight = Constants.View.HomeView.TopView.size.maxHeight
        let minHeight = Constants.View.HomeView.TopView.size.minHeight
        
        if scrollY > maxHeight {
            homeView.topView.constraints[0].constant = maxHeight
            
        } else if scrollY < minHeight {
            homeView.topView.constraints[0].constant = minHeight
            
        } else {
            homeView.topView.constraints[0].constant = scrollY
            
            //점점 흐리게
            homeView.cellStackView.alpha = scrollY / maxHeight
            //자연스럽게 스크롤
            scrollView.contentOffset.y = 0
        }
    }
}


//MARK: - SearchViewDelegate
extension HomeViewController: SearchViewDelegate {
    func goSearchDetailVC(data: Document) {
        let searchDetailVC = SearchDetailViewController()
        searchDetailVC.detailData = data
        self.navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}
