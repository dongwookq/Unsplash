//
//  UnsplashService.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

protocol UnsplashServiceProtocol {
    @discardableResult
    func search(keyword: String, completionHandler: @escaping (Result<SearchResult>) -> Void) -> DataRequest
    
    @discardableResult
    func list(page: Int, completionHandler: @escaping (Result<[PhotoListResult]>) -> Void) -> DataRequest
    
    func download(_ imageUrl: URL, contentsView: UIView, completion: @escaping (_ image: UIImage?) -> Void)
}

final class UnsplashService: UnsplashServiceProtocol {
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    // MARK: 검색
    @discardableResult
    func search(keyword: String, completionHandler: @escaping (Result<SearchResult>) -> Void) -> DataRequest {
        
        let url = "https://api.unsplash.com//search/photos?"
        let parameters: Parameters = ["query": keyword, "page": "1", "per_page": "30", "client_id": "rbyQZbn3ySVAfya2-idgr9W2Uo2_-RnsJkaA358YIB4"]
        return self.sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding(), headers: nil)
          .responseData { response in
            let decoder = JSONDecoder()
            let result = response.result.flatMap {
              try decoder.decode(SearchResult.self, from: $0)
            }
            completionHandler(result)
          }
    }
    
    // MARK: 목록
    @discardableResult
    func list(page: Int, completionHandler: @escaping (Result<[PhotoListResult]>) -> Void) -> DataRequest {
        let url = "https://api.unsplash.com/photos/?"
        let parameters: Parameters = ["page": "1", "per_page": "30", "client_id": "rbyQZbn3ySVAfya2-idgr9W2Uo2_-RnsJkaA358YIB4"]
        return self.sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding(), headers: nil)
          .responseData { response in
            let decoder = JSONDecoder()
            let result = response.result.flatMap {
              try decoder.decode([PhotoListResult].self, from: $0)
            }
            completionHandler(result)
          }

    }
    
    
    // 이미지 캐시
    let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image")
    var cachedImage: [URL: UIImage] = [:]

    // MARK: 다운로드 이미지
    func download(_ url: URL, contentsView: UIView, completion: @escaping (_ image: UIImage?) -> Void) {
        if let cachedImage: UIImage = self.cachedImage[url] {
            DispatchQueue.main.async {
                completion(cachedImage)
                return
            }
        }
        
        imageDispatchQueue.async {
            
            guard let data: Data = try? Data(contentsOf: url) else {
                print("데이터 - 이미지 변환 실패")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let image: UIImage? = UIImage(data: data)
            self.cachedImage[url] = image
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
