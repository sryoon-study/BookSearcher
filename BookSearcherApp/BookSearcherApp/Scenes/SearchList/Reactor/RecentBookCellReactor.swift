
import Foundation

import ReactorKit

final class RecentBookCellReactor: Reactor {
    typealias Action = Never // 셀은 일반적으로 액션이 없음
    typealias Mutation = Never
    
    struct State {
        let title: String
        let thumbnailURL: URL
    }
    
    let initialState: State
    
    init(title: String, thumbnailURL: URL) {
        self.initialState = State(title: title, thumbnailURL: thumbnailURL)
    }
    
}
