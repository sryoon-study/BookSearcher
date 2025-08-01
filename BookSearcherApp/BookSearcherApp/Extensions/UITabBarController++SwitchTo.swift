
import UIKit

extension UITabBarController {
    
    //T는 UIViewController를 상속한 타입만 받을 수 있게 제한
    func switchTo<T: UIViewController>(viewControllerType: T.Type) {
        // UITabBarController`의 `viewControllers` 배열이 nil일 경우 함수 종료
        guard let viewControllers = viewControllers else { return }
        
        for (index, vc) in viewControllers.enumerated() {
            // 탭에 들어있는 VC가 NavigationController인지 확인
            if let nav = vc as? UINavigationController,
               // NavigationController의 루트 VC가 원하는 타입인지 확인
               nav.viewControllers.first is T {
                // 찾으면 selectedIndex 변경 -> 이 프로퍼티를 변경하면 화면 이동
                selectedIndex = index
                return
            }
        }
    }
}

