//
//  MyLockView.m
//  GestureDeblocking
//
//  Created by 王志盼 on 15/5/3.
//  Copyright (c) 2015年 王志盼. All rights reserved.
//

#import "MyLockView.h"
#import "MyCircleButton.h"
@interface MyLockView ()
@property (nonatomic, strong) NSMutableArray *selectedButton;

@property (nonatomic, assign) CGPoint point;
@end

@implementation MyLockView

- (NSMutableArray *)selectedButton
{
    if (_selectedButton == nil) {
        _selectedButton = [NSMutableArray array];
    }
    return _selectedButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    for (int i = 0;i < 9; i++)
    {
        MyCircleButton *button = [[MyCircleButton alloc] init];
        button.tag = i;
        [self addSubview:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int index = 0; index<self.subviews.count; index++) {
        MyCircleButton *btn = self.subviews[index];
        
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        
        int totalColumns = 3;
        int col = index % totalColumns;
        int row = index / totalColumns;
        CGFloat marginX = (self.frame.size.width - totalColumns * btnW) / (totalColumns + 1);
        CGFloat marginY = marginX;
        
        CGFloat btnX = marginX + col * (btnW + marginX);
        CGFloat btnY = row * (btnH + marginY);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}

- (MyCircleButton *)buttonWithPoint:(CGPoint)currentPoint
{
    MyCircleButton *button = nil;
    
    for (int i = 0; i < self.subviews.count; i++) {
        if (CGRectContainsPoint([self.subviews[i] frame], currentPoint)) {
            
            button = self.subviews[i];
            break;
            
        }
    }
    return button;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.point = CGPointZero;
    
    CGPoint currentPoint = [self pointWithTouches:touches];
    
    MyCircleButton *button = [self buttonWithPoint:currentPoint];
    
    if (button && button.selected == NO) {
        button.selected = YES;
        
        [self.selectedButton addObject:button];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [self pointWithTouches:touches];
    
    MyCircleButton *button= [self buttonWithPoint:currentPoint];
    
    if (button && button.selected == NO) {
        button.selected = YES;
        
        [self.selectedButton addObject:button];
    }else{
        self.point = currentPoint;
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(LockView: path:)]) {
        
        NSMutableString *path = [NSMutableString string];
        for (int i = 0; i < self.selectedButton.count; i++) {
            MyCircleButton *button = self.selectedButton[i];
            [path appendFormat:@"%d", (int)button.tag];
        }
        [self.delegate LockView:self path:path];
    }
    
    for (int i = 0; i < self.selectedButton.count; i++) {
        MyCircleButton *button = self.selectedButton[i];
        button.selected = NO;
    }
    [self.selectedButton removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    if (self.selectedButton.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int index = 0; index<self.selectedButton.count; index++) {
        MyCircleButton *btn = self.selectedButton[index];
        
        if (index == 0) {
            [path moveToPoint:btn.center];
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    
    if (CGPointEqualToPoint(self.point, CGPointZero) == NO) {
        [path addLineToPoint:self.point];
    }
    

    path.lineWidth = 7;
    path.lineJoinStyle = kCGLineJoinBevel;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path stroke];
}
@end
