//
//  NRDPlayerCoordinator.h
//  TestVideoRecord
//
//  Created by wyh on 16/8/24.
//  Copyright © 2016年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol NRDPlayerCoordinatorDelegate <NSObject>

- (void)playerCoordinatorPlayerProgress:(CGFloat)progress;

- (void)playerCoordinatorPlayEnd;

@end

@interface NRDPlayerCoordinator : NSObject

@property (nonatomic, strong, readonly, nullable)AVPlayer *player;

@property (nonatomic, weak, nullable) id <NRDPlayerCoordinatorDelegate> delegate;

- (void)play;

- (void)pause;

@end
