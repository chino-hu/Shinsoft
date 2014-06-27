//
//  AutoAnimation.h
//  HRP
//
//  Created by shinsoft  on 12-8-23.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AutoAnimation : NSObject

+ (CATransition *) createAnimation;
+ (NSString *) randomTransitionType;
+ (NSString *) randomTransitionFrom;

@end
