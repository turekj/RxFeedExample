import Fakery

extension FeedItem {

    static func fake(id: Int, faker: Faker) -> FeedItem {
        let distance = String(format: "%.2f", Double.random(min: 10.0, max: 2500.0))
        let image = faker.lorem.word()
        let userID = Int.random(min: 1, max: 9)

        return FeedItem(
            id: id,
            title: faker.lorem.paragraph(sentencesAmount: Int.random(min: 1, max: 10)),
            image: URL(string: "https://fakeimg.pl/800x800/?text=\(image)")!,
            author: faker.name.name(),
            whenCreated: "\(Int.random(min: 1, max: 20)) days ago",
            distance: "\(distance) km away",
            address: faker.address.streetAddress(includeSecondary: true),
            avatar: URL(string: "https://randomuser.me/api/portraits/lego/\(userID).jpg")!,
            liked: false
        )
    }

}
