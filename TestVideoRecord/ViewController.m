//
//  ViewController.m
//  TestVideoRecord
//
//  Created by wyh on 16/8/18.
//  Copyright © 2016年 wyh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pai:(UIButton *)sender {
    UIStoryboard *avSB = [UIStoryboard storyboardWithName:@"NRDAV" bundle:[NSBundle mainBundle]];
    UINavigationController *navi = [avSB instantiateViewControllerWithIdentifier:@"NRDNavigationController"];
    [self presentViewController:navi animated:YES completion:nil];
    
}

@end
