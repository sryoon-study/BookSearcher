
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchListViewController: BaseViewController<SearchListReactor> {
    private let dummyRelay = PublishRelay<[SearchedBookViewModel]>()

    private let searchBar = UISearchBar().then {
        $0.barStyle = .default
        $0.placeholder = "Search"
    }

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

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
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

        reactor.state
            .map { $0.books.map(SearchedBookViewModel.init) } // DTO → ViewModel
            .observe(on: MainScheduler.instance)
            .bind(to: dummyRelay) // DiffableDataSource에 연결하거나 reloadData
            .disposed(by: disposeBag)
    }
}
