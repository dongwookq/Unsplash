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
    func list(completionHandler: @escaping (Result<[PhotoListResult]>) -> Void) -> DataRequest
    
    func download(_ imageUrl: URL, contentsView: UIView, completion: @escaping (_ image: UIImage?) -> Void)
}

final class UnsplashService: UnsplashServiceProtocol {
    private let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
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
    
    @discardableResult
    func list(completionHandler: @escaping (Result<[PhotoListResult]>) -> Void) -> DataRequest {
        let url = "https://api.unsplash.com/photos/?client_id=rbyQZbn3ySVAfya2-idgr9W2Uo2_-RnsJkaA358YIB4"
        //let parameters: Parameters = ["q": keyword]
        return self.sessionManager.request(url, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil)
          .responseData { response in
            let decoder = JSONDecoder()
            let result = response.result.flatMap {
              try decoder.decode([PhotoListResult].self, from: $0)
            }
            completionHandler(result)
          }

    }
    
    
    // 이미지 다운로드 디스패치 큐
    let imageDispatchQueue: DispatchQueue = DispatchQueue(label: "image")
    
    // 이미지 메모리 캐시를 위한 딕셔너리
    var cachedImage: [URL: UIImage] = [:]

    func download(_ url: URL, contentsView: UIView, completion: @escaping (_ image: UIImage?) -> Void) {
        
        //let url: URL = self.sizedImageURL(from: imageUrl, view: contentsView)
        
        if let cachedImage: UIImage = self.cachedImage[url] {
            DispatchQueue.main.async {
                completion(cachedImage)
                return
            }
        }
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        imageDispatchQueue.async {
//            defer {
//                DispatchQueue.main.async {
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                }
//            }
            
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
    
//    private func sizedImageURL(from url: URL, view: UIView) -> URL {
//        var screenScale: CGFloat { return UIScreen.main.scale }
//
////        let width: CGFloat = UIScreen.main.bounds.width * screenScale
////        let height: CGFloat = UIScreen.main.bounds.height * screenScale
//
//        let width: CGFloat = view.frame.width * screenScale
//        let height: CGFloat = view.frame.height * screenScale
//
//        return url.appending(queryItems: [
//            URLQueryItem(name: "max-w", value: "\(width)"),
//            URLQueryItem(name: "max-h", value: "\(height)")
//        ])
//    }
    
    
}

//extension URL {
//    func appending(queryItems: [URLQueryItem]) -> URL {
//        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
//            return self
//        }
//
//        var queryDictionary = [String: String]()
//        if let queryItems = components.queryItems {
//            for item in queryItems {
//                queryDictionary[item.name] = item.value
//            }
//        }
//
//        for item in queryItems {
//            queryDictionary[item.name] = item.value
//        }
//
//        var newComponents = components
//        newComponents.queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })
//
//        return newComponents.url ?? self
//    }
//}
