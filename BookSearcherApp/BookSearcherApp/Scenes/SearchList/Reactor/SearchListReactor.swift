
import ReactorKit
import RxSwift

final class SearchListReactor: BaseReactor<
    SearchListReactor.Action,
    SearchListReactor.Mutation,
    SearchListReactor.State
> {
    // 사용자 액션 정의 (사용자의 의도)
    enum Action {
        case search(String)
        case registerRecentBook(BookData)
        case reloadRecentBooks
    }

    // 상태변경 이벤트 정의 (상태를 어떻게 바꿀 것인가)
    enum Mutation {
        case setQuery(String)
        case setSearchedBookDatas([BookData])
        case setRecentBooks([RecentBook])
    }

    // View의 상태 정의 (현재 View의 상태값)
    struct State {
        var query: String = ""
        @Pulse var searchedBooks: [BookData] = []
        var RecentBooks: [RecentBook] = []
    }

    // 생성자에서 초기 상태 설정
    init() {
        super.init(initialState: State())
    }

    // Action이 들어왔을 때 어떤 Mutation으로 바뀔지 정의
    // 사용자 입력 → 상태 변화 신호로 변환
    override func mutate(action: Action) -> Observable<Mutation> {
        let dataService = DataService()
        switch action {
        case let .search(query):
            // 입력된 검색어 상태에 전달
            let setQuery = Observable.just(Mutation.setQuery(query))

            // API에서 획득한 dto데이터를 SearchedBookData로 맵핑
            let searchResult = dataService.rx.searchBooks(query: query)
                .map { dto in
                    Mutation.setSearchedBookDatas(dto.documents.map { BookData(from: $0) })
                }
                .catchAndReturn(Mutation.setSearchedBookDatas([])) // 오류시 []을 리턴

            return .concat(setQuery, searchResult)

        case let .registerRecentBook(book):
            CoreDataMaanger.shared.addRecentBook(book: book)
            let books = CoreDataMaanger.shared.fetchAllRecentBooks()
            return .just(.setRecentBooks(books))
            
        case .reloadRecentBooks:
            let books = CoreDataMaanger.shared.fetchAllRecentBooks()
            return .just(.setRecentBooks(books))
        }
    }

    // Mutation이 발생했을 때 상태(State)를 실제로 바꿈
    // 상태 변화 신호 → 실제 상태 반영
    override func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setQuery(query):
            newState.query = query
        case let .setSearchedBookDatas(books):
            newState.searchedBooks = books
        case let .setRecentBooks(books):
            newState.RecentBooks = books
        }
        return newState
    }
    
}
