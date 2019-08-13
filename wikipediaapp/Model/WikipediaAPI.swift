//
//  File.swift
//  wikipediaapp
//
//  Created by 張翔 on 2019/08/12.
//  Copyright © 2019 choccho. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class WikipediaAPI {
    static let baseURL = "https://ja.wikipedia.org/w/api.php"
    
    static func send<T: APIRequest, R>(request: T) -> Single<R> where T.ResponseType == R{
        return Single<R>.create(subscribe: { observable -> Disposable in
            Alamofire.request(baseURL,
                              method: request.method,
                              parameters: request.parameters)
                .response(completionHandler: { (response) in
                    guard let data = response.data else {
                        observable(.error(APIError.couldNotGetData))
                        return
                    }
                    guard let parsedData = request.parseData(data: data) else {
                        observable(.error(APIError.parseError))
                        return
                    }
                    observable(.success(parsedData))
                }
            )
            return Disposables.create()
        })
    }
}

protocol APIRequest {
    associatedtype ResponseType
    
    var method: HTTPMethod { get }
    
    var parameters: Parameters { get }
    
    func parseData(data: Data) -> ResponseType?
}

enum APIError: Error {
    case couldNotGetData
    case parseError
}
