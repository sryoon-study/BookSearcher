
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
    
    let deleteRelay = PublishRelay<Int>()
    
    init(reactor: FavoriteListReactor) {
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
    
    // TODO: <Int, data> 안되는데
    func makeDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let favoriteBookCell = UICollectionView.CellRegistration<FavoriteBookCell, FavoriteBook> { cell, indexPath, bookdata in
            cell.configure(
                title: bookdata.title,
                author: bookdata.author,
                salePrice: bookdata.price,
                thumbnailURL: URL(string: bookdata.thumbnail)!
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
                UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completion in
                    self.deleteRelay.accept(indexPath.item)
                    completion(true)
                })
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
        
        rx.viewWillAppear.map { _ in .reloadFavoriteBooks }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        clearFavoriteButton.rx.tap
            .map { _ in .clearFavoriteBooks }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.books }
            .bind { [weak collectionViewDataSource] favoriteBooks in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapShot.appendSections([.favoriteBooks])
                snapShot.appendItems(favoriteBooks.map { .favoriteBooks($0) }, toSection: .favoriteBooks)
                collectionViewDataSource?.apply(snapShot)
            }
            .disposed(by: disposeBag)
        
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
