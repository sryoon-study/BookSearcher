
import Foundation

struct BookData: Hashable {
    let isbn: String
    let title: String
    let author: String
    let translator: String?
    let thumbnailURL: URL
    let salePrice: String
    let contents: String

    // DTO용 이니셜라이저
    init(from dto: BookDTO) {
        isbn = dto.isbn
        title = dto.title
        author = StringFormatter.formatList(dto.authors)
        translator = StringFormatter.formatList(dto.translators)
        thumbnailURL = URL(string: dto.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
        salePrice = StringFormatter.formatPrice(dto.salePrice)
        contents = dto.contents
    }
    
    // isbn 기준으로 중복값 판정
    func hash(into hasher: inout Hasher) {
        hasher.combine(isbn)
    }
    
    // == 연산은 상황에 따라 판단하고 추가
    static func == (lhs: BookData, rhs: BookData) -> Bool {
        return lhs.isbn == rhs.isbn
    }
}

extension BookData {
    // 코어데이터용 이니셜라이저
    init(from recentBook: RecentBook) {
        isbn = recentBook.isbn
        title = recentBook.title
        author = recentBook.author
        translator = recentBook.translator
        thumbnailURL = URL(string: recentBook.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
        salePrice = recentBook.price
        contents = recentBook.contents
    }
}
