# BookSearcher
과제 페이지 : https://teamsparta.notion.site/Ch-3-Advance-2352dc3ef51480a192daf65bb3d7c487

# 기술 스택
- **Architecture**: MVVM + ReactorKit
- **Reactive**: RxSwift, RxCocoa
- **UI**: UIKit + SnapKit + Then
- **Data Persistence**: CoreData
- **Image**: Kingfisher
- **Network**: Alamofire

# 폴더링
```
📁 BookSearcherApp/
├── App/                     # 앱 진입점 (AppDelegate, SceneDelegate)
├── Base/                    # BaseViewController, BaseReactor 추상 레이어
├── Extensions/              # UIKit 및 Rx 확장 유틸
├── Model/
│   ├── CoreData/            # CoreData 관련 모델 및 매니저
│   ├── BookData.swift       # 도메인 모델
│   └── BookResponseDTO.swift # API DTO 구조
├── Resources/               # (앱 리소스)
├── Scenes/
│   ├── BookDetail/          # 상세 화면
│   ├── FavoriteList/        # 담은 책 화면
│   ├── SearchList/          # 검색 화면
│   └── TabBar/              # 탭바 컨트롤러
├── Utils/                   # API통신, 스트링 포맷터, 시크릿 키 관리
└── README.md                # 프로젝트 설명 파일
```


## 🚀 주요 기능

- 도서 검색 및 무한 스크롤
- 최근 본 책 (최대 10권)
- 책 즐겨찾기 저장 및 삭제
- 상세 정보 모달 표시 (모서리 둥근 시트)
- 탭바를 통한 화면 이동
- CoreData 기반 데이터 유지
- 검색 → 탭 이동 및 포커스 자동 처리

---

## 📝 기타

- `Secrets.plist` 파일을 통해 Kakao API Key 관리
- 중복 삭제 방지 처리 및 Empty 상태 처리
