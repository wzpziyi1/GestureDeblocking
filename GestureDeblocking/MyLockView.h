//
//  MyLockView.h
//  GestureDeblocking
//
//  Created by 王志盼 on 15/5/3.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyLockView;
@protocol  MyLockViewDelegate<NSObject>

@optional
- (void)LockView:(MyLockView *)lockView path:(NSString *)path;
@end

@interface MyLockView : UIButton

@property (nonatomic, weak)id<MyLockViewDelegate> delegate;

@end
