//
//  ViewController.m
//  GestureDeblocking
//
//  Created by 王志盼 on 15/5/3.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "ViewController.h"
#import "MyLockView.h"

@interface ViewController () <MyLockViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyLockView *lockView = [[MyLockView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 250)];
    
    [lockView setBackgroundColor:[UIColor blackColor]];
    
    lockView.delegate = self;
    
    [self.view addSubview:lockView];
}

#pragma MyLockViewDelegate

- (void)LockView:(MyLockView *)lockView path:(NSString *)path
{
    NSLog(@"手势路径:%@",path);
}

@end
