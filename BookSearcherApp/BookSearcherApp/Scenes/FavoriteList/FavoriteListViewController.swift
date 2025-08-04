
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class FavoriteListViewController: BaseViewController<FavoriteListReactor> {
    // 전체 삭제 버튼
    private let clearFavoriteButton = UIButton(configuration: .clearFavorite)

    // 타이틀
    private let favoriteListLabel = UILabel().then {
        $0.text = "담은 책 리스트"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }

    // 추가 버튼
    private let addFavoriteButton = UIButton(configuration: .addFavorite)

    // 컬렉션뷰 요소
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )

    // 컬렉션뷰 데이터 소스
    lazy var collectionViewDataSource = makeDataSource(collectionView)

    private let searchController = UISearchController() // 서치 컨트롤러

    let deleteRelay = PublishRelay<Int>() // 삭제에서 쓰는 릴레이

    let focusSearchBarRelay: PublishRelay<Void> // 검색바 포커싱 릴레이

    init(reactor: FavoriteListReactor, relay: PublishRelay<Void>) {
        focusSearchBarRelay = relay
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 최초 구성
    override func setupUI() {
        view.backgroundColor = .systemBackground

        // 뷰 주입
        view.addSubview(collectionView)

        // 오토 레이아웃
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }

        // 네비게이션 아이템 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: clearFavoriteButton)
        navigationItem.titleView = favoriteListLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFavoriteButton)
    }

    // TODO: <Int, data>로 변경
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        // 셀 정의
        let favoriteBookCell = UICollectionView.CellRegistration<FavoriteBookCell, FavoriteBook> { cell, _, bookData in
            cell.configure(
                title: bookData.title,
                author: bookData.author,
                salePrice: bookData.price,
                thumbnailURL: URL(string: bookData.thumbnail)!
            )
        }
        // 데이터소스 정의
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .favoriteBooks(bookdata):
                collectionView.dequeueConfiguredReusableCell(using: favoriteBookCell, for: indexPath, item: bookdata)
            }
        }
        return dataSource
    }

    func makeLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain) // 리스트형 레이아웃
        configuration.showsSeparators = false

        // 삭제 기능 설정
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
                self?.deleteRelay.accept(indexPath.item) // 릴레이에 indexPath 전달
                completion(true)
            }

            deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal) // SF Symbol 아이콘 추가, 색 설정
            deleteAction.backgroundColor = .systemBackground // 배경색 변경

            let config = UISwipeActionsConfiguration(actions: [deleteAction])
            config.performsFirstActionWithFullSwipe = false // 스와이프만으로 삭제 방지
            return config
        }

        return UICollectionViewCompositionalLayout { _, environment in
            NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment).then { section in
                section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
                section.interGroupSpacing = 20
            }
        }
    }

    override func bind(reactor: FavoriteListReactor) {
        // 뷰 등장시 담은 책 목록 리로드
        rx.viewWillAppear.map { _ in .reloadFavoriteBooks }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 전부 삭제 버튼
        clearFavoriteButton.rx.tap
            .map { _ in .clearFavoriteBooks }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 추가 버튼
        addFavoriteButton.rx.tap
            .bind(to: focusSearchBarRelay)
            .disposed(by: disposeBag)

        // state 변동에 따른 스냅샷 apply
        reactor.state.map { $0.books }
            .bind { [weak collectionViewDataSource] favoriteBooks in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapShot.appendSections([.favoriteBooks])
                snapShot.appendItems(favoriteBooks.map { .favoriteBooks($0) }, toSection: .favoriteBooks)
                collectionViewDataSource?.apply(snapShot)
            }
            .disposed(by: disposeBag)

        //  삭제 릴레이
        deleteRelay.map { .deleteFavoriteBook($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    // 섹션
    enum Section {
        case favoriteBooks
    }

    // 아이템
    enum Item: Hashable {
        case favoriteBooks(FavoriteBook)
    }
}
