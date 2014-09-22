//
//  HSUWebCache.m
//  Tweet4China
//
//  Created by Jason Hsu on 2013/12/2.
//  Copyright (c) 2013年 Jason Hsu <support@tuoxie.me>. All rights reserved.
//

#import "HSUWebCache.h"
#import <AFNetworking/AFNetworking.h>
#import <NSString-MD5/NSString+MD5.h>
#import "UIButton+HSUWebCache.h"
#import "UIImageView+HSUWebCache.h"

#define tp(filename) [([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])stringByAppendingPathComponent:filename]

@implementation HSUWebCache

#define CacheSizeDefault 16000000;

static NSString *CacheDir;
static size_t CacheSize;

+ (void)setImageWithUrlStr:(NSString *)urlStr toImageView:(UIImageView *)imageView placeHolder:(UIImage *)placeHolder success:(void (^)())success failure:(void (^)())failure
{
    [self setImageWithUrlStr:urlStr toView:imageView forState:0 placeHolder:placeHolder success:success failure:failure];
}

+ (void)setImageWithUrlStr:(NSString *)urlStr toButton:(UIButton *)button forState:(UIControlState)state placeHolder:(UIImage *)placeHolder success:(void (^)())success failure:(void (^)())failure
{
    [self setImageWithUrlStr:urlStr toView:button forState:state placeHolder:placeHolder success:success failure:failure];
}

+ (void)setImageWithUrlStr:(NSString *)urlStr toView:(UIView *)view forState:(UIControlState)state placeHolder:(UIImage *)placeHolder success:(void (^)())success failure:(void (^)())failure
{
    // check configuration
    if (!CacheDir) {
        CacheDir = @"HSUWebCache";
    }
    if (!CacheSize) {
        CacheSize = CacheSizeDefault;
    }
    
    // create cache folder if not exists
    NSString *cachePath = tp(CacheDir);
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:cachePath]) {
        NSError *err;
        [fm createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&err];
        if (err) {
            // todo error
            NSLog(@"Create directory path failed: %@", cachePath);
            return ;
        }
    }
    
    // find cache file
    if (urlStr) {
        for (NSString *subDir in [fm contentsOfDirectoryAtPath:cachePath error:nil]) {
            NSString *subDirPath = [cachePath stringByAppendingPathComponent:subDir];
            NSString *filename = [urlStr MD5Hash];
            NSString *filePath = [subDirPath stringByAppendingPathComponent:filename];
            if ([fm fileExistsAtPath:filePath]) {
                UIImage *img = [[UIImage alloc] initWithContentsOfFile:filePath];
                if (img) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        [(UIImageView *)view setImage:img];
                    } else {
                        [(UIButton *)view setImage:img forState:state];
                    }
                    if (success) success();
                    return;
                } else {
                    NSError *err;
                    [fm removeItemAtPath:filePath error:&err];
                    if (err) {
                        // todo warn
                        NSLog(@"Remove broken image file failed: %@, %@", filePath, err);
                    }
                }
            }
        }
    }
    
    // clear view content
    if ([view isKindOfClass:[UIImageView class]]) {
        [(UIImageView *)view setImage:placeHolder];
    } else {
        [(UIButton *)view setImage:placeHolder forState:state];
    }
    
    // check url
    if (!urlStr) {
        return;
    }
    
    // download image file
    static AFHTTPClient *afClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://tuoxie.me"]];
        [afClient.operationQueue setMaxConcurrentOperationCount:10];
    });
    __weak UIView *weakView = view;
    AFHTTPRequestOperation *operation = [afClient HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // get sub directories
        NSString *cachePath = tp(CacheDir);
        NSString *curSubDirPath;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *err;
        NSArray *subDirs = [[fm contentsOfDirectoryAtPath:cachePath error:&err] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *subDir1 = obj1;
            NSString *subDir2 = obj2;
            return [subDir1 compare:subDir2];
        }];
        if (err) {
            // todo error
            NSLog(@"list directory failed: %@, %@", cachePath, err);
            return ;
        }
        
        // caculate current sub folder cache size
        if (subDirs.count) {
            static int count = 0;
            count ++;
            NSString *curSubDir = subDirs.lastObject;
            curSubDirPath = [cachePath stringByAppendingPathComponent:curSubDir];
            if (count % 10 == 0) {
                size_t dirSize = 0;
                for (NSString *filename in [fm contentsOfDirectoryAtPath:curSubDirPath error:&err]) {
                    NSString *filePath = [curSubDirPath stringByAppendingPathComponent:filename];
                    NSError *err;
                    NSDictionary *attrs = [fm attributesOfItemAtPath:filePath error:&err];
                    if (err) {
                        // todo error
                        NSLog(@"Fetch file attributes failed: %@", err); return;
                    }
                    dirSize += [attrs[NSFileSize] longLongValue];
                }
                
                if (dirSize > CacheSize / 2) {
                    NSInteger curIdx = [subDirs indexOfObject:curSubDir];
                    // remove old cache folder
                    if (curIdx > 0) {
                        NSString *lastSubDir = subDirs[curIdx-1];
                        NSString *lastSubDirPath = [cachePath stringByAppendingPathComponent:lastSubDir];
                        NSError *err;
                        [fm removeItemAtPath:lastSubDirPath error:&err];
                        if (err) {
                            // todo error
                            NSLog(@"Remove directory failed: %@, %@", lastSubDirPath, err);
                            return;
                        }
                    }
                    // set nil to use a new sub folder
                    curSubDirPath = nil;
                }
            }
        }
        
        // use a new sub folder
        if (curSubDirPath == nil) {
            NSString *newSubDir = [NSString stringWithFormat:@"%.3f", [[NSDate date] timeIntervalSince1970]];
            NSString *newSubDirPath = [cachePath stringByAppendingPathComponent:newSubDir];
            NSError *err;
            [fm createDirectoryAtPath:newSubDirPath withIntermediateDirectories:YES attributes:nil error:&err];
            if (err) {
                // todo error
                NSLog(@"Create directory failed: %@", err);
                return;
            }
            curSubDirPath = newSubDirPath;
        }
        
        // set image with new data
        if ([responseObject isKindOfClass:[NSData class]]) {
            UIImage *img = [[UIImage alloc] initWithData:responseObject];
            if (img) {
                NSString *filename = [urlStr MD5Hash];
                NSString *filePath = [curSubDirPath stringByAppendingPathComponent:filename];
                NSData *imgData = responseObject;
                // cache file
                [imgData writeToFile:filePath atomically:YES];
                
                if ([view isKindOfClass:[UIImageView class]]) {
                    if ([((UIImageView *)weakView).imageUrl isEqualToString:urlStr]) {
                        [(UIImageView *)weakView setImage:img];
                    }
                } else {
                    if ([((UIButton *)weakView).imageUrl isEqualToString:urlStr]) {
                        [(UIButton *)weakView setImage:img forState:state];
                    }
                }
                if (success) success();
            } else {
                // todo error
                NSLog(@"Download image failed: %@", urlStr);
                if (failure) failure();
                return;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) failure();
    }];
    
    [afClient.operationQueue addOperation:operation];
}

+ (void)setImageCacheDiretory:(NSString *)directory
{
    CacheDir = directory;
}

+ (void)setImageCacheSize:(size_t)cacheSize
{
    CacheSize = cacheSize;
}

+ (NSError *)cleanCache
{
    NSString *cachePath = tp(CacheDir);
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
    return error;
}

@end
