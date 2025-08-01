
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
        case loadNextPage
    }

    // 상태변경 이벤트 정의 (상태를 어떻게 바꿀 것인가)
    enum Mutation {
        case setQuery(String)
        case setSearchedBookDatas([BookData], Int)
        case setRecentBooks([RecentBook])
        case setIsEnd(Bool)
        case setCurrentPage(Int)
        case setIsLoading(Bool)
        case appendSearhedBookDatas([BookData], Int)
    }

    // View의 상태 정의 (현재 View의 상태값)
    struct State {
        var query: String = ""
        @Pulse var searchedBooks: [BookData] = []
        var RecentBooks: [BookData] = []
        var isEnd: Bool = false
        var currentPage: Int = 1
        var isLoading: Bool = false
        
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
            let searchResult = dataService.rx.searchBooks(query: query, page: 1)
                .flatMap { dto in // 복수 개를 맵핑해야하니 flatMap
                    Observable<Mutation>.of(
                        .setSearchedBookDatas(dto.documents.map { BookData(from: $0) }, 1),
                        .setIsEnd(dto.meta.isEnd),
                    )
                }
                .catch{ _ in
                    Observable.of(
                        .setSearchedBookDatas([], 1), // 오류시 []을 리턴
                        .setIsEnd(true)
                    )
                }
            
            return .concat(setQuery, .just(.setIsLoading(true)), searchResult, .just(.setIsLoading(false)))
            
        case .loadNextPage:
            // 끝이거나 로딩중이면 거름
            guard !currentState.isEnd, !currentState.isLoading else { return .empty() }
            
            let newPage = currentState.currentPage + 1
            let searchResult = dataService.rx.searchBooks(query: currentState.query, page: newPage)
                .flatMap { dto in
                    Observable<Mutation>.of(
                        .appendSearhedBookDatas(dto.documents.map { BookData(from: $0) }, newPage),
                        .setIsEnd(dto.meta.isEnd)
                    )
                }
            
            return .concat(.just(.setIsLoading(true)), searchResult, .just(.setIsLoading(false)))

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
        case let .setSearchedBookDatas(books, pageNum):
            newState.searchedBooks = books
            newState.currentPage = pageNum
        case let .setRecentBooks(books):
            newState.RecentBooks = books.map { BookData(from: $0) }
        case let .setIsEnd(isEnd):
            newState.isEnd = isEnd
        case let .setCurrentPage(currentPage):
            newState.currentPage = currentPage
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        case let .appendSearhedBookDatas(books, pageNum):
            newState.searchedBooks.append(contentsOf: books)
            newState.currentPage = pageNum
        }
        return newState
    }
}
