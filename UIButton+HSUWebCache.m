//
//  UIButton+HSUWebCache.m
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+HSUWebCache.h"
#import "HSUWebCache.h"

@implementation UIButton (HSUWebCache)

@dynamic imageUrl;
static const NSString *KEY_IMAGE_URL = @"ImageURL";

- (void)setImageWithUrlStr:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)placeHolder
{
    [self setImageWithUrlStr:urlStr forState:state placeHolder:placeHolder success:nil failure:nil];
}

- (void)setImageWithUrlStr:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)placeHolder success:(void (^)())success failure:(void (^)())failure
{
    self.imageUrl = urlStr;
    [HSUWebCache setImageWithUrlStr:urlStr toButton:self forState:state placeHolder:placeHolder success:success failure:failure];
}

-(void)setImageUrl:(NSString *)imageUrl {
    objc_setAssociatedObject(self, &KEY_IMAGE_URL, imageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)imageUrl {
    return objc_getAssociatedObject(self, &KEY_IMAGE_URL);
}

@end
