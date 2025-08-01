
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchListViewController: BaseViewController<SearchListReactor> {
#if DEBUG
    struct DummyRecentBook: Hashable {
        let title: String
        let thumbnailURL: URL
    }
    
    private let dummyRecentBook = [
        DummyRecentBook(
            title: "86 에이티식스 7",
            thumbnailURL: URL(string: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6266754%3Ftimestamp%3D20250320155135")!
        ),
        DummyRecentBook(
            title: "86 에이티식스 10",
            thumbnailURL: URL(string: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6397573%3Ftimestamp%3D20250716143638")!
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmp = CoreDataMaanger.shared.fetchAllRecentBooks()
        for item in tmp {
            print(item.title)
        }
    }
#endif
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    lazy var collectionViewDataSource = makeDataSource(collectionView)
    
    private let searchController = UISearchController()
    
    let searchObservable: Observable<Void> // 검색바 포커싱용 옵저버블
    
    init(reactor: SearchListReactor, relay: Observable<Void>) {
        self.searchObservable = relay
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView) // 첫번째가 스크롤바가 있어야 네비게이션 / 탭바 어피어런스가 적용
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = .label
        navigationItem.searchController?.searchBar.setValue("취소", forKey: "cancelButtonText")
        collectionView.register(SearchListSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        // 셀 정의
        let recentBookCellRegistration = UICollectionView.CellRegistration<RecentBookCell, DummyRecentBook> { cell, _, bookData in
            cell.configure(title: bookData.title, thumbnailURL: bookData.thumbnailURL)
        }
        
        let searchedBookCellRegistration = UICollectionView.CellRegistration<SearchedBookCell, SearchedBookData> { cell, _, bookData in
            cell.configure(title: bookData.title, author: bookData.author, salePrice: bookData.salePrice, thumbnailURL: bookData.thumbnailURL)
        }
        
        // 어떤 데이터를 넣을 것인지
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .recentBook(bookData):
                collectionView.dequeueConfiguredReusableCell(using: recentBookCellRegistration, for: indexPath, item: bookData)
            case let .searchedBook(bookData):
                collectionView.dequeueConfiguredReusableCell(using: searchedBookCellRegistration, for: indexPath, item: bookData)
            }
        }
        
        // 섹션헤더의 데이터 설정
        dataSource.supplementaryViewProvider = { [weak dataSource] collectionView, kind, indexPath in
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else { return nil }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! SearchListSectionHeaderView
            switch section {
            case .recentBook:
                headerView.titleLabel.text = "최근 본 책"
            case .searchedBook:
                headerView.titleLabel.text = "검색 결과"
            }
            
            return headerView
        }
        return dataSource
    }
    
    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = self?.collectionViewDataSource.sectionIdentifier(for: sectionIndex) else { return nil }
            
            switch section {
            case .recentBook:
                let layoutItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let layoutGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(59),
                        heightDimension: .absolute(85)
                    ),
                    subitems: [layoutItem]
                )
                // boundaryItem 섹션마다 붙는 것
                let boundaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(50)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top // 셀보다 위로
                )
                
                let section = NSCollectionLayoutSection(group: layoutGroup)
                section.boundarySupplementaryItems = [boundaryItem]
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
                
            case .searchedBook:
                let layoutItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let layoutGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(85)
                    ),
                    subitems: [layoutItem]
                )
                // boundaryItem 섹션마다 붙는 것
                let boundaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(50)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top // 셀보다 위로
                )
                
                boundaryItem.pinToVisibleBounds = true
                
                let section = NSCollectionLayoutSection(group: layoutGroup)
                section.boundarySupplementaryItems = [boundaryItem]
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
                return section
            }
        }
    }
    
    override func bind(reactor: SearchListReactor) {
        // 1. 사용자의 입력을 Action으로 바인딩
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { SearchListReactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 선택한 셀의 book데이터를 획득 withUnretained를 써서 약한 참조
        let selectedBook = collectionView.rx.itemSelected
            .withUnretained(collectionViewDataSource)
            .compactMap { dataSoruce, indexPath in // nullalbe처리용 compactMap
                dataSoruce.itemIdentifier(for: indexPath)
            }
            .compactMap { item in
                if case let .searchedBook(book) = item { // 패턴 매칭 searchedBook일 때만 SearchedBookData를 꺼내서 반환
                    return book
                }
                return nil
            }
            .share() // selectedBook을 구독하는 모든 옵저버에게 이벤트 공유, 없으면 구독할 때마다 이 옵저버블을 새롭게 만든다. 여기서는 share를 안하면 2번 타게 됨
        
        // 모달 연결
        selectedBook
            .bind { [weak self] book in
                let reactor = BookDetailReactor(book: book)
                let detailVC = BookDetailViewController(reactor: reactor)
                detailVC.modalPresentationStyle = .pageSheet
                detailVC.modalTransitionStyle = .coverVertical
                
                if let sheet = detailVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()] // 사용할 수 있는 크기 모드
                    sheet.selectedDetentIdentifier = .large // 첫 출력 높이
                    sheet.prefersGrabberVisible = true // 상단 당김바
                    sheet.preferredCornerRadius = 20
                }
                self?.present(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 코어데이터 등록 액션
        selectedBook
            .map { .registerRecentBook($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //  2. 상태를 UI로 바인딩
        reactor.state.map { $0.query }
            .distinctUntilChanged()
            .bind(to: searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        // TODO: 최근본책과 합치기
        // combineLatest
        reactor.pulse { $0.$searchedBooks }
            .bind { [weak collectionViewDataSource] searchedBooks in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapShot.appendSections([.searchedBook])
                snapShot.appendItems(searchedBooks.map { .searchedBook($0) }, toSection: .searchedBook)
                collectionViewDataSource?.apply(snapShot)
            }
            .disposed(by: disposeBag)
        
        searchObservable
            .do(onNext: { [weak self] in
                self?.tabBarController?.selectedIndex = 0
            })
//            .delay(.milliseconds(5), scheduler: MainScheduler.instance) // 명시적으로 딜레이
            .observe(on: MainScheduler.asyncInstance) //DispatchQueue  다음 사이클로 넘기는 것
            .bind { [weak self] in
                self?.searchController.searchBar.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
    }
    
    // 섹션
    enum Section {
        case recentBook
        case searchedBook
    }
    
    // 컬렉션 뷰에 넣을 아이템
    enum Item: Hashable {
        case recentBook(DummyRecentBook)
        case searchedBook(SearchedBookData)
    }
}
