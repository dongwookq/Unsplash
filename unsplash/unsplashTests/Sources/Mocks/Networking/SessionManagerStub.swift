//
//  SessionManagerStub.swift
//  unsplashTests
//
//  Created by Dong-Wook Han on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

@testable import Alamofire
@testable import unsplash
import Foundation

final class SessionManagerStub: SessionManagerProtocol {
  var requestParameters: (url: URLConvertible, method: HTTPMethod, parameters: Parameters?)?

  func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest {
    self.requestParameters = (url, method, parameters)
    return DataRequest(session: URLSession(), requestTask: .data(nil, nil))
  }
}
