//
//  AppDependency.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation
import Alamofire

struct AppDependency {
    let listPhotosViewControllerDependency: ListPhotosViewController.Dependency
}

extension AppDependency {
    static func resolve() -> AppDependency {
        let sessionManager = SessionManager.default
        let unsplashService = UnsplashService(sessionManager: sessionManager)
        
        return AppDependency (listPhotosViewControllerDependency: .init(unsplashService: unsplashService))
    }
}
