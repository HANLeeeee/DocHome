# DocHome
> 2022.08.14 ~ 2022.08.28 (2주간)  <br/>  <br/>

### Refactoring
> 2023.05.05 ~ 진행중 <br/>

<img width="1613" alt="image" src="https://github.com/HANLeeeee/DocHome/assets/74815957/b18706c6-19a6-4ed2-95ae-53ea36c0811a">


<br />


<br/><br/>
## 📌 How To
- Simulator를 사용하는 경우 [설정 -> 일반 -> 언어 및 지역] 에서 지역을 대한민국으로 변경
- 검색을 클릭하여 원하는 병원명 검색


## 📌 Project Goal
- Snapkit을 사용하여 Code Base를 기반으로 UI 구현 <br/>
- KakaoMap API에서 Map 데이터 받아와서 구현<br/>
- 무한 스크롤을 통한 데이터 추가



<br/><br/>
## 📌 Service Function
- 주변 병원 조회
- 병원 검색
- 병원 위치 조회 및 정보 확인
- 즐겨찾기 



<br/><br/>
## 📌 What I Do
### SnapKit 라이브러리 사용

- 스토리보드를 사용하지 않고 Code Base를 기반으로 AutoLayout 구현하였다.
- 스토리보드는 직관적이고 빠르게 UI 확인이 가능하지만 화면 로딩이 오래걸린다는 단점을 가지고 있다.
- 코드베이스는 로딩이 빠르고 재사용과 유지보수가 쉽게 가능하다.
- SnapKit 라이브러리를 사용하여 더 쉽고 빠르게 AutoLayout을 구현할 수 있었다.

```swift
func makeConstraints() {
  topView.snp.makeConstraints { make in
    make.top.equalTo(self.safeAreaLayoutGuide)
    make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
    make.height.equalTo(Constants.View.HomeView.TopView.size.maxHeight)
  ...
}
```

<br/>

### 모델/네트워크 타입 구현

- API서버와 HTTP 네트워크를 진행하기 위해서 <code>enum</code> 열거형으로 <code>case</code>를 통해 조건에 맞는 요소들을 추가하였다.
- 새로운 Request를 추가할 경우에도 <code>case</code>를 추가하여 확장이 편리하도록 만들었다.

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

### DelegatePattern 구현

- 검색화면에서 <code>present</code>나 <code>push</code>를 이용하여 화면 전환을 하면 메인 네비게이션과 연결되지 않아 <code>DelegatePattern</code>을 사용했다.
- 프로토콜을 정의하여 검색화면으로 전화하고 싶을 경우에 사용한다.
- 이렇게 수정하여 코드의 중복을 줄이고 화면의 재사용을 높여주었다.

```swift
protocol FavoriteTableViewCellDelegate {
    func getCollectionViewIndex(index: Int)
}

extension HomeViewController: FavoriteTableViewCellDelegate {
    func getCollectionViewIndex(index: Int) {
        let favoriteDocument = favoriteSearchResultDatas[index]
        goSearchDetailVC(data: favoriteDocument)
    }
}
```


<br/>

### 페이징과 무한 스크롤 구현

- 한 번 API를 호출하면 10개의 데이터를 가져오고 스크롤을 할 때마다 10개의 데이터를 추가한다.
- <code>TableView</code>에서 가장 밑으로 내렸을 때 <code>Indicator</code> 가 나타나면서 데이터가 추가되고 추가가 완료되면 <code>Indicator</code>는 없어진다.

```swift
//스크롤을 가장 밑으로 내렸을 때
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollOffset = scrollView.contentOffset.y
    if scrollOffset > scrollView.contentSize.height-scrollView.frame.size.height+100 {
        //다음 데이터 추가하기
        nextPage()
    }
}

func nextPage() {
		//받아온 데이터가 마지막인지 확인
    guard let isEndPaging = metaData?.isEnd else { return }
		//isPaging은 다음 데이터를 받을 지의 유무를 저장한 변수
    if isPaging && !isEndPaging {
        isPaging = false
        currentPage += 1
				//데이터 받아오기
        fetchHospitalInfo()
        
        DispatchQueue.main.async { [self] in
						//데이터를 받기시작하면서 인디게이터 추가
            homeView.homeTableView.tableFooterView = IndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        }
    }
}

...

func refreshHospitalInfo(_ filteredData: [Document]) {
    searchResultData = filteredData

    DispatchQueue.main.async { [self] in
				//테이블뷰를 리로드하여 받아온 데이터를 테이블셀에 추가
        homeView.homeTableView.reloadData()
        //데이터를 받았으니 다음 데이터를 받을 수 있다는 뜻
        self.isPaging = true
				//인디게이터 삭제
        homeView.homeTableView.tableFooterView = nil
    }
}
```
<br/>

- <code>isPaging</code>값을 통해서 데이터를 가져오는 데 조금 기다리는 효과를 주었다.
```swift
DispatchQueue.global().asyncAfter(deadline: .now() + (isPaging ? 0 : 1)) {
...
}
```

<details>
<summary>페이징과 무한 스크롤 구현 영상</summary>
<div markdown="1">

https://github.com/HANLeeeee/DocHome/assets/74815957/d3edb160-c764-4fe4-933c-b432ca3a9713

</div>
</details>


<br/><br/>

### StikyHeader 구현

- 처음에는 검색창과 카테고리 버튼들이 고정으로 보이는 화면이다.
- 스크롤을 내렸을 때 많은 데이터가 보일 수 있도록 카테고리 버튼들은 보이지 않게 구현하였다.

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
		//스크롤뷰의 위치를 구하기
    let scrollOffset = scrollView.contentOffset.y
		//스크롤뷰의 top제약조건을 가져오기
    let scrollY = homeView.topView.constraints[0].constant - scrollOffset
		//검색창과 버튼들의 고정 최대 높이와 최소 높이를 정하기
    let maxHeight = Constants.View.HomeView.TopView.size.maxHeight
    let minHeight = Constants.View.HomeView.TopView.size.minHeight
    
		//스크롤뷰의 위치값에 따라서 제약조건을 변경
    let clampedScrollY = min(max(scrollY, minHeight), maxHeight)
    homeView.topView.constraints[0].constant = clampedScrollY
    
		//스크롤뷰가 한번에 스크롤되는 것을 방지
    if scrollY > minHeight && scrollY < maxHeight {
         scrollView.contentOffset.y = 0
    }
    //투명도 조절
    let alpha = clampedScrollY / maxHeight
    homeView.cellStackView.alpha = alpha
}
```

<details>
<summary>페이징과 무한 스크롤 구현 영상</summary>
<div markdown="1">

https://github.com/HANLeeeee/DocHome/assets/74815957/c956300b-a4af-4a05-833e-a1fb24aa70ac

</div>
</details>



<br/><br/>

### Custom View 추가 구현

- 카테고리 버튼이나 즐겨찾기 버튼은 여러 <code>View</code>에서 반복적으로 사용하기 때문에 <code>UIView</code>파일을 만들어서 재사용하였다.

```swift
class CategoryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.setTitleColor(.purpleColor, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.purpleColor?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCategoryButtonColor() {
        self.backgroundColor = self.isSelected ? .purpleColor : .white
    }
}

//사용
lazy var categoryCellButton = { () -> CategoryButton in
    let btn = CategoryButton()
    return btn
}()
```

- 즐겨찾기 버튼은 <code>TableViewCell</code>, <code>CollectionViewCell</code>, <code>DetailView</code> 등 다양한 곳에서 사용되기 때문에 클릭되었을 때를 알려주기 위해서 프로토콜을 정의하여 재사용성을 높였다.

```swift
protocol FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool)
}

//RecommendTableViewCell의 FavoriteButtonDelegate
extension RecommendTableViewCell: FavoriteButtonDelegate {
    lazy var favoriteButton = { () -> FavoriteButton in
        let btn = FavoriteButton()
        btn.favoriteButtonDelegate = self
        return btn
    }()

    func actionFavoriteButton(isSelect: Bool) {
    ...
}

//FavoriteCollectionViewCell의 FavoriteButtonDelegate
extension FavoriteCollectionViewCell: FavoriteButtonDelegate {
    ...
}

//SearchDetailViewController의 FavoriteButtonDelegate
extension SearchDetailViewController: FavoriteButtonDelegate {
    func actionFavoriteButton(isSelect: Bool) {
    ...
}

```





<br/><br/>
## 📌 미리보기


https://github.com/HANLeeeee/DocHome/assets/74815957/870432ce-da7b-4ccd-a82d-339176cb57a5





