
import UIKit

import SnapKit
import Then

final class SearchListSectionHeaderView: UICollectionReusableView {
    static let identifier: String = "SearchListSectionHeaderView" // 헤더뷰 이름

    // 제목
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
        $0.backgroundColor = .systemBackground.withAlphaComponent(0.85)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 뷰 주입
        addSubview(titleLabel)

        // 오토 레이아웃
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
