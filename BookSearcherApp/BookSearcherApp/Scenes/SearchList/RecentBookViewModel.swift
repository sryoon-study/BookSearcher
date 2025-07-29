
import Foundation

struct RecentBookViewModel {
    let title: String
    let thumbnailURL: URL

    init(from dto: BookDTO) {
        title = dto.title
        thumbnailURL = URL(string: dto.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
    }
}
