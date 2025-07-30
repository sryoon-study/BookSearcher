
import Foundation

struct RecentBookData {
    let title: String
    let thumbnailURL: URL

    init(from bookdata: RecentBook) {
        title = bookdata.title
        thumbnailURL = URL(string: bookdata.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
    }
}

struct SearchedBookData {
    let title: String
    let thumbnailURL: URL
    let author: String
    let salePrice: String

    init(from dto: BookDTO) {
        title = dto.title
        thumbnailURL = URL(string: dto.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
        author = StringFormatter.formatList(dto.authors)
        salePrice = StringFormatter.formatPrice(dto.salePrice)
    }
}
