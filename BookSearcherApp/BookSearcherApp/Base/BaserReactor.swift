
import ReactorKit
import RxSwift

class BaserReactor<Action, Mutation, State>: Reactor {
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        fatalError("muatate(action:) must be overridden")
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        fatalError("reduce(state:mutation:) must be overridden")
    }
}
