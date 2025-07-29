
import Foundation

struct BookResponseDTO: Codable {
    let documents: [BookDTO]
    let meta: MetaDTO
}

struct BookDTO: Codable {
    let authors: [String]
    let contents: String
    let datetime: String
    let isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher, status, thumbnail, title, translators, url
        case salePrice = "sale_price"
    }
}

struct MetaDTO: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
