
import ReactorKit
import RxSwift

final class SearchListReactor: BaseReactor<
    SearchListReactor.Action,
    SearchListReactor.Mutation,
    SearchListReactor.State
> {
    // 사용자 액션 정의 (사용자의 의도)
    enum Action {
        case search(String) // 검색
        case registerRecentBook(BookData) // 최근 본 책 등록
        case reloadRecentBooks // 최근 본 책 리로드
        case loadNextPage // 다음 페이지 로드
    }

    // 상태변경 이벤트 정의 (상태를 어떻게 바꿀 것인가)
    enum Mutation {
        case setQuery(String) // 쿼리값 세팅
        case setSearchedBookDatas([BookData], Int) // 검색데이터 세팅 (검색정보, 페이지번호)
        case setRecentBooks([RecentBook]) // 최근 본 책 세팅
        case setIsEnd(Bool) // isEnd 값 세팅
        case setCurrentPage(Int) // 현제 페이지 세팅
        case setIsLoading(Bool) // isLodaing 세팅
        case appendSearchedBookDatas([BookData], Int) // 다음 페이지 검색 내용 append
    }

    // View의 상태 정의 (현재 View의 상태값)
    struct State {
        var query: String = ""
        @Pulse var searchedBooks: [BookData] = []
        var recentBooks: [BookData] = []
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
                .catch { _ in
                    Observable.of(
                        .setSearchedBookDatas([], 1), // 오류시 []을 리턴
                        .setIsEnd(true)
                    )
                }

            return .concat(setQuery, .just(.setIsLoading(true)), searchResult, .just(.setIsLoading(false)))

        case .loadNextPage:
            // 화면 끝이거나 / 로딩 중이거나 / 쿼리가 없을 때는 진입하지 못하게 막음
            guard !currentState.isEnd,
                  !currentState.isLoading,
                  !currentState.query.isEmpty
            else { return .empty() }

            let newPage = currentState.currentPage + 1 // 현재 페이지 번호 +1
            let searchResult = dataService.rx.searchBooks(query: currentState.query, page: newPage)
                .flatMap { dto in
                    Observable<Mutation>.of(
                        .appendSearchedBookDatas(dto.documents.map { BookData(from: $0) }, newPage),
                        .setIsEnd(dto.meta.isEnd)
                    )
                } // 다음 페이지 값으로 넘겨 API통신

            return .concat(.just(.setIsLoading(true)), searchResult, .just(.setIsLoading(false)))

        case let .registerRecentBook(book):
            CoreDataManger.shared.addRecentBook(book: book)
            let books = CoreDataManger.shared.fetchAllRecentBooks()
            return .just(.setRecentBooks(books))

        case .reloadRecentBooks:
            let books = CoreDataManger.shared.fetchAllRecentBooks()
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
            newState.recentBooks = books.map { BookData(from: $0) }
        case let .setIsEnd(isEnd):
            newState.isEnd = isEnd
        case let .setCurrentPage(currentPage):
            newState.currentPage = currentPage
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        case let .appendSearchedBookDatas(books, pageNum):
            newState.searchedBooks.append(contentsOf: books)
            newState.currentPage = pageNum
        }
        return newState
    }
}
