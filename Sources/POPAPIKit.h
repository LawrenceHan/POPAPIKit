//
//  POPAPIKit.h
//  POPAPIKit
//
//  Created by Hanguang on 2017/8/3.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for POPAPIKit.
FOUNDATION_EXPORT double POPAPIKitVersionNumber;

//! Project version string for POPAPIKit.
FOUNDATION_EXPORT const unsigned char POPAPIKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <POPAPIKit/PublicHeader.h>

@interface AbstractInputStream : NSInputStream

// Workaround for http://www.openradar.me/19809067
// This issue only occurs on iOS 8
- (instancetype)init;

@end
