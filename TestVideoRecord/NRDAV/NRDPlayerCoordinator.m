//
//  NRDPlayerCoordinator.m
//  TestVideoRecord
//
//  Created by wyh on 16/8/24.
//  Copyright © 2016年 wyh. All rights reserved.
//

#import "NRDPlayerCoordinator.h"
#import "IDFileManager.h"

@interface NRDPlayerCoordinator ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *platerItem;

@property (nonatomic, strong) id progressObserver;

@end

@implementation NRDPlayerCoordinator

#pragma mark - Action

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(end)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    return self;
}

- (void)play {
    if (self.platerItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.player play];
        __weak __typeof(self) weakSelf = self;
        _progressObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            NSTimeInterval current = CMTimeGetSeconds(time);
            NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            if ([weakSelf.delegate respondsToSelector:@selector(playerCoordinatorPlayerProgress:)]) {
                [weakSelf.delegate playerCoordinatorPlayerProgress:(current / total)];
            }
        }];
    }
}

- (void)pause {
    [self.player pause];
    [self.player removeTimeObserver:self.progressObserver];
}

- (void)end {
    [self.player removeTimeObserver:self.progressObserver];
    [self.player seekToTime:kCMTimeZero];
    if ([self.delegate respondsToSelector:@selector(playerCoordinatorPlayEnd)]) {
        [self.delegate playerCoordinatorPlayEnd];
    }
}

#pragma mark - Get

- (AVPlayerItem *)platerItem {
    if (_platerItem) return _platerItem;
    
    AVAsset *avAsset = [AVURLAsset URLAssetWithURL:[IDFileManager tempFileURL] options:nil];
    _platerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    return _platerItem;
}

- (AVPlayer *)player {
    if (_player) return _player;
    
    _player = [AVPlayer playerWithPlayerItem:self.platerItem];
    return _player;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
