
enum StringFormatter {
    // 배열로 온 작가/번역가 이름 변환 함수
    static func formatList(_ names: [String]) -> String {
        guard let first = names.first else { return "" }
        let count = names.count

        return count > 1 ? "\(first) 외 \(count - 1)명" : first
    }

    // 가격 숫자 -> 문자열 포매팅
    static func formatPrice(_ price: Int) -> String {
        if price > 0 {
            return "\(price.formatted(.number))원"
        } else {
            return "품절"
        }
    }
}
