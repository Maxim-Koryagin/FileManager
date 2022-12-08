//
//  TabBarCoordinator.swift
//  FileManager
//
//  Created by kosmokos I on 06.12.2022.
import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarControler: UITabBarController { get set }
}

class TabCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var tabBarController = TabBarController()
    
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
  
    func start() {
       showTabBarController()
    }
    
    func showTabBarController() {
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
}
