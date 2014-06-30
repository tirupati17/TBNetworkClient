//
//  NetworkClient.m
//  
//
//  Created by Tirupati Balan on 13/05/13.
//  Copyright (c) 2014 CelerApps. All rights reserved.
//

#import "NetworkClient.h"

@implementation NetworkClient

@synthesize delegate;
@synthesize callback;
@synthesize responseData;

+ (id)sharedNetworkClient {
    static NetworkClient *sharedNetworkClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworkClient = [[self alloc] init];
    });
    return sharedNetworkClient;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark
#pragma mark - AFHTTP

/**
    Class  : AFHTTPRequestOperation
    Method : GET
    apiQuery : url query
    parameters : parameters in dictionary
 **/

- (void)getAFHTTPRequest:(NSString *)apiQuery
         atGetParameter:(NSDictionary *)parameters
                atBlock:(CallbackBlock)block
                  atKey:(NSString *)keyString {
    self.callback = block;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:keyString forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer = requestSerializer;

    [manager GET:apiQuery
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self.delegate receivedResult:responseObject];
              self.callback(responseObject, nil);
          }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [self.delegate failedResult];
              self.callback(nil, error);
    }];
}

/**
    Class  : AFHTTPRequestOperation and NSMutableURLRequest
    Method : POST
    apiQuery : url query
    postBody : post body for handling json data
 **/

- (void)postBodyAFHTTPRequest:(NSString *)apiQuery
                   atPostBody:(NSString *)postBody
                      atBlock:(CallbackBlock)block
                        atKey:(NSString *)keyString {
    self.callback = block;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiQuery]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30];

    [request setHTTPMethod:@"POST"];
    [request setValue:keyString forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.callback(nil, error);
    }];
    [op start];
}

/**
    Class  : AFHTTPRequestOperationManager
    Method : POST
    apiQuery : url query
    parameters : parameters in dictionary
 **/

- (void)postAFHTTPRequest:(NSString *)apiQuery
          atPostParameter:(NSDictionary *)parameters
                  atBlock:(CallbackBlock)block
                    atKey:(NSString *)keyString {
    self.callback = block;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:keyString forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer = requestSerializer;

    [manager POST:apiQuery parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              self.callback(responseObject, nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.callback(nil, error);
    }];
}

/**
    Class  : AFHTTPRequestOperationManager
    Method : PUT
    apiQuery : url query
    parameters : parameters in dictionary
 **/

- (void)putAFHTTPRequest:(NSString *)apiQuery
          atPutParameter:(NSDictionary *)parameters
                 atBlock:(CallbackBlock)block
                   atKey:(NSString *)keyString {
    self.callback = block;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:keyString forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer = requestSerializer;

    [manager PUT:apiQuery parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              self.callback(responseObject, nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.callback(nil, error);
          }];
}

#pragma mark
#pragma mark - NSURLConnection

/**
    Class  : Apple NSURLConnection
    Method : GET
    apiQuery : url query
 **/

- (void)getNSURLRequest:(NSString *)apiQuery
                atBlock:(CallbackBlock)block {
    self.callback = block;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiQuery]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    self.responseData = [[NSMutableData alloc] init];

    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.responseData = nil;
    [self.delegate failedResult];
    self.callback(nil, error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData setData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate receivedResult:[[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding]];
    self.callback(self.responseData, nil);
    NSLog(@"Success: %@", [[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding]);
}

@end
