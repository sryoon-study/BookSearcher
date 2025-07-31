
import UIKit

extension UIButton.Configuration {
    
    // 닫기 버튼 컨피그
    static var closed: UIButton.Configuration {
        var config = filled()
        config.title = "닫기"
        config.baseBackgroundColor = .systemGray2
        config.titleTextAttributesTransformer = .init { attr in
            var newAttr = attr
            newAttr.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            newAttr.foregroundColor = .systemBackground
            return newAttr
        }
        return config
    }
    
    // 즐겨찾기 추가 버튼 컨피그
    static var favoriteAdd: UIButton.Configuration {
        var config = filled()
        config.title = "즐겨찾기 추가"
        config.baseBackgroundColor = .systemBlue
        config.titleTextAttributesTransformer = .init { attr in
            var newAttr = attr
            newAttr.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            newAttr.foregroundColor = .systemBackground
            return newAttr
        }
        return config
    }
    
    // 즐겨찾기 제거 버튼 컨피그
    static var favoriteRemove: UIButton.Configuration {
        var config = filled()
        config.title = "즐겨찾기 제거"
        config.baseBackgroundColor = .systemRed
        config.titleTextAttributesTransformer = .init { attr in
            var newAttr = attr
            newAttr.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            newAttr.foregroundColor = .systemBackground
            return newAttr
        }
        return config
    }
}
