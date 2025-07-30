
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewController()
    }

    private func setupViewController() {
        // 색상 설정
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel

        // 검색 목록 버튼
        let searchListReactor = SearchListReactor()
        let searchListVC = SearchListViewController(reactor: searchListReactor)
        searchListVC.tabBarItem = UITabBarItem(
            title: "도서 검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )

        // 담은 책 버튼
        let favoriteListReactor = FavoriteListReactor()
        let favoriteListVC = FavoriteListViewController(reactor: favoriteListReactor)
        favoriteListVC.tabBarItem = UITabBarItem(
            title: "담은 책",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )

        // 각 컨트롤러를 UINavigationController로 감싸서 연결
        let searchNav = UINavigationController(rootViewController: searchListVC)
        let favoriteNav = UINavigationController(rootViewController: favoriteListVC)
        viewControllers = [searchNav, favoriteNav]
    }
    
    // 탭바 Appearnce설정
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground() // ← 반투명 배경 (iOS 기본 반투명 효과)

        // 커스텀 색상에 알파값을 줄 수도 있음
//        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.85)

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    // 선택시 애니메이션 효과
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 선택된 item의 index 파악 몇번째 탭인지 알수 없으면 함수 종료
        guard let index = tabBar.items?.firstIndex(of: item) else { return }

        //  "UITabBarButton" 클래스 이름이 포함된 뷰만 필터링
        let tabBarButtons = tabBar.subviews.filter {
            NSStringFromClass(type(of: $0)).contains("UITabBarButton")
        }.sorted { $0.frame.origin.x < $1.frame.origin.x } // tabBar.subviews는 내부 순서가 보장되지 않기 때문에 인덱스 정렬을 보장하려면 명시적으로 x 좌표 기준 정렬이 필요

        // 유효한 범위 안에 있는지 확인, 뷰 갯수와 tabBar.items의 갯수가 안 맞는 경우 앱크래시 방지
        guard tabBarButtons.indices.contains(index) else { return }

        // 탭한 버튼의 UIView를 가져옴
        let tabBarButton = tabBarButtons[index]

        let animation = CABasicAnimation(keyPath: "transform.scale") // 뷰의 스케일 변경 애니메이션 / x,y축 같은 비율로
        animation.fromValue = 0.75 // 시작 크기
        animation.toValue = 1.0 // 최종 크기 1.0 = 원래 크기
        animation.duration = 0.3 // 시간
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut) // 타임곡선
        tabBarButton.layer.add(animation, forKey: nil) // 적용 forKey는 재사용시 설정
    }
}
