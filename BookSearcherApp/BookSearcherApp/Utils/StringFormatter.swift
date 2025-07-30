
enum StringFormatter {
    // 배열로 온 작가/전역가 이름 변환 함수
    static func formatList(_ names: [String]) -> String {
        guard let first = names.first else { return "" }
        let count = names.count

        return count > 1 ? "\(first) 외 \(count - 1)명" : first
    }

    static func formatPrice(_ price: Int) -> String {
        if price > 0 {
            return "\(price.formatted(.number))원"
        } else {
            return "품절"
        }
    }
}
