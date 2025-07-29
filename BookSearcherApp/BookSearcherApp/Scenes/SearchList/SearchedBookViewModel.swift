
import Foundation

struct SearchedBookViewModel {
    let title: String
    let thumbnailURL: URL
    let author: String
    let salePrice: String
    
    init(from dto: BookDTO) {
        self.title = dto.title
        self.thumbnailURL = URL(string: dto.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
        self.author = StringFormatter.formatList(dto.authors)
        self.salePrice = StringFormatter.formatPrice(dto.salePrice)
    }
}
