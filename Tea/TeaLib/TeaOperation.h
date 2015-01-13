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
 *  @param completion The completion block to run when the operation completes.
 */

- (instancetype)initWithURL:(NSURL *)url progressHandler:(TeaProgressBlock)progress andCompletion:(TeaCompletionBlock)completion;

/**
 *  This method estimates how much of the download
 *  was completed.
 *
 *  @return A double between 0 and 1.0 or -1 if the proress is unknown.
 */

- (double)progress;

@end
