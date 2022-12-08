//
//  TabBarController.swift
//  FileManager
//
//  Created by kosmokos I on 05.12.2022.
//

import Foundation

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: Properties
    
    private var firstTabNavigationController: UINavigationController!
    private var secondTabNavigationController: UINavigationController!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: Methods
    
    private func setupTabBar() {
        
        firstTabNavigationController = UINavigationController.init(rootViewController: FilesViewController())
        secondTabNavigationController = UINavigationController.init(rootViewController: SettingsViewController())
        
        viewControllers = [firstTabNavigationController, secondTabNavigationController]
        
        let item1 = UITabBarItem(title: "Files", image: UIImage(systemName: "folder"), tag: 0)
        let item2 = UITabBarItem(title: "Settings", image:  UIImage(systemName: "gear"), tag: 1)
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationController.tabBarItem = item2
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 248/255.0, alpha: 1)
        UITabBar.appearance().backgroundColor = .white
    }
    
}
