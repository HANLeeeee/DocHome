# DocHome


<img src="https://github.com/HANLeeeee/DocHome/assets/74815957/e665c3f4-fc14-4883-be53-694197c80cf9" width=200>


<br /> <br />

## 📌 프로젝트 소개
> 2022.08.14 ~ 2022.08.28 (2주간)  <br/>
- KakaoMap API를 이용한 나의 병원을 기록하는 APP


<br/><br/>

## 📌 사용 방법
- Simulator를 사용하는 경우 [설정 -> 일반 -> 언어 및 지역] 에서 지역을 대한민국으로 변경
- 검색을 클릭하여 원하는 병원명 검색



<br/><br/>
## 📌 기능 소개
- 현재 위치를 기반으로 주변 병원을 조회할 수 있다.
- 병원을 즐겨찾기할 수 있다.
- 병원 이름을 입력하여 병원을 검색할 수 있다.
- 병원 위치 및 정보를 확인할 수 있다.



<br/><br/>

## 📌 구현 화면

<table align="center">
  <tr>
    <th><code>즐겨찾기</code></th>
    <th><code>무한스크롤</code></th>
    <th><code>카테고리</code></th>
    <th><code>검색/디테일</code></th>
  </tr>
  <tr>
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/fb0ba05d-1445-4076-b94d-a08f45d26d91" alt="즐겨찾기">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/9e5fb5fd-c38f-44cf-9631-323233223a6a" alt="무한스크롤">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/a8bc32af-c4dd-456e-9326-d5a60f3e29aa" alt="카테고리">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/9c37876c-45d5-4083-907e-d6bf9440df14" alt="검색/디테일">
  </tr>
</table>


<br/><br/>

## 📌 구현 내용

<details>
<summary><h3>SnapKit 라이브러리 사용</h3></summary>
	
- 스토리보드를 사용하지 않고 Code Base를 기반으로 AutoLayout 구현했습니다.
- SnapKit 라이브러리를 사용하여 더 쉽고 빠르게 AutoLayout을 구현할 수 있었습니다.

```swift
topView.snp.makeConstraints { make in
    make.top.equalTo(self.safeAreaLayoutGuide)
    make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
    make.height.equalTo(Constants.View.HomeView.TopView.size.maxHeight)
}
```

<br/>

</details>

<details>
<summary><h3>모델/네트워크 타입 구현</h3></summary>

- API서버와 HTTP 네트워크를 진행하기 위해서 <code>enum</code> 열거형으로 <code>case</code>를 통해 조건에 맞는 요소들을 추가하였습니다.
- 새로운 Request를 추가할 경우에도 <code>case</code>를 추가하여 확장이 편리하도록 만들었습니다.

```swift
enum APIManager {
    case searchCategory(x: Double, y: Double, page: Int)
    case searchKeyword(keyword: String, x: Double, y: Double)
    
    var endPoint: String {
        switch self {
        case .searchCategory:
            return "/v2/local/search/category.json"
        case .searchKeyword:
            return "/v2/local/search/keyword.json"
        }
    }

...

    func asURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.APIURL.KakaoAPI.searchURL) else { return nil }
        
        urlComponents.path = endPoint
        urlComponents.queryItems = parameters
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method
        
        return request
    }
}
```

<br/>

</details>

<details>
<summary><h3>DelegatePattern 구현</h3></summary>

- 검색화면에서 <code>present</code>나 <code>push</code>를 이용하여 화면 전환을 하면 메인 네비게이션과 연결되지 않아 <code>DelegatePattern</code>을 사용했습니다.
- 프로토콜을 정의하여 검색화면으로 전환하고 싶을 경우에 사용할 수 있게 했습니다.
- 코드의 중복을 줄이고 화면의 재사용을 높여주었습니다.

```swift
protocol FavoriteTableViewCellDelegate: AnyObject {
    func getCollectionViewIndex(index: Int)
}

//MARK: - FavoriteTableViewCellDelegate
extension HomeViewController: FavoriteTableViewCellDelegate {
    func getCollectionViewIndex(index: Int) {
        let favoriteDocument = favoriteSearchResultDatas[index]
        goSearchDetailVC(data: favoriteDocument)
    }
}
```


<br/>

</details>


<details>
<summary><h3>페이징처리를 통한 무한스크롤</h3></summary>

- 한 번 API를 호출하면 10개의 데이터를 가져오고 스크롤을 할 때마다 10개의 데이터를 추가하였습니다.
- <code>TableView</code>에서 가장 밑으로 내렸을 때 <code>Indicator</code> 가 나타나면서 데이터가 추가됩니다.

```swift
// 스크롤을 가장 밑으로 내렸을 때
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollOffset = scrollView.contentOffset.y
    if scrollOffset > scrollView.contentSize.height-scrollView.frame.size.height+100 {
        // 다음 데이터 추가하기
        nextPage()
    }
}

private func nextPage() {
    // 받아온 데이터가 마지막인지 확인
    guard let isEndPaging = metaData?.isEnd else { return }
    // isPaging은 다음 데이터를 받을 지의 유무를 저장한 변수
    if isPaging && !isEndPaging {
        isPaging = false
        currentPage += 1
        // 데이터 받아오기
        fetchHospitalInfo()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // 데이터를 받기시작하면서 인디게이터 추가
            homeView.homeTableView.tableFooterView = IndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        }
    }
}

...

private func refreshHospitalInfo(_ filteredData: [Document]) {
    searchResultData = filteredData
    if searchResultData.count < 6 {
        nextPage()
    }
    DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        // 테이블뷰를 리로드하여 받아온 데이터를 테이블셀에 추가
        homeView.homeTableView.reloadData()
        refreshControl.endRefreshing()
        // 데이터를 받았으니 다음 데이터를 받을 수 있다는 뜻
        isPaging = true
        // 인디게이터 삭제
        homeView.homeTableView.tableFooterView = nil
    }
}
```

<br/>


- <code>isPaging</code>값을 통해서 데이터를 가져오는 데 조금 기다리는 효과를 주었습니다.

```swift
DispatchQueue.global().asyncAfter(deadline: .now() + (isPaging ? 0 : 1)) {
...
}
```


<br/>

</details>

<details>
<summary><h3>StikyHeader 구현</h3></summary>

- 처음에는 검색창과 카테고리 버튼들이 고정으로 보이는 화면이지만
- 스크롤을 내렸을 때 많은 데이터가 보일 수 있도록 카테고리 버튼들은 보이지 않게 구현하였습니다.

```swift
private func updateStikyHeader(_ scrollView: UIScrollView) {
    // 스크롤뷰의 위치를 구하기
    let scrollOffset = scrollView.contentOffset.y
    // 스크롤뷰의 top제약조건을 가져오기
    let scrollY = homeView.topView.constraints[0].constant - scrollOffset
    // 검색창과 버튼들의 고정 최대 높이와 최소 높이를 정하기
    let maxHeight = Constants.View.HomeView.TopView.size.maxHeight
    let minHeight = Constants.View.HomeView.TopView.size.minHeight
    
    // 스크롤뷰의 위치값에 따라서 제약조건을 변경
    let clampedScrollY = min(max(scrollY, minHeight), maxHeight)
    homeView.topView.constraints[0].constant = clampedScrollY
    
    // 스크롤뷰가 한번에 스크롤되는 것을 방지
    if scrollY > minHeight && scrollY < maxHeight {
        scrollView.contentOffset.y = 0
    }
    
    // 투명도 조절
    let alpha = clampedScrollY / maxHeight
    homeView.cellStackView.alpha = alpha
}
```


<br/>

</details>

<details>
<summary><h3>Custom UIButton 구현</h3></summary>

- 카테고리 버튼이나 즐겨찾기 버튼은 여러 <code>View</code>에서 반복적으로 사용하기 때문에 <code>UIView</code> 및 <code>UIButton</code>파일을 만들어서 재사용하였습니다.

```swift
final class FavoriteButton: UIButton {
    weak var favoriteButtonDelegate: FavoriteButtonDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.isSelected = false
        self.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        changeFavoriteButtonColor()
        
        self.addTarget(self, action: #selector(touchUpFavoriteButton), for: .touchUpInside)
    }
    
    ...
}

```

<br/>

- 즐겨찾기 버튼은 <code>TableViewCell</code>, <code>CollectionViewCell</code>, <code>DetailView</code> 등 다양한 곳에서 사용되기 때문에 클릭되었을 때를 알려주기 위해서 프로토콜을 정의하여 재사용성을 높였습니다.

```swift
// 사용
lazy var favoriteButton = { () -> FavoriteButton in
    let btn = FavoriteButton()
    btn.favoriteButtonDelegate = self
    return btn
}()

protocol FavoriteButtonDelegate: AnyObject {
    func actionFavoriteButton(isSelect: Bool)
}

// RecommendTableViewCell의 FavoriteButtonDelegate
extension RecommendTableViewCell: FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool) {
    ...
}

// FavoriteCollectionViewCell의 FavoriteButtonDelegate
extension FavoriteCollectionViewCell: FavoriteButtonDelegate {
    ...
}

// SearchDetailViewController의 FavoriteButtonDelegate
extension SearchDetailViewController: FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool) {
    ...
}

```


</details>


<br/><br/>

## 📌 개발 도구 및 기술 스택
<img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white"><img src="https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white"><img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=UIKit&logoColor=white">
#### 기술스택
- UIkit
- SnapKit
- Kakao Map API

<br/><br/>
