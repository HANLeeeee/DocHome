//
//  HomeViewController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/14.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let hospitalCategory = ["전체", "외과", "내과", "치과", "기타"]
    private let tableViewSectionHeaderTitle = ["즐겨찾기", "내 주변 병원"]
    private var searchResultOriginData = [Document]()
    private var searchResultData = [Document]()
    private let refreshControl = UIRefreshControl()
    
    private var currentCategoryTag = 0
    private var isPaging: Bool = true
    private var currentPage: Int = 1
    private var metaData: Meta?
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    override func loadView() {
        super.loadView()
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
    
    private func setupButtons() {
        homeView.searchButton.addTarget(self, action: #selector(touchUpSearchButton), for: .touchUpInside)
        homeView.categoryButtons.forEach { button in
            button.addTarget(self, action: #selector(touchUpCategoryButton), for: .touchUpInside)
        }
    }
    
    //MARK: - 테이블뷰등록 메소드
    private func setupTableView() {
        homeView.homeTableView.delegate = self
        homeView.homeTableView.dataSource = self
        homeView.homeTableView.register(FavoriteTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.favoriteTableViewCell)
        homeView.homeTableView.register(RecommendTableViewCell.self,
                                        forCellReuseIdentifier: Constants.TableView.Identifier.recommendCell)
    }
    
    private func setupRefreshControl() {
        refreshControl.beginRefreshing()
        homeView.homeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullAction), for: .valueChanged)
    }
    
    @objc func pullAction() {
        currentPage = 1
        fetchHospitalInfo()
    }
    
    //MARK: - 병원정보 가져오는 메소드
    private func fetchHospitalInfo() {
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
                showAlert()
            }
        })
    }
    
    private func updateSearchResultData(_ documents: [Document]) {
        if currentPage == 1 {
            searchResultOriginData = documents
        } else {
            searchResultOriginData += documents
        }
    }
    
    private func updateSearchResultMetaData(_ metaData: Meta) {
        self.metaData = metaData
    }
    
    private func refreshHospitalInfo(_ filteredData: [Document]) {
        searchResultData = filteredData
        if searchResultData.count < 6 {
            nextPage()
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            homeView.homeTableView.reloadData()
            refreshControl.endRefreshing()
            
            isPaging = true
            homeView.homeTableView.tableFooterView = nil
        }
    }
    
    private func nextPage() {
        guard let isEndPaging = metaData?.isEnd else { return }
        if isPaging && !isEndPaging {
            isPaging = false
            currentPage += 1
            fetchHospitalInfo()
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                homeView.homeTableView.tableFooterView = IndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            }
        }
    }
}

//MARK: - 버튼이벤트
extension HomeViewController {
    @objc func touchUpSearchButton() {
        let searchVC = SearchViewController()
        searchVC.searchViewDelegate = self
        self.present(searchVC, animated: true)
    }
    
    @objc func touchUpCategoryButton(_ categoryButton: CategoryButton) {
        refreshHospitalInfo(filteredHospitalInfo(categoryButton.tag))
        updateCategoryButton(categoryButton)
    }
    
    private func updateCategoryButton(_ categoryButton: CategoryButton) {
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
    
    private func filteredHospitalInfo(_ categoryIndex: Int) -> [Document] {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewSectionHeaderTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewSectionHeaderTitle[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeTableViewHeaderView()
        headerView.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.bottomView.constraints[1].constant = headerView.titleLabel.intrinsicContentSize.width+10
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if favoriteSearchResultDatas.isEmpty {
                return 0
            }
            return 50
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goSearchDetailVC(data: searchResultData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if favoriteSearchResultDatas.isEmpty {
                return 0
            }
            return 1

        case 1:
            return searchResultData.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.favoriteTableViewCell, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
            cell.reloadFavoriteCollectionView()
            cell.favoriteTableViewCellDelegate = self
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.Identifier.recommendCell, for: indexPath) as? RecommendTableViewCell else { return UITableViewCell() }
            
            let searchResult = searchResultData[indexPath.row]
            cell.configureCell(searchResult: searchResult)
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNewHospitalInfo(scrollView)
        updateStikyHeader(scrollView)
    }
    
    private func updateNewHospitalInfo(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        if scrollOffset > scrollView.contentSize.height-scrollView.frame.size.height+100 {
            nextPage()
        }
    }
    
    private func updateStikyHeader(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        let scrollY = homeView.topView.constraints[0].constant - scrollOffset
        let maxHeight = Constants.View.HomeView.TopView.size.maxHeight
        let minHeight = Constants.View.HomeView.TopView.size.minHeight
        
        let clampedScrollY = min(max(scrollY, minHeight), maxHeight)
        homeView.topView.constraints[0].constant = clampedScrollY
        
        if scrollY > minHeight && scrollY < maxHeight {
             scrollView.contentOffset.y = 0
         }
        
        let alpha = clampedScrollY / maxHeight
        homeView.cellStackView.alpha = alpha
    }
}


//MARK: - SearchViewDelegate
extension HomeViewController: SearchViewDelegate {
    func goSearchDetailVC(data: Document) {
        let index = favoriteSearchResultDatas.firstIndex(where: { $0.id == data.id }) ?? favoriteSearchResultDatas.endIndex
        let searchDetailVC = SearchDetailViewController(detailData: data, index: index)
        
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
