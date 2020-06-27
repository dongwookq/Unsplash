//
//  AppDelegateTests.swift
//  unsplashTests
//
//  Created by Dong-Wook Han on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import XCTest
@testable import unsplash

class AppDelegateTests: XCTestCase {

    func testDidFinishLaunching_configureFirebaseApp() {
      // given
        let dependency = AppDependency(listPhotosViewControllerDependency: .init(unsplashService: UnsplashServiceStub())
      )
      let appDelegate = AppDelegate(dependency: dependency)

      // when
      _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

      // then
      //XCTAssertEqual()
    }

}
