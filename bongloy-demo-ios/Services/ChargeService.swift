//
//  ChargeService.swift
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/3/18.
//  Copyright © 2018 bongloy. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class ChargeService {
    
    static let instance = ChargeService()
    var baseURLString: String? = nil
    
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createCharge(token : STPToken, amount : Int, completion: @escaping STPErrorBlock){
        let url = self.baseURL.appendingPathComponent("charge")
        let params: [String: Any ] = [
            "token" : token,
            "amount" : amount,
            "currency" : "USD"
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }
}
