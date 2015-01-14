//
//  Tea.m
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import "Tea.h"
#import "TeaOperation.h"
#import <UIKit/UIKit.h>

/**
 *
 */

@interface Tea ()

/**
 *  The NSOperationQueue handles concurrent operations.
 */

@property (nonatomic, strong) NSOperationQueue *queue;

@end

/**
 *
 */

@implementation Tea

#pragma mark - Initializer

/** ---
 *  @name Initializer
 *  ---
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"com.mosheberman.queue.Tea";
        _queue.underlyingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

#pragma mark - Singleton Access

/** ---
 *  @name Singleton Access
 *  ---
 */

/**
 *  @return A singleton instance of Tea.
 */

+ (instancetype)tea
{
    static Tea *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Tea alloc] init];
    });
    
    return manager;
}

#pragma mark - Network Operations

/** ---
 *  @name Network Operations
 *  ---
 */

/**
 *  Kicks off a url load operation on the tea's internal concurrent queue.
 *
 *  @param url The URL to load.
 *  @param completion The completion handler.
 *
 */

- (void)loadURL:(NSURL *)url withCompletionHandler:(TeaCompletionBlock)completion
{
    [self sendRequestOfType:@"GET" withHTTPBody:nil toURL:url withProgressHandler:nil andCompletionHandler:completion];
}

/**
 *  Posts data to a URL using a given dictionary.
 *
 *  @param body The HTTP body to post.
 *  @param url The URL to post to.
 *  @param completion The completion handler to run when the operation is completed.
 */

- (void)sendHTTPBody:(NSDictionary *)body toURL:(NSURL *)url withCompletionHandler:(TeaCompletionBlock)completion
{
    [self sendRequestOfType:@"POST" withHTTPBody:body toURL:url withProgressHandler:nil andCompletionHandler:completion];
}

/**
 *  Sends a request of the specified type (GET | POST | DELETE | UPDATE) to the specified url.
 *
 *  @param methodType The type of data to send.
 *  @param body The HTTP body to post.
 *  @param url The URL to post to.
 *  @param progress The progress handler to call when the underlying NSURLConnection has some progress to report.
 *  @param completion The completion handler to run when the operation is completed.
 */

- (void)sendRequestOfType:(NSString *)methodType withHTTPBody:(NSDictionary *)body toURL:(NSURL *)url withProgressHandler:(TeaProgressBlock)progress andCompletionHandler:(TeaCompletionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TeaOperation *t = [[TeaOperation alloc] initWithURL:url andType:methodType andData:body withProgressHandler:progress andCompletion:completion];
        [t addObserver:self forKeyPath:NSStringFromSelector(@selector(isExecuting)) options:NSKeyValueObservingOptionNew context:nil];
        [self.queue addOperation:t];
        [t start];
    });
}

#pragma mark - Network Activity Indicator

/** ---
 *  @name Network Activity Indicator
 *  ---
 */

/**
 *  Update the activity indicator.
 */

- (void)updateNetworkActivityIndicator
{
    BOOL enabled = NO;
    if (self.queue.operationCount == 0)
    {
        enabled = NO;
    }
    else
    {
        for (TeaOperation *operation in self.queue.operations)
        {
            if (operation.isExecuting) {
                enabled = YES;
                break;
            }
        }
    }
    [self setNetworkActivityIndicatorEnabled:enabled];
}

- (void)setNetworkActivityIndicatorEnabled:(BOOL)enabled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:enabled];
    });
}

#pragma mark - Inspecting the Queue

/** ---
 *  @name Inspecting the Queue
 * 
 * ----
 */

/**
 *  @return The operations in the queue.
 */

- (NSArray *)operations
{
    return self.queue.operations;
}

/**
 *  The number of operations in the queue.
 */

- (NSInteger)operationCount
{
    return self.queue.operationCount;
}

#pragma mark - KVO

/** ---
 *  @name KVO
 * ---
 */

/**
 *
 *
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqual:NSStringFromSelector(@selector(isExecuting))])
    {
        [self updateNetworkActivityIndicator];
    }
}

@end
