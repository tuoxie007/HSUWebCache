//
//  UIImageView+HSUWebCache.m
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import "UIImageView+HSUWebCache.h"
#import "HSUWebCache.h"

@implementation UIImageView (HSUWebCache)

- (void)setImageWithUrlStr:(NSString *)urlStr placeHolder:(UIImage *)placeHolder
{
    [HSUWebCache setImageWithUrlStr:urlStr toImageView:self placeHolder:placeHolder];
}

@end
