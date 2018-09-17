import Fakery
import RxSwift

class FeedProvider {

    init(pageSize: Int) {
        self.pageSize = pageSize
    }

    func fetchPage(atIndex index: Int) -> Single<FeedPage> {
        let page = FeedPage(
            count: pageSize,
            results: generateResults(pageIndex: index),
            nextPageIndex: index + 1,
            previousPageIndex: index > 0 ? index - 1 : nil
        )

        return Single.just(page)
            .delay(Double.random(min: 0.7, max: 2.4), scheduler: MainScheduler.instance)
    }

    // MARK: - Private

    private let pageSize: Int
    private let faker: Faker = Faker(locale: "en-US")

    private func generateResults(pageIndex: Int) -> [FeedItem] {
        let start = (pageIndex - 1) * pageSize
        let end = pageIndex * pageSize
        let factory: (Int) -> FeedItem = { [faker] in .fake(id: $0, faker: faker) }

        return (start..<end).map(factory)
    }

}
