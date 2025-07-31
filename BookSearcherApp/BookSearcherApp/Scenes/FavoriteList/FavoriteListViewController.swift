
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
    
    init(reactor: FavoriteListReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if DEBUG
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            let tmp = CoreDataMaanger.shared.fetchAllFavoriteBooks()
            tmp.forEach { print($0.title) }
        }
    #endif

    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: clearFavoriteButton)
        navigationItem.titleView = favoriteListLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFavoriteButton)
        
        
    }
}
