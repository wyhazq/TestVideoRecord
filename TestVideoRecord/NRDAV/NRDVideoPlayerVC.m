//
//  NRDVideoPlayerVC.m
//  TestVideoRecord
//
//  Created by wyh on 16/8/18.
//  Copyright © 2016年 wyh. All rights reserved.
//

#import "NRDVideoPlayerVC.h"
#import "NRDPlayerCoordinator.h"
#import "IDFileManager.h"

@interface NRDVideoPlayerVC ()<NRDPlayerCoordinatorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UIView *playerView;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *playerButton;

@property (nonatomic, strong) NRDPlayerCoordinator *playerCoordinator;

@end

@implementation NRDVideoPlayerVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.playerCoordinator.player];
    playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer insertSublayer:playerLayer atIndex:0];
    self.playerCoordinator.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayerView:)];
    [self.playerView addGestureRecognizer:tapGesture];
    
    self.sizeLabel.text = [IDFileManager fileSize];
}

#pragma mark - Action

- (IBAction)play:(UIButton *)sender {
    [self.playerCoordinator play];
    sender.hidden = YES;
}

- (void)tapPlayerView:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self.playerCoordinator pause];
        self.playerButton.hidden = NO;
    }
}

- (IBAction)exit:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get

- (NRDPlayerCoordinator *)playerCoordinator {
    if (_playerCoordinator) return _playerCoordinator;
    
    _playerCoordinator = [[NRDPlayerCoordinator alloc] init];
    return _playerCoordinator;
}

#pragma mark - NRDPlayerCoordinatorDelegate

- (void)playerCoordinatorPlayerProgress:(CGFloat)progress {
    self.progressView.progress = progress;
}

- (void)playerCoordinatorPlayEnd {
    self.playerButton.hidden = NO;
    self.progressView.progress = 0;
}

@end
