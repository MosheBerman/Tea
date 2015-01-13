//
//  Tea.h
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeaOperation.h"

/**
 *  A tea completion block for network requests.
 */

typedef void(^TeaCompletionBlock)(BOOL success, NSData *data);

/**
 *  A progress block for network requests.
 */

typedef void(^TeaProgressBlock)(double progress);

/**
 *  The Tea class is a singleton manager for 
 *  a concurrent NSOperationQueue which
 *  handles network requests.
 */

@interface Tea : NSObject

#pragma mark - Singleton Access

/** ---
 *  @name Singleton Access
 *  ---
 */

/**
 *  @return A singleton instance of Tea.
 */

+ (instancetype)tea;

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

- (void)loadURL:(NSURL *)url  withProgressHandler:(TeaProgressBlock)progress completionHandler:(TeaCompletionBlock)completion andOperationIdentifier:(NSString *)operationIdentifier;

@end
