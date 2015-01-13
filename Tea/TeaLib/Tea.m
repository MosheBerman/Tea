//
//  Tea.m
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import "Tea.h"

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

#pragma mark - URL Loading

/** ---
 *  @name URL Loading
 *  ---
 */

/**
 *  Kicks off a url load operation on the tea's internal concurrent queue.
 *
 *  @param url The URL to load.
 *  @param progress The progress handler.
 *  @param completion The completion handler.
 *  @param operationIdentifier Used to cancel the operation later.
 *
 */

- (void)loadURL:(NSURL *)url withProgressHandler:(TeaProgressBlock)progress completionHandler:(TeaCompletionBlock)completion andOperationIdentifier:(NSString *)operationIdentifier
{
    TeaOperation *t = [[TeaOperation alloc] initWithURL:url progressHandler:progress andCompletion:completion];
    t.identifier = operationIdentifier;
    
    [self.queue addOperation:t];
    [t start];
}


@end
