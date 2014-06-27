//
//  AutoAnimation.m
//  HRP
//
//  Created by shinsoft  on 12-8-23.
//  Copyright (c) 2012年 shinsoft . All rights reserved.
//

#import "AutoAnimation.h"

@implementation AutoAnimation

+ (CATransition *) createAnimation
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    return animation;
}

//产生随机切换动画
+ (NSString *) randomTransitionType
{
    int x = arc4random() % 12;
    switch (x) {
        case 0:
            return kCATransitionFade;
            break;
        case 1:
            return kCATransitionPush;
            break;
        case 2:
            return kCATransitionReveal;
            break;
        case 3:
            return kCATransitionMoveIn;
            break;
        case 4:
            return @"cube";
            break;
        case 5:
            return @"suckEffect";
            break;
        case 6:
            return @"oglFlip";
            break;
        case 7:
            return @"rippleEffect";
            break;
        case 8:
            return @"pageCurl";
            break;
        case 9:
            return @"pageUnCurl";
            break;
        default:
            return @"oglFlip";
            break;
    }
}

//产生随机动画切换方向
+ (NSString *) randomTransitionFrom
{
    int x = arc4random() % 4;
    switch (x) {
        case 0:
            return kCATransitionFromTop;
            break;
        case 1:
            return kCATransitionFromBottom;
            break;
        case 2:
            return kCATransitionFromLeft;
            break;
        case 3:
            return kCATransitionFromRight;
            break;
        default:
            return kCATransitionFromLeft;
            break;
    }
}

@end
