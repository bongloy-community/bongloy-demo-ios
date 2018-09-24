//
//  BongloyAPIClient.h
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/20/18.
//  Copyright © 2018 bongloy. All rights reserved.
//

#import <Stripe/Stripe.h>

@interface BongloyAPIClient : STPAPIClient

/**
 A shared singleton API client. Its API key will be initially equal to [Stripe defaultPublishableKey].
 */

+ (instancetype)sharedBongloyClient;

/**
 Initializes an API client with the given configuration. Its API key will be
 set to the configuration's publishable key.
 
 @param configuration The configuration to use.
 @return An instance of STPAPIClient.
 */

- (instancetype)initWithConfiguration:(STPPaymentConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

@end

@interface BongloyAPIClient()

@property (nonatomic, strong, readwrite) NSURL *apiURL;
@property (nonatomic, strong, readonly) NSURLSession *urlSession;

@end


