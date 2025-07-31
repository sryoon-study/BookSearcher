
import ReactorKit
import RxSwift

final class BookDetailReactor: BaseReactor<
    BookDetailReactor.Action,
    BookDetailReactor.Mutation,
    BookDetailReactor.State
> {
    // 사용자 액션 정의 (사용자의 의도)
    enum Action {
        case toggleFavorite
    }

    // 상태변경 이벤트 정의 (상태를 어떻게 바꿀 것인가)
    enum Mutation {
        case setFavorite(Bool)
    }

    // View의 상태 정의 (현재 View의 상태값)
    struct State {
        let book: SearchedBookData
        var isFavorite: Bool
    }

    // 생성자에서 초기 상태 설정
    init(book: SearchedBookData) {
        let isFavorite: Bool = CoreDataMaanger.shared.fetchOneFavoriteBook(isbn: book.isbn) != nil
        super.init(initialState: State(book: book, isFavorite: isFavorite))
    }

    // Action이 들어왔을 때 어떤 Mutation으로 바뀔지 정의
    // 사용자 입력 → 상태 변화 신호로 변환
    override func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleFavorite:
            let book = currentState.book
            let isCurrentFavorite = currentState.isFavorite

            if isCurrentFavorite { // 현재 즐겨찾기 상태면 -> 삭제
                CoreDataMaanger.shared.deleteOneFavoriteBook(isbn: book.isbn)
            } else { // 즐겨찾기 상태가 아니면 -> 추가
                CoreDataMaanger.shared.createFavoriteBook(book: book)
            }
            return .just(.setFavorite(!isCurrentFavorite)) // Bool값을 반전시켜서 리턴
        }
    }

    // Mutation이 발생했을 때 상태(State)를 실제로 바꿈
    // 상태 변화 신호 → 실제 상태 반영
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFavorite(isFavorite):
            newState.isFavorite = isFavorite
        }
        return newState
    }
}
