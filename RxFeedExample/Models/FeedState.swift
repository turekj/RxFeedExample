import RxCocoa
import RxSwift

struct FeedState {
    var items: [FeedItem]
    var nextPage: Int?
    var shouldLoadNext: Bool

    init() {
        self.items = []
        self.nextPage = 1
        self.shouldLoadNext = true
    }

    typealias Feedback = (Driver<FeedState>) -> Signal<FeedMutation>
}

extension FeedState {

    var loadPageIndex: Int? {
        return shouldLoadNext ? nextPage : nil
    }

}

extension FeedState {

    static func reduce(state: FeedState, mutation: FeedMutation) -> FeedState {
        var copy = state

        switch mutation {
        case .loadNextPage:
            copy.shouldLoadNext = true
        case .error:
            copy.shouldLoadNext = false
        case let .pageLoaded(page):
            copy.shouldLoadNext = false
            copy.nextPage = page.nextPageIndex
            copy.items += page.results
        case let .like(id):
            copy.items = copy.items.map { item in
                item.id == id ? item.copy(liked: !item.liked) : item
            }
        case let .drop(id):
            copy.items = copy.items.filter { $0.id != id }
        }

        return copy
    }

}

