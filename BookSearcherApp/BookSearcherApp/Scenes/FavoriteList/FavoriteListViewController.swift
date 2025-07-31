
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class FavoriteListViewController: BaseViewController<FavoriteListReactor> {
    init(reactor: FavoriteListReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if DEBUG
    override func viewDidLoad() {
        super.viewDidLoad()
        let tmp = CoreDataMaanger.shared.fetchAllFavoriteBooks()
        tmp.forEach { print($0.title) }
    }
    #endif
    
    override func setupUI() {
        view.backgroundColor = .systemOrange
    }
}
