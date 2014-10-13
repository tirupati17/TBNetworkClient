//
//  TBNetworkClient.h
//  https://github.com/tirupati17/TBNetworkClient
//
//  Created by Tirupati Balan on 13/05/13.
//  Copyright (c) 2014 CelerApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@protocol NetworkClientDelegate <NSObject>
- (void)receivedResult:(id)resultDictionary;
- (void)failedResult;
@end

@interface TBNetworkClient : NSObject <NSURLConnectionDelegate> {

}
typedef void (^CallbackBlock)(id responseObj, NSError *error);
@property (copy) CallbackBlock callback;
@property (nonatomic, assign) id <NetworkClientDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;

+ (id)sharedNetworkClient;

#pragma mark - AFHTTP

//GET request with key-value pair using NSDictionary
- (void)getAFHTTPRequest:(NSString *)apiQuery
          atGetParameter:(NSDictionary *)parameters
                 atBlock:(CallbackBlock)block
                   atKey:(NSString *)keyString;
//POST request with body string
- (void)postBodyAFHTTPRequest:(NSString *)apiQuery
                   atPostBody:(NSString *)postBody
                      atBlock:(CallbackBlock)block
                        atKey:(NSString *)keyString;
//POST request with key-value pair using NSDictionary
- (void)postAFHTTPRequest:(NSString *)apiQuery
          atPostParameter:(NSDictionary *)parameters
                  atBlock:(CallbackBlock)block
                    atKey:(NSString *)keyString;
//PUT request with key-value pair using NSDictionary
- (void)putAFHTTPRequest:(NSString *)apiQuery
          atPutParameter:(NSDictionary *)parameters
                 atBlock:(CallbackBlock)block
                   atKey:(NSString *)keyString;

#pragma mark - NSURLConnection

//Simple get request
- (void)getNSURLRequest:(NSString *)apiQuery
                atBlock:(CallbackBlock)block;
- (void)postNSURLRequest:(NSString *)apiQuery
              atPostBody:(NSString *)postBody
                 atBlock:(CallbackBlock)block;

@end
