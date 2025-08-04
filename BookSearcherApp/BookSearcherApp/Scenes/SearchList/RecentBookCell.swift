
import UIKit

import Kingfisher
import SnapKit
import Then

final class RecentBookCell: UICollectionViewCell {
    // 썸네일
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }

    // 제목
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 뷰 주입
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)

        // 오토 레이아웃
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 셀 생성
    func configure(title: String, thumbnailURL: URL) {
        titleLabel.text = title
        thumbnailImageView.kf.setImage(with: thumbnailURL)
    }
}
