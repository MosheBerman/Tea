//
//  Tea.h
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (void)loadURL:(NSURL *)url withCompletionHandler:(TeaCompletionBlock)completion;

/**
 *  Posts data to a URL using a given dictionary.
 *
 *  @param body The HTTP body to post.
 *  @param url The URL to post to.
 *  @param completion The completion handler to run when the operation is completed.
 */

- (void)sendHTTPBody:(NSDictionary *)body toURL:(NSURL *)url withCompletionHandler:(TeaCompletionBlock)completion;

/**
 *  Sends a request of the specified type (GET | POST | DELETE | UPDATE) to the specified url.
 *
 *  @param methodType The type of data to send.
 *  @param body The HTTP body to post.
 *  @param url The URL to post to.
 *  @param progress The progress handler to call when the underlying NSURLConnection has some progress to report.
 *  @param completion The completion handler to run when the operation is completed.
 */

- (void)sendRequestOfType:(NSString *)methodType withHTTPBody:(NSDictionary *)body toURL:(NSURL *)url withProgressHandler:(TeaProgressBlock)progress andCompletionHandler:(TeaCompletionBlock)completion;


@end
