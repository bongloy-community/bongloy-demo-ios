//
//  BongloyAPI.swift
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/28/18.
//  Copyright © 2018 bongloy. All rights reserved.
//

import UIKit
import Stripe

class BongloyAPI: STPAPIClient {
    
    static let bongloyInstance = BongloyAPI()
    private let APIBaseURL = "https://api.bongloy.com/v1"
    private var apiURL: URL?
    var apiKey = ""
    private(set) var urlSession: URLSession?
    
    convenience init() {
        self.init(configuration: STPPaymentConfiguration.shared())
    }
    
    override init(configuration: STPPaymentConfiguration) {
        let publishableKey = configuration.publishableKey.copy()
        super.init(configuration: configuration)
        apiKey = publishableKey as! String
        apiURL = URL(string: APIBaseURL)!
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }
}
