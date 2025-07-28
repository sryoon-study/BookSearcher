
import ReactorKit
import RxSwift

class BaseReactor<Action, Mutation, State>: Reactor {
    let initialState: State

    init(initialState: State) {
        self.initialState = initialState
    }

    func mutate(action _: Action) -> Observable<Mutation> {
        // Swift에는 abstract가 없어서 추상 메서드를 표현하기 위해 fatalError를 사용
        fatalError("muatate(action:) must be overridden")
    }

    func reduce(state _: State, mutation _: Mutation) -> State {
        fatalError("reduce(state:mutation:) must be overridden")
    }
}
