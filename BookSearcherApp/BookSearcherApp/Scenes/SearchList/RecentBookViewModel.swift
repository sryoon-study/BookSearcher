
import Foundation

struct RecentBookViewModel {
    let title: String
    let thumbnailURL: URL
    
    init(from dto: BookDTO) {
        self.title = dto.title
        self.thumbnailURL = URL(string: dto.thumbnail) ?? URL(string: "https://placehold.co/120x174")!
    }
}
