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
    let hospitalCategory = ["전체", "외과", "내과", "치과", "기타"]
    let tableViewSectionHeaderTitle = ["즐겨찾기", "내 주변 병원"]
    var searchResultOriginData = [Document]()
    var searchResultData = [Document]()
    let refreshControl = UIRefreshControl()
    
    var currentCategoryTag = 0
    //페이징
    var isPaging: Bool = true
    var currentPage: Int = 1
    var metaData: Meta?
        
    //MARK: - 라이프사이클
    override func loadView() {
        self.view = .init()
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHospitalInfo()
    }
    
    //MARK: - UI 메소드
    func setupButtons() {
        homeView.searchBtn.addTarget(self, action: #selector(touchUpSearchBtn), for: .touchUpInside)
        homeView.categoryButtons.forEach { button in
            button.addTarget(self, action: #selector(touchUpCategoryBtn), for: .touchUpInside)
        }
    }
    
    //MARK: - 테이블뷰등록 메소드
    func setupTableView() {
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        homeView.homeTableView.register(FavoriteTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.favoriteTableViewCell)
        homeView.homeTableView.register(RecommendTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.recommendCell)
    }
    
    func setupRefreshControl() {
        refreshControl.beginRefreshing()
        homeView.homeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullAction), for: .valueChanged)
    }
    
    //테이블뷰 당겨서 새로고침
    @objc func pullAction() {
        currentPage = 1
        fetchHospitalInfo()
    }
    
    //MARK: - 병원정보 가져오는 메소드
    func fetchHospitalInfo() {
        let userLocation = UserDefaultsData.shared.getLocation()
        APIExecute.shared.searchCategoryRequest(isPaging: self.isPaging, x: userLocation.longitude, y: userLocation.latitude, page: self.currentPage, completion: { [self] (result: Result<SearchResponse, Error>) in
            
            switch result {
            case .success(let response):
                guard !response.documents.isEmpty else { return }
                updateSearchResultData(response.documents)
                updateSearchResultMetaData(response.meta)
                refreshHospitalInfo(filteredHospitalInfo(currentCategoryTag))

            case .failure(let error):
                print("통신 에러 \(error)")
                self.present(showAlert(), animated: true)
            }
        })
    }
    
    func updateSearchResultData(_ documents: [Document]) {
        if currentPage == 1 {
            searchResultOriginData = documents
        } else {
            searchResultOriginData += documents
        }
    }
    
    func updateSearchResultMetaData(_ metaData: Meta) {
        self.metaData = metaData
    }
    
    func refreshHospitalInfo(_ filteredData: [Document]) {
        searchResultData = filteredData
        if searchResultData.count < 6 {
            nextPage()
        }
        DispatchQueue.main.async { [self] in
            homeView.homeTableView.reloadData()
            refreshControl.endRefreshing()
            
            self.isPaging = true
            homeView.homeTableView.tableFooterView = nil
        }
    }
    
    func nextPage() {
        guard let isEndPaging = metaData?.isEnd else { return }
        if isPaging && !isEndPaging {
            isPaging = false
            currentPage += 1
            fetchHospitalInfo()
            
            DispatchQueue.main.async { [self] in
                homeView.homeTableView.tableFooterView = IndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            }
        }
    }
}

//MARK: - 버튼이벤트
extension HomeViewController {
    @objc func touchUpSearchBtn() {
        let searchVC = SearchViewController()
        searchVC.searchViewDelegate = self
        self.present(searchVC, animated: true)
    }
    
    @objc func touchUpCategoryBtn(_ categoryButton: CategoryButton) {
        refreshHospitalInfo(filteredHospitalInfo(categoryButton.tag))
        updateCategoryButton(categoryButton)
    }
    
    func updateCategoryButton(_ categoryButton: CategoryButton) {
        for button in homeView.categoryButtons {
            if button.tag == categoryButton.tag {
                currentCategoryTag = categoryButton.tag
                categoryButton.isSelected = true
            } else {
                button.isSelected = false
            }
            button.changeCategoryButtonColor()
        }
    }
    
    //MARK: - 병원 카테고리 필터링
    func filteredHospitalInfo(_ categoryIndex: Int) -> [Document] {
        switch categoryIndex {
        case 1...3:
            return searchResultOriginData.filter { document in
                document.categoryName.contains(hospitalCategory[categoryIndex])}
            
        case 4:
            //외과 내과 치과 피부과를 제외한 모든 카테고리
            return searchResultOriginData.filter({ !$0.categoryName.contains(hospitalCategory[1]) && !$0.categoryName.contains(hospitalCategory[2]) && !$0.categoryName.contains(hospitalCategory[3])
            })
        default:
            return searchResultOriginData
        }
    }
}

//MARK: - 테이블뷰 관련
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionHeaderTitle.count
    }
    
    //섹션헤더 텍스트
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSectionHeaderTitle[section]
    }
    
    //섹션헤더 텍스트 폰트 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeTableViewHeaderView()
        headerView.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.bottomView.constraints[1].constant = headerView.titleLabel.intrinsicContentSize.width+10
        
        return headerView
    }
    
    //섹션헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if favoriteSearchResultDatas.count == 0 {
            return 0
        }
        return 50
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
            cell.favoriteTableViewCellDelegate = self
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
    
    //테이블뷰 스크롤 설정, 스티키헤더 설정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNewHospitalInfo(scrollView)
        updateStikyHeader(scrollView)
    }
    
    func updateNewHospitalInfo(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset > scrollView.contentSize.height-scrollView.frame.size.height+100 {
            nextPage()
        }
    }
    
    func updateStikyHeader(_ scrollView: UIScrollView) {
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

//MARK: - FavoriteTableViewCellDelegate
extension HomeViewController: FavoriteTableViewCellDelegate {
    func getCollectionViewIndex(index: Int) {
        let favoriteDocument = favoriteSearchResultDatas[index]
        goSearchDetailVC(data: favoriteDocument)
    }
}
