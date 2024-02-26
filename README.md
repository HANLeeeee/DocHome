# DocHome

<br/>

## 📌 프로젝트 소개
> 2022.08.14 ~ 2022.08.28 (2주간)  <br/>
- KakaoMap API를 이용한 나의 병원을 기록하는 APP


<br/><br/>

## 📌 사용 방법
- Simulator를 사용하는 경우 [설정 -> 일반 -> 언어 및 지역] 에서 지역을 대한민국으로 변경
- Podfile 설치
	```bash  
	# Uncomment the next line to define a global platform for your project
	platform :ios, '14.0'
	
	target 'DocHome' do
	  # Comment the next line if you don't want to use dynamic frameworks
	  use_frameworks!
	
	  # Pods for DocHome
	
	  pod 'SnapKit'
	
	end
	```


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
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/8fe01946-33fe-41e8-802d-2882d0e19045" alt="즐겨찾기">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/e675101c-d840-423a-93e9-512b4500f33f" alt="무한스크롤">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/b29440cb-d6eb-46f2-ae76-73aed9b50f0f" alt="카테고리">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/71cea017-f4de-40f3-9a8a-257b1cb1354a" alt="검색/디테일">
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
<summary><h3>모델/네트워크 타입</h3></summary>

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
<summary><h3>Delegate Pattern으로 화면 전환</h3></summary>

- 검색화면에서 <code>present</code>나 <code>push</code>를 이용하여 화면 전환을 하면 메인 네비게이션과 연결되지 않아 <code>Delegate Pattern</code>을 사용했습니다.
- <code>navigationController</code>가 있는 <code>HomeViewController</code>에서 <code>pushViewController</code>를 호출하여 화면 전환을 했습니다.

<br/>

<h4>❌ 네비게이션 연결되지 않은 코드</h4>
- <code>SearchViewController</code>에는 네비게이션이 옵셔널이기 때문에 테이블뷰셀을 클릭했을 때 <code>pushViewController</code>가 실행되지 않는다.

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("테이블뷰 셀 클릭 \(indexPath.row)번째")
    
    let searchDetailVC = SearchDetailViewController(detailData: searchResultData[indexPath.row], index: indexPath.row)
    self.navigationController?.pushViewController(searchDetailVC, animated: true)
}
```

- <code>present</code>를 사용하여 화면 전환을 할 경우에는 화면이 이동되기는 하지만 이 방법도 네비게이션은 연결되어 있지 않다.

```swift
self.present(searchDetailVC, animated: true)
```

<br/>

<h4>🟢 Delegate Pattern 사용한 코드</h4>

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("테이블뷰 셀 클릭 \(indexPath.row)번째")

    searchViewDelegate?.goSearchDetailVC(data: searchResultData[indexPath.row])
    self.dismiss(animated: true)
}

// MARK: - SearchViewDelegate
extension HomeViewController: SearchViewDelegate {
    func goSearchDetailVC(data: Document) {
        ... 
        let searchDetailVC = SearchDetailViewController(detailData: data, index: index)
        self.navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}
```

<br/>

<table align="center">
  <tr>
    <th>❌ <code>push</code></th>
    <th>❌ <code>present</code></th>
    <th>🟢 <code>Delegate</code></th>
  </tr>
  <tr>
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/d5d057d6-3bfc-4ded-94f0-cd40953934a7" alt="push">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/4b04c314-7c01-4e13-a13a-d4912a9b95b4" alt="present">
    <td><img src="https://github.com/HANLeeeee/DocHome/assets/74815957/df87ac8a-9b88-440f-9401-9b4515d57045" alt="Delegate">
  </tr>
</table>


<br/>

</details>


<details>
<summary><h3>Delegate Pattern으로 즐겨찾기 버튼</h3></summary>

- 즐겨찾기 버튼은 여러 <code>View</code>에서 반복적으로 사용하기 때문에 <code>UIButton</code>파일을 만들어서 재사용하였습니다.

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

- 즐겨찾기 버튼은 <code>TableViewCell</code>, <code>CollectionViewCell</code>, <code>DetailView</code> 등 다양한 곳에서 사용되기 때문에 클릭 이벤트를 프로토콜로 정의하여 재사용성을 높였습니다.

```swift
// 사용
private lazy var favoriteButton = { () -> FavoriteButton in
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

<br/>
<h3>즐겨찾기 버튼 구현 화면</h3>

![스크린샷 2024-02-27 06 51 39](https://github.com/HANLeeeee/DocHome/assets/74815957/d97f121b-a4fc-4d88-84cd-bd51d49a2b96)
![스크린샷 2024-02-27 06 51 45](https://github.com/HANLeeeee/DocHome/assets/74815957/63a81d84-49fd-44df-b76c-41e712d95211)



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


<h3>무한 스크롤 영상</h3>

![2024-02-27 06 03 24 resize](https://github.com/HANLeeeee/DocHome/assets/74815957/3871ddb4-47db-4846-a114-68304d7b7ee1)



<br/>

</details>

<details>
<summary><h3>StikyHeader</h3></summary>
	
- 처음에는 검색창과 카테고리 버튼들이 고정으로 보이는 화면이지만
- 스크롤을 내렸을 때 많은 데이터가 보일 수 있도록 검색 버튼과 카테고리 버튼을 보이지 않게 구현하였습니다.

<br/>

![image](https://github.com/HANLeeeee/DocHome/assets/74815957/dcbd5d61-3a6a-41fa-8005-e6e28627eb25)

- <code>TableView</code>가 올라갈 때
  <code>TopView</code>가 올라가면서 점점 흐려지고 <code>HeaderView</code>는 점점 보이기 시작합니다.
- <code>TableView</code>가 내려갈 때 
  <code>TopView</code>가 내려오면서 점점 보이고 <code>HeaderView</code>는 점점 흐려집니다.

<br/>

- <code>Snapkit</code> 라이브러리에서 <code>updateConstraints</code>를 사용하여 <code>TableView</code>의 <code>ScrollView</code> y값에 따라 topAnchor 제약조건을 변경하였습니다.
- <code>ScrollView</code> y값으로 투명도를 계산하여 흐려지게 만들었습니다.


```swift
private func updateStikyHeader(_ scrollView: UIScrollView) {
    let scrollOffset = scrollView.contentOffset.y
    let topAnchor = Constants.View.HomeView.TopView.topAnchor
    let maxHeight = Constants.View.HomeView.TopView.size.maxHeight
    let scrollY = homeView.topView.constraints[0].constant - scrollOffset
    let alpha = min(scrollY, maxHeight) / maxHeight
    
    homeView.topView.snp.updateConstraints { make in
        if scrollOffset <= 0 {
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(topAnchor)
            
            homeView.topView.alpha = 1
            homeView.headerView.isHidden = true
        } else if scrollOffset > 0 && scrollOffset < maxHeight {
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(-scrollOffset + topAnchor)
            
            homeView.topView.alpha = alpha
            homeView.headerView.isHidden = false
            homeView.headerTitleLabel.textColor = .black.withAlphaComponent(1-alpha)
            homeView.headerSearchButton.tintColor = .black.withAlphaComponent(1-alpha)
        } else {
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(-maxHeight + topAnchor)
            
            homeView.topView.alpha = 0
            homeView.headerView.isHidden = false
        }
    }
}
```

<br/>

<h3>Stiky Header 영상</h3>

![2024-02-2706 41 18-ezgif com-video-to-gif-converter](https://github.com/HANLeeeee/DocHome/assets/74815957/1ffd466d-034c-4452-af52-8a1ebffb6ecb)



<br/>

</details>



<br/><br/>

## 📌 개발 도구 및 기술 스택
<img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white"><img src="https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white"><img src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=UIKit&logoColor=white">
#### 기술스택
- UIkit
- SnapKit
- Kakao Map API

<br/><br/>
