
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class FavoriteListViewController: BaseViewController<FavoriteListReactor> {
    private let clearFavoriteButton = UIButton(configuration: .clearFavorite)

    private let favoriteListLabel = UILabel().then {
        $0.text = "담은 책 리스트"
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }

    private let addFavoriteButton = UIButton(configuration: .addFavorite)

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )

    lazy var collectionViewDataSource = makeDataSource(collectionView)

    private let searchController = UISearchController()

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

    override func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: clearFavoriteButton)
        navigationItem.titleView = favoriteListLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFavoriteButton)
    }

    // TODO: <Int, data>로 변경
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let favoriteBookCell = UICollectionView.CellRegistration<FavoriteBookCell, FavoriteBook> { cell, _, bookData in
            cell.configure(
                title: bookData.title,
                author: bookData.author,
                salePrice: bookData.price,
                thumbnailURL: URL(string: bookData.thumbnail)!
            )
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .favoriteBooks(bookdata):
                collectionView.dequeueConfiguredReusableCell(using: favoriteBookCell, for: indexPath, item: bookdata)
            }
        }
        return dataSource
    }

    func makeLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            UISwipeActionsConfiguration(actions: [
                UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
                    self?.deleteRelay.accept(indexPath.item) // 여기서 삭제를 직접하지 않고 릴레이만 전달
                    completion(true)
                }),
            ])
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

    enum Section {
        case favoriteBooks
    }

    enum Item: Hashable {
        case favoriteBooks(FavoriteBook)
    }
}
