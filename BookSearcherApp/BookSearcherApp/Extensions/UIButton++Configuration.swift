
import UIKit

extension UIButton.Configuration {
    // MARK: 책 상세 화면
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
        config.title = "책 담기"
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
        config.title = "담은 책 제거"
        config.baseBackgroundColor = .systemRed
        config.titleTextAttributesTransformer = .init { attr in
            var newAttr = attr
            newAttr.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            newAttr.foregroundColor = .systemBackground
            return newAttr
        }
        return config
    }
    
    // MARK: 담은 책 화면
    
    static var clearFavorite: UIButton.Configuration {
        var config = plain()
        config.title = "전체 삭제"
        config.baseForegroundColor = .systemGray
        config.titleTextAttributesTransformer = .init { attr in
            var newAttr = attr
            newAttr.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            return newAttr
        }
        return config
    }
    
    static var addFavorite: UIButton.Configuration {
        var config = plain()
        config.title = "추가"
        config.baseForegroundColor = .systemBlue
        config.titleTextAttributesTransformer = .init { attr in
            var newAttr = attr
            newAttr.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            return newAttr
        }
        return config
    }
}
