//
//  BongloyAPIClient.m
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/20/18.
//

#import "BongloyAPIClient.h"

static NSString * const APIBaseURL = @"https://api.bongloy.com/v1";

@implementation BongloyAPIClient

- (instancetype)initWithConfiguration:(STPPaymentConfiguration *)configuration {
    NSString *publishableKey = [configuration.publishableKey copy];
    self = [super initWithConfiguration:configuration];
    if (self) {
        _apiKey = publishableKey;
        _apiURL = [NSURL URLWithString:APIBaseURL];
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

@end
