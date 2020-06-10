//
//  AppKitBridge.h
//  xXxprojectCamelxXx
//
//  Created by xXxuserxXx on xXxdatexXx.
//  Copyright © 2020 Elegant Chaos. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface InterceptingDelegate: NSProxy
- (nonnull id)initWithWindow: (nonnull id) windowIn interceptor: (nonnull id) bridgeIn;
@end
