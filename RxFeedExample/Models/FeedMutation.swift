enum FeedMutation {
    case loadNextPage
    case pageLoaded(page: FeedPage)
    case error
    case like(id: Int)
    case drop(id: Int)
}
