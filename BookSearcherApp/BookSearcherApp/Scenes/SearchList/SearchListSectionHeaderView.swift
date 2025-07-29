
import UIKit

import SnapKit
import Then

final class SearchListSectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
