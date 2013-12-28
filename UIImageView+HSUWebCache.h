//
//  UIImageView+HSUWebCache.h
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HSUWebCache)

- (void)setImageWithUrlStr:(NSString *)urlStr placeHolder:(UIImage *)placeHolder;

@end
