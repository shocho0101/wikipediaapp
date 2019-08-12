//
//  GetPageFromIDRequest.swift
//  wikipediaapp
//
//  Created by 張翔 on 2019/08/13.
//  Copyright © 2019 choccho. All rights reserved.
//

import Foundation
import Alamofire

struct GetPageFromIDRequest: APIRequest {
    typealias ResponseType = WikipediaPage
    
    let method: HTTPMethod = .get
    
    var parameters: Parameters {
        let params: [String: Any] = [
            "format": "json",
            "action": "query",
            "prop": "extracts",
            "exintro": true,
            "explaintext": true,
            "pageids": id]
        return params
    }
    
    var id: Int
    
    struct QueryResponseData: Codable {
        var query: Query
        struct Query: Codable {
            var pages: [Int: WikipediaPage]
        }
    }
    
    func parseData(data: Data) -> WikipediaPage? {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(QueryResponseData.self, from: data)
        return decodedData?.query.pages.first?.value
    }

}


