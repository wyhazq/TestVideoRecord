//
//  IDFileManager.h
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDFileManager : NSObject

+ (void)removeFile;
+ (NSURL *)tempFileURL;
+ (NSString *)fileSize;

@end
