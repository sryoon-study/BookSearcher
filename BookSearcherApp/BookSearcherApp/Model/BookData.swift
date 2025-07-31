
import Foundation

struct RecentBookData: Hashable {
    let isbn: String
    let title: String
    let thumbnailURL: URL

    init(from bookdata: RecentBook) {
        isbn = bookdata.isbn
        title = bookdata.title
        thumbnailURL = URL(string: bookdata.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
    }
}

struct SearchedBookData: Hashable {
    let isbn: String
    let title: String
    let author: String
    let translator: String?
    let thumbnailURL: URL
    let salePrice: String
    let contents: String

    init(from dto: BookDTO) {
        isbn = dto.isbn
        title = dto.title
        author = StringFormatter.formatList(dto.authors)
        translator = StringFormatter.formatList(dto.translators)
        thumbnailURL = URL(string: dto.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
        salePrice = StringFormatter.formatPrice(dto.salePrice)
        contents = dto.contents
    }
}
