//
//  ListPhotosViewControllerTests.swift
//  unsplashTests
//
//  Created by Dong-Wook Han on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import XCTest
@testable import unsplash

class ListPhotosViewControllerTests: XCTestCase {
    
    private var unsplashService: UnsplashServiceStub!
    private var viewController: ListPhotosViewController!
    
    override func setUp() {
        super.setUp()
        self.unsplashService = UnsplashServiceStub()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = "ListPhotosViewController"
        self.viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? ListPhotosViewController
        self.viewController.dependency = .init(unsplashService: self.unsplashService)
        self.viewController.loadViewIfNeeded()
    }
    
    func testSearchBar_whenSearchBarSearchButtonClicked_searchWithText() {
        // when
        let searchBar = self.viewController.searchController.searchBar
        searchBar.text = "UnsplashKit"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        // then
        XCTAssertEqual(self.unsplashService.searchParameters?.keyword, "UnsplashKit")
    }
    
    func testActivityIndicatorView_sceenType_whileSearching() {
        // when
        let searchBar = self.viewController.searchController.searchBar
        searchBar.text = "UnsplashKit"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        // then
        XCTAssertEqual(self.viewController.currentSceenType,.search)
    }
    
    
    func testCloseButton_isHidden_whileSearching() {
        // when
        let searchBar = self.viewController.searchController.searchBar
        searchBar.text = "UnsplashKit"
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        // then
        XCTAssertTrue(self.viewController.closeButton.isHidden)
    }
    
//    func testCollectionView_isVisible_afterSearching() {
//        // given
//        let searchBar = self.viewController.searchController.searchBar
//        searchBar.text = "UnsplashKit"
//        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
//
//        // when
//        self.unsplashService.searchParameters?.completionHandler(.failure(TestError()))
//
//        // then
//        XCTAssertFalse(self.viewController.collectionView.isHidden)
//    }
}
