//
//  SessionManagerProtocol.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Alamofire

protocol SessionManagerProtocol {
    @discardableResult
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest
}

extension SessionManager: SessionManagerProtocol {
    
}
