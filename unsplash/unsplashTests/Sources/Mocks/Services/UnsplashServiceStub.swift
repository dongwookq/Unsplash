//
//  UnsplashServiceStub.swift
//  unsplashTests
//
//  Created by Dong-Wook Han on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

@testable import Alamofire
@testable import unsplash
import UIKit

final class UnsplashServiceStub: UnsplashServiceProtocol {
    var searchParameters: (keyword: String, completionHandler: (Result<SearchResult>) -> Void)?
    
    var listParameters: (page: Int, completionHandler: (Result<[PhotoListResult]>) -> Void)?

    
    @discardableResult
    func search(keyword: String, completionHandler: @escaping (Result<SearchResult>) -> Void) -> DataRequest {
        self.searchParameters = (keyword, completionHandler)
        return DataRequest(session: URLSession(), requestTask: .data(nil, nil))
    }
    
    @discardableResult
    func list(page: Int, completionHandler: @escaping (Result<[PhotoListResult]>) -> Void) -> DataRequest {
        self.listParameters = (page, completionHandler)
        return DataRequest(session: URLSession(), requestTask: .data(nil, nil))

    }
    
    func download(_ imageUrl: URL, contentsView: UIView, completion: @escaping (_ image: UIImage?) -> Void) {
        
    }
    
    
}

