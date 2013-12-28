//
//  HSUWebCache.h
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUWebCache : NSObject

+ (void)setImageWithUrlStr:(NSString *)urlStr toButton:(UIButton *)button forState:(UIControlState)state placeHolder:(UIImage *)placeHolder;
+ (void)setImageWithUrlStr:(NSString *)urlStr toImageView:(UIImageView *)imageView placeHolder:(UIImage *)placeHolder;

+ (void)setImageCacheDiretory:(NSString *)directory;
+ (void)setImageCacheSize:(size_t)cacheSize;

@end
