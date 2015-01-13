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

@property (nonatomic, strong) TeaProgressBlock progressHandler;

@end

@implementation TeaOperation

/**
 *  Begins a call to the specified URL with the supplied completion block.
 *
 *  @param url The URL to call.
 *  @param completion The completion block to run when the operation completes.
 */

- (instancetype)initWithURL:(NSURL *)url progressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion;
{
    self = [super init];
    if (self) {
        _connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
        
        _progressHandler = progress;
        
        __weak NSData* data = _data;
        self.completionBlock = ^{ if(completion)completion(data != nil, data);};
        
        _finishedDownloading = NO;
        _downloading = NO;
    }
    return self;
}

- (void)start
{
    [self.connection start];
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
