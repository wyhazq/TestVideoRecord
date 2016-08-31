//
//  NRDVideoRecordVC.m
//  TestVideoRecord
//
//  Created by wyh on 16/8/18.
//  Copyright © 2016年 wyh. All rights reserved.
//

#import "NRDVideoRecordVC.h"
#import "IDCaptureSessionAssetWriterCoordinator.h"
#import "IDFileManager.h"
#import "IDPermissionsManager.h"

const CGFloat MaxVideoRecordTime = 60.f;    //最大录制时间
const CGFloat TimerInterval = 0.1f;        //倒计时间隔

@interface NRDVideoRecordVC ()<IDCaptureSessionCoordinatorDelegate>

@property (nonatomic, strong) IDCaptureSessionCoordinator *captureSessionCoordinator;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat currentTime;

@end

@implementation NRDVideoRecordVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkPermissions];
    
    [self.captureSessionCoordinator setDelegate:self callbackQueue:dispatch_get_main_queue()];
    
    AVCaptureVideoPreviewLayer *previewLayer = [_captureSessionCoordinator previewLayer];
    previewLayer.frame = self.recordView.bounds;
    [self.recordView.layer addSublayer:previewLayer];
    
    [self.captureSessionCoordinator startRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currentTime = 0;
    self.progressView.progress = 0;
}

#pragma mark - IDCaptureSessionCoordinatorDelegate

- (void)coordinatorDidBeginRecording:(IDCaptureSessionCoordinator *)coordinator {
    [self startTimer];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.actionButton.selected = YES;
}

- (void)coordinator:(IDCaptureSessionCoordinator *)coordinator didFinishRecordingToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error {
    [self stopTimer];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.actionButton.selected = NO;
    [self performSegueWithIdentifier:@"NRDVideoPlayerVCSegue" sender:self];
}

#pragma mark - Action

- (IBAction)exit:(UIButton *)sender {
    [self.captureSessionCoordinator stopRecording];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recordOrStop:(UIButton *)sender {
    sender.selected ? [self stopRecord] : [self startRecord];
}

- (void)startRecord {
    [self.captureSessionCoordinator startRecording];
}

- (void)stopRecord {
    [self.captureSessionCoordinator stopRecording];
}

#pragma mark - Timer

- (void)startTimer {
    self.currentTime = 0;
    self.progressView.progress = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)onTimer:(NSTimer *)timer {
    self.currentTime += TimerInterval;
    [self.progressView setProgress:self.currentTime / MaxVideoRecordTime animated:YES];
    
    //时间到了停止录制视频
    if (self.currentTime >= MaxVideoRecordTime) {
        [self stopRecord];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Get

- (IDCaptureSessionCoordinator *)captureSessionCoordinator {
    if (_captureSessionCoordinator) return _captureSessionCoordinator;
    
    _captureSessionCoordinator = [IDCaptureSessionAssetWriterCoordinator new];
    return _captureSessionCoordinator;
}

#pragma mark - Helper

- (void)checkPermissions {
    IDPermissionsManager *pm = [IDPermissionsManager new];
    [pm checkCameraAuthorizationStatusWithBlock:^(BOOL granted) {
        if(!granted){
            NSLog(@"we don't have permission to use the camera");
        }
    }];
    [pm checkMicrophonePermissionsWithBlock:^(BOOL granted) {
        if(!granted){
            NSLog(@"we don't have permission to use the microphone");
        }
    }];
}

@end
