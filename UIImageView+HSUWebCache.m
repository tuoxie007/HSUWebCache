//
//  UIImageView+HSUWebCache.m
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+HSUWebCache.h"
#import "HSUWebCache.h"

@implementation UIImageView (HSUWebCache)

@dynamic imageUrl;
static const NSString *KEY_IMAGE_URL = @"ImageURL";

- (void)setImageWithUrlStr:(NSString *)urlStr placeHolder:(UIImage *)placeHolder
{
    [self setImageWithUrlStr:urlStr placeHolder:placeHolder success:nil failure:nil];
}

- (void)setImageWithUrlStr:(NSString *)urlStr placeHolder:(UIImage *)placeHolder success:(void (^)())success failure:(void (^)())failure
{
    self.imageUrl = urlStr;
    [HSUWebCache setImageWithUrlStr:urlStr toImageView:self placeHolder:placeHolder success:success failure:failure];
}

-(void)setImageUrl:(NSString *)imageUrl {
    objc_setAssociatedObject(self, &KEY_IMAGE_URL, imageUrl, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)imageUrl {
    return objc_getAssociatedObject(self, &KEY_IMAGE_URL);
}

@end
