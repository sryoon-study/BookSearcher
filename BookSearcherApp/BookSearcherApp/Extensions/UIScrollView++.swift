
import RxCocoa
import RxSwift
import UIKit

// 스크롤뷰 최하단 감지
extension Reactive where Base: UIScrollView {
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset
            .asObservable()
            .withUnretained(base)
            .filter { base, contentOffset in
                MainActor.assumeIsolated {
                    let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
                    let y = contentOffset.y + base.contentInset.top
                    let threshold = max(offset, base.contentSize.height - visibleHeight)
                    return y >= threshold
                }
            }
            .map { _ in }
        return ControlEvent(events: source)
    }
}
