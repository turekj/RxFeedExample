import RxDataSources

struct FeedItem: IdentifiableType, Equatable {
    let id: Int
    let title: String
    let image: URL
    let author: String
    let whenCreated: String
    let distance: String
    let address: String
    let avatar: URL
    let liked: Bool

    var identity: Int {
        return id
    }

}

extension FeedItem {

    func copy(liked: Bool) -> FeedItem {
        return FeedItem(
            id: id,
            title: title,
            image: image,
            author: author,
            whenCreated: whenCreated,
            distance: distance,
            address: address,
            avatar: avatar,
            liked: liked
        )
    }

}
