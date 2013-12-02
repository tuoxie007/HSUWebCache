//
//  UIButton+HSUWebCache.m
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import "UIButton+HSUWebCache.h"
#import "HSUWebCache.h"

@implementation UIButton (HSUWebCache)

- (void)setImageWithUrlStr:(NSString *)urlStr forState:(UIControlState)state
{
    [HSUWebCache setImageWithUrlStr:urlStr toButton:self forState:state];
}

@end
