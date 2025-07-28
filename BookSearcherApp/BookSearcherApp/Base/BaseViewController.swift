
import UIKit

import ReactorKit
import RxSwift

// 모든 VC의 부모
class BaseViewController<R: Reactor>: UIViewController, View {
    // 모든 VC에 들어가는 것들
    var disposeBag = DisposeBag()
    var reactor: R! // 매번 체크하지 않기 위해 주입후 무조건 있다고 가정

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(reactor: reactor)
    }

    func setupUI() {
        // override에서 UI설정
    }

    func bind(reactor _: R) {
        // 각 VC에서 상태 바인딩 시 override
    }
}
