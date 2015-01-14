//
//  TeaOperation.m
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import "TeaOperation.h"

@interface TeaOperation () <NSURLConnectionDataDelegate>

/**
 *  The URL connection.
 */

@property (nonatomic, strong) NSURLConnection *connection;

/**
 *  The state of the connection.
 */

@property (nonatomic, assign) BOOL downloading;

/**
 *  If the connection is finished, we'll change this.
 */

@property (nonatomic, assign) BOOL finishedDownloading;

/**
 *  A place to hold the data.
 */

@property (nonatomic, strong) NSMutableData *data;

/**
 *  Estimated Length.
 */

@property (nonatomic, assign) double estimatedLength;

/**
 *
 */

@property (nonatomic, strong) TeaCompletionBlock completionHandler;

/**
 *
 */

@property (nonatomic, strong) TeaProgressBlock progressHandler;


@end

@implementation TeaOperation

/**
 *  Begins a call to the specified URL with the supplied completion block.
 *
 *  @param url The URL to call.
 *  @param progress A block that is executed when the connection delegate receives a progress callback.
 *  @param completion The completion block to run when the operation completes.
 *
 *  @return A TeaOperation
 */

- (instancetype)initWithURL:(NSURL *)url progressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion
{
    return [self initWithURL:url andType:@"GET" andData:nil withProgressHandler:progress andCompletion:completion];
}

/**
 *  Begins a call to the specified URL with the supplied completion block.
 *
 *  @param url The URL to call.
 *  @param data An HTTP body dictionary.
 *  @param progress A block that is executed when the connection delegate receives a progress callback.
 *  @param completion The completion block to run when the operation completes.
 *
 *  @return A TeaOperation
 */

- (instancetype)initWithURL:(NSURL *)url andData:(NSDictionary *)data withProgressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion{
    
    return [self initWithURL:url andType:@"POST" andData:data withProgressHandler:progress andCompletion:completion];
}

/**
 *  Begins a call to the specified URL with the supplied completion block.
 *
 *  @param url The URL to call.
 *  @param type The HTTP method type to use. Valid values are GET, POST, DELETE, and UPDATE. Pass as an NSString.
 *  @param data An HTTP body dictionary.
 *  @param progress A block that is executed when the connection delegate receives a progress callback.
 *  @param completion The completion block to run when the operation completes.
 *
 *  @return A TeaOperation.
 */

- (instancetype)initWithURL:(NSURL *)url andType:(NSString *)type andData:(NSDictionary *)data withProgressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion
{
    self = [super init];

    if (self)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        if (@[@"POST", @"GET", @"DELETE", @"UPDATE"])
        {
            [request setHTTPMethod:type];
        }
        
        if (data)
        {
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:data options:0 error:nil]];
        }
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        _progressHandler = progress;
        _completionHandler = completion;
        
        _finishedDownloading = NO;
        _downloading = NO;
    }
    
    return self;
}

- (void)start
{
    //  Prep the completion block
    __weak TeaOperation *weakSelf = self;
    self.completionBlock = ^{
        if (weakSelf.completionHandler)
        {
            weakSelf.completionHandler(weakSelf.data != nil, weakSelf.data);
        }
    };
    
    [self.connection start];
    
    //  KVO compliance
    
    [self willChangeValueForKey:@"isExecuting"];
    self.downloading = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (BOOL)isExecuting
{
    return self.downloading;
}

- (BOOL)isFinished
{
    return self.finishedDownloading;
}

/**
 *  This method estimates how much of the download
 *  was completed.
 *
 *  @return A double between 0 and 1.0 or -1 if the proress is unknown.
 */

- (double)progress
{
    if (self.estimatedLength == -1)
    {
        return -1;
    }
    else
    {
        return self.data.length/self.estimatedLength;
    }
}

#pragma mark - NSURLConnectionDelegate

/** ---
 *  @name NSURLConnectionDelegate
 *  ---
 */

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self markFlagsAsFinished];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.data) {
        self.data = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [self.data appendData:data];
    }
    
    if (self.progressHandler) {
        self.progressHandler(self.progress);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self markFlagsAsFinished];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.estimatedLength = response.expectedContentLength;
}

#pragma mark - Flags

/** ---
 *  @name Flags
 *  ---
 */

- (void)markFlagsAsFinished
{
    [self willChangeValueForKey:@"isExecuting"];
    self.downloading = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    self.finishedDownloading = YES;
    [self didChangeValueForKey:@"isFinished"];
}

@end
