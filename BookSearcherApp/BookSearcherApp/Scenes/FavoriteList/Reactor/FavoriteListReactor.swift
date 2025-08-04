
import ReactorKit
import RxSwift

final class FavoriteListReactor: BaseReactor<
    FavoriteListReactor.Action,
    FavoriteListReactor.Mutation,
    FavoriteListReactor.State
> {
    // 사용자 액션 정의 (사용자의 의도)
    enum Action {
        case reloadFavoriteBooks // 즐겨찾기 목록 로딩
        case deleteFavoriteBook(FavoriteBook) // 즐겨찾기 1건 삭제
        case clearFavoriteBooks // 즐겨찾기 전부삭제
    }

    // 상태변경 이벤트 정의 (상태를 어떻게 바꿀 것인가)
    enum Mutation {
        case setFavoriteBooks([FavoriteBook]) // 즐겨찾기 세팅 뮤테이션
        case setDeleting(Bool)
    }

    // View의 상태 정의 (현재 View의 상태값)
    struct State {
        var books: [FavoriteBook]
        var isDeleting: Bool = false
    }

    // 생성자에서 초기 상태 설정
    init() {
        let favoriteBooks = CoreDataManger.shared.fetchAllFavoriteBooks()
        super.init(initialState: State(books: favoriteBooks))
    }

    // Action이 들어왔을 때 어떤 Mutation으로 바뀔지 정의
    // 사용자 입력 → 상태 변화 신호로 변환
    override func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .reloadFavoriteBooks:
            let books = CoreDataManger.shared.fetchAllFavoriteBooks()
            return .just(.setFavoriteBooks(books))
        case let .deleteFavoriteBook(book):
            guard !currentState.isDeleting else { return .empty() } // 삭제중이면 접근금지 -> 중복삭제 회피
            CoreDataManger.shared.deleteOneFavoriteBook(isbn: book.isbn)
            let books = CoreDataManger.shared.fetchAllFavoriteBooks()
            return .concat(.just(.setDeleting(true)), .just(.setFavoriteBooks(books)), .just(.setDeleting(false)))
        case .clearFavoriteBooks:
            guard !currentState.isDeleting else { return .empty() } // 삭제중이면 접근금지 -> 중복삭제 회피
            CoreDataManger.shared.deleteAllFavoriteBooks()
            return .concat(.just(.setDeleting(true)), .just(.setFavoriteBooks([])), .just(.setDeleting(false)))
        }
    }

    // Mutation이 발생했을 때 상태(State)를 실제로 바꿈
    // 상태 변화 신호 → 실제 상태 반영
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFavoriteBooks(books):
            newState.books = books
        case let .setDeleting(isDeleting):
            newState.isDeleting = isDeleting
        }
        return newState
    }
}
