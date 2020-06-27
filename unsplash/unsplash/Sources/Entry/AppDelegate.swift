//
//  AppDelegate.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appDependency: AppDependency
    
    // iOS 시스템에 의해 자동으로 호출되는 생성자
    private override init() {
        self.appDependency = AppDependency.resolve()
    }
    
    // 테스트시에만 호출하는 생성자
    init(dependency: AppDependency) {
      self.appDependency = dependency
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let rootViewController = self.rootViewController() {
            rootViewController.dependency = self.appDependency.listPhotosViewControllerDependency
        }
        return true
    }
    
    private func rootViewController() -> ListPhotosViewController? {
        let navigationController = self.window?.rootViewController as? UINavigationController
        return navigationController?.viewControllers.first as? ListPhotosViewController
    }

}

