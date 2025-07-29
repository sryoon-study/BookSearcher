
import Foundation

import ReactorKit

final class SearchedBookCellReactor: Reactor {
    typealias Action = Never // 셀은 일반적으로 액션이 없음
    typealias Mutation = Never
    
    struct State {
        let title: String
        let thumbnailURL: URL
        let author: String
        let salePrice: Int
    }
    
    let initialState: State
    
    init(title: String, thumbnailURL: URL, author: String, salePrice: Int) {
        self.initialState = State(
            title: title,
            thumbnailURL: thumbnailURL,
            author: author,
            salePrice: salePrice
        )
    }
    
}
