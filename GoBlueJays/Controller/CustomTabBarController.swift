import UIKit

class CustomTabBarController: UITabBarController
{
    @IBInspectable var initialIndex: Int = 0
    
    // tab bar style
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice().userInterfaceIdiom == .phone {
            var tabFrame            = tabBar.frame
            tabFrame.size.height    = 100
            tabFrame.origin.y       = view.frame.size.height - 100
            tabBar.frame            = tabFrame
        }
    }
}
