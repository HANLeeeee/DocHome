//
//  MainTabBarController.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/14.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        print("텝바 뷰디드로드")
        
        let homeVC = UINavigationController.init(rootViewController: HomeViewController(title: "닥홈"))
        let mapVC = UINavigationController.init(rootViewController: MapViewController(title: "지도"))
        let settingVC = UINavigationController.init(rootViewController: SettingViewController(title: "설정"))
        
        self.viewControllers = [homeVC, mapVC, settingVC]
        
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        let mapTabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "map"), tag: 1)
        let settingTabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), tag: 2)
        
        homeVC.tabBarItem = homeTabBarItem
        mapVC.tabBarItem = mapTabBarItem
        settingVC.tabBarItem = settingTabBarItem
        
        self.tabBar.tintColor = UIColor(named: "COLOR_PURPLE")
        
    }
}
