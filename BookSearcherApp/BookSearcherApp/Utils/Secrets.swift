
import Foundation

enum Secrets {
    static var apiKey: String {
        return value(forKey: "API_KEY")
    }

    private static func value(forKey key: String) -> String {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let value = dict[key] as? String
        else {
            fatalError("Secrets.plist 또는 \(key) 값이 누락되었습니다.")
        }
        return value
    }
}
