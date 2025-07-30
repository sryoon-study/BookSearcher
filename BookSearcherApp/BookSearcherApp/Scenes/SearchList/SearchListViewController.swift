
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
#endif
    
    private let searchBar = UISearchBar().then {
        $0.barStyle = .default
        $0.placeholder = "Search"
    }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    lazy var collectionViewDataSource = makeDataSource(collectionView)
    
    init(reactor: SearchListReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        collectionView.register(SearchListSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let recentBookCellRegistration = UICollectionView.CellRegistration<RecentBookCell, DummyRecentBook> { cell, _, bookData in
            cell.configure(title: bookData.title, thumbnailURL: bookData.thumbnailURL)
        }
        
        let searchedBookCellRegistration = UICollectionView.CellRegistration<SearchedBookCell, SearchedBookData> { cell, _, bookData in
            cell.configure(title: bookData.title, author: bookData.author , salePrice: bookData.salePrice, thumbnailURL: bookData.thumbnailURL)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .recentBook(bookData):
                collectionView.dequeueConfiguredReusableCell(using: recentBookCellRegistration, for: indexPath, item: bookData)
            case let .searchedBook(bookData):
                collectionView.dequeueConfiguredReusableCell(using: searchedBookCellRegistration, for: indexPath, item: bookData)
            }
        }
        
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
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
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
                        widthDimension: .absolute(35),
                        heightDimension: .absolute(50)
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
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
                
            }
            
            
        }
    }
    
    override func bind(reactor: SearchListReactor) {
        // 1. 사용자의 입력을 Action으로 바인딩
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { SearchListReactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //  2. 상태를 UI로 바인딩
        reactor.state.map { $0.query }
            .distinctUntilChanged()
            .bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
        
        // combineLatest
        reactor.pulse{ $0.$searchedBooks }
            .bind{ [weak collectionViewDataSource ] searchedBooks in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapShot.appendSections( [.searchedBook] )
                snapShot.appendItems( searchedBooks.map { .searchedBook($0) }, toSection: .searchedBook )
                collectionViewDataSource?.apply(snapShot)
            }
            .disposed(by: disposeBag)
    }
    
    enum Section {
        case recentBook
        case searchedBook
    }
    
    enum Item: Hashable {
        case recentBook(DummyRecentBook)
        case searchedBook(SearchedBookData)
    }
}
