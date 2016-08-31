//
//  IDFileManager.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "IDFileManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation IDFileManager


+ (NSURL *)tempFileURL
{
    return [NSURL fileURLWithPath:[self path]];
}

+ (void)removeFile
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self path]]) {
        [fm removeItemAtPath:[self path] error:nil];
    }
}

+ (NSString *)fileSize {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self path]]){
        return [NSString stringWithFormat:@"%.2fM", ((float)[[fm attributesOfItemAtPath:[self path] error:nil] fileSize] / 1000000)];
    }
    return @"0";
}

+ (NSString *)path {
    return [NSString stringWithFormat:@"%@output.mp4", NSTemporaryDirectory()];
}

@end
