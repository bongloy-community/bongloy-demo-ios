//
//  BongloyAPIClient.m
//  bongloy-demo-ios
//
//  Created by khomsovon on 9/20/18.
//  Copyright © 2018 bongloy. All rights reserved.
//

#import "BongloyAPIClient.h"

static NSString * const APIBaseURL = @"https://api.bongloy.com/v1";

@interface BongloyAPIClient()

@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *,NSObject *> *sourcePollers;
@property (nonatomic, strong, readwrite) dispatch_queue_t sourcePollersQueue;
@property (nonatomic, strong, readwrite) NSString *apiKey;

@end

@implementation BongloyAPIClient

+ (instancetype)sharedBongloyClient {
    static id sharedBongloyClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedBongloyClient = [[self alloc] init]; });
    return sharedBongloyClient;
}

- (instancetype)init {
    return [self initWithConfiguration:[STPPaymentConfiguration sharedConfiguration]];
}

- (instancetype)initWithConfiguration:(STPPaymentConfiguration *)configuration {
    NSString *publishableKey = [configuration.publishableKey copy];
    self = [super initWithConfiguration:configuration];
    if (self) {
        _apiKey = publishableKey;
        _apiURL = [NSURL URLWithString:APIBaseURL];
        super.configuration = configuration;
        super.stripeAccount = configuration.stripeAccount;
        _sourcePollers = [NSMutableDictionary dictionary];
        _sourcePollersQueue = dispatch_queue_create("com.stripe.sourcepollers", DISPATCH_QUEUE_SERIAL);
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}
@end
