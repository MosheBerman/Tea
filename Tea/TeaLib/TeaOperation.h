//
//  TeaOperation.h
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tea.h"

@interface TeaOperation : NSOperation

/**
 *  The operation's identifier.
 */

@property (nonatomic, strong) NSString *identifier;

/**
 *  Begins a call to the specified URL with the supplied completion block.
 *
 *  @param url The URL to call.
 *  @param progress A block that is executed when the connection delegate receives a progress callback.
 *  @param completion The completion block to run when the operation completes.
 *
 *  @return A TeaOperation
 */

- (instancetype)initWithURL:(NSURL *)url progressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion;

/**
 *  Begins a call to the specified URL with the supplied completion block.
 *
 *  @param url The URL to call.
 *  @param data An HTTP body dictionary. (The HTTP method used in this initializer will be POST.)
 *  @param progress A block that is executed when the connection delegate receives a progress callback.
 *  @param completion The completion block to run when the operation completes.
 *
 *  @return A TeaOperation
 */

- (instancetype)initWithURL:(NSURL *)url andData:(NSDictionary *)data withProgressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion;
    
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

- (instancetype)initWithURL:(NSURL *)url andType:(NSString *)type andData:(NSDictionary *)data withProgressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion;

#pragma mark - Reading Progress

/** ---
 *  @name Reading Progress
 *  ---
 */

/**
 *  This method estimates how much of the download
 *  was completed.
 *
 *  @return A double between 0 and 1.0 or -1 if the proress is unknown.
 */

- (double)progress;

@end
