//
//  UIScrollView+_DScrollView.m
//  scrollviewCategrey
//
//  Created by foscom on 16/7/19.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "UIScrollView+_DScrollView.h"


@implementation UIScrollView (_DScrollView)

#define screen_width   [UIScreen mainScreen].bounds.size.width
#define screen_height  [UIScreen mainScreen].bounds.size.height

@dynamic dScrollView;
@dynamic pageNum;
NSUInteger _pagenum; // 当前页
CGFloat _rightScale;  // 右视图占比
CGFloat _leftScale;    // 左视图占比
NSUInteger _leftPagenum;  // 左侧的页码
NSUInteger _rigthPagenum;  // 右侧的页码


- (void)setDScrollView:(BOOL)dScrollView
{
    if (dScrollView) {
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }else
    {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    
}

- (void)setPageNum:(NSUInteger)pageNum
{
  _pagenum = pageNum;
}

- (NSUInteger)pageNum
{
    return _pagenum;
}

- (void)setLeftScale:(CGFloat)leftScale
{
    _leftScale = leftScale;
}

- (CGFloat)leftScale
{
    return _leftScale;
}
- (void)setRightScale:(CGFloat)rightScale
{
    _rightScale = rightScale;
}
- (CGFloat)rightScale
{
    return _rightScale;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset_new = [change[@"new"] CGPointValue];
//        CGPoint offset_old = [change[@"old"] CGPointValue];
//        NSLog(@"offset_new = %f",offset_new.x);
        _leftPagenum = (NSUInteger)(offset_new.x) / (NSUInteger)screen_width;
        _rigthPagenum = _leftPagenum  + 1;
        _rightScale = (offset_new.x/screen_width)- _leftPagenum;
        _leftScale = 1-_rightScale;
        [self dealWithleftValue:_leftScale andRightValue:_rightScale];
        _pagenum = offset_new.x/375;
    }
}

/**
 *  获取当前屏幕显示的两张视图的 屏占比
 *
 *  @param leftvalue  左侧即将消失的视图的占比
 *  @param rightValue 右侧即将出现的视图的占比
 */

- (void)dealWithleftValue:(CGFloat)leftvalue andRightValue:(CGFloat)rightValue
{
    NSLog(@"left value  = %f left page = %d, right value = %f,rigth page = %d",leftvalue,_leftPagenum,rightValue,_rigthPagenum);
}


@end

