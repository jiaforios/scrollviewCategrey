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
CGFloat _scaleFloat = 0.25;
BOOL dscroll = NO;
NSUInteger _leftPagenum;  // 左侧的页码
NSUInteger _rigthPagenum;  // 右侧的页码
NSMutableArray *mArray;



- (void)make3Dscrollview
{
    self.dScrollView = YES;
}

- (void)setDScrollView:(BOOL)dScrollView
{
    dscroll = dScrollView;
    if (dScrollView) {
        mArray = [[NSMutableArray alloc] init];
        mArray = [self.subviews mutableCopy];
        
        [mArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
            UIView *view1 = obj1;
            UIView *view2 = obj2;
            if (view1.frame.origin.x > view2.frame.origin.x) {
                
                return NSOrderedDescending;
            }
            if (view1.frame.origin.x < view2.frame.origin.x) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        
        [mArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *view = (UIView*)obj;
            view.layer.cornerRadius = 10;
            view.clipsToBounds = YES;
            
        }];
        
        id observer = [self observationInfo];
        NSArray *observerArr = [observer valueForKeyPath:@"_observances"];
        for (id obser in observerArr) {
            
            NSString *keypath = [obser valueForKeyPath:@"_property._keyPath"];
            NSString *observer = [obser valueForKey:@"_observer"];
            if (keypath && observer) {
               [self removeObserver:self forKeyPath:keypath];
            }
        }
        
        
            [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    }else
    {
        
        // tabview 继承 scrollview 会导致观察者引起奔溃
        NSString *classname = NSStringFromClass([self class]);
        
        if (![classname isEqualToString:@"UIScrollView"]) {
            
            return;
        }

        id observer = [self observationInfo];
        NSArray *observerArr = [observer valueForKeyPath:@"_observances"];
        for (id obser in observerArr) {
            
            NSString *keypath = [obser valueForKeyPath:@"_property._keyPath"];
            NSString *observer = [obser valueForKey:@"_observer"];
            if (keypath && observer) {
                [self removeObserver:self forKeyPath:keypath];
            }
        }
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
        _leftPagenum = (NSUInteger)(offset_new.x) / (NSUInteger)screen_width;
        _rigthPagenum = _leftPagenum  + 1;
        _rightScale = (offset_new.x/screen_width)- _leftPagenum;
        _leftScale = 1-_rightScale;
        [self dealWithleftValue:_leftScale andRightValue:_rightScale];
        _pagenum = offset_new.x/screen_width;
        
        [self animationChange];

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
    
//    NSLog(@"left value  = %f left page = %lu, right value = %f,rigth page = %lu",leftvalue,(unsigned long)_leftPagenum,rightValue,(unsigned long)_rigthPagenum);
    
}


-(void)animationChange
{
    for (int i=0; i< mArray.count; i++) {
        [self addTransform:mArray[i]];
    }
}

-(void)addTransform:(UIView*)view
{
    view.layer.transform=[self transFormFrom:view.layer.position.x];
}


// 组合效果
-(CATransform3D)transFormFrom:(CGFloat)position
{
    CGFloat chaFloat=[self positiveFloatFrom:(position-CGRectGetMidX(self.bounds))/self.bounds.size.width];
    
//    NSLog(@"chafloat = %f",chaFloat);
    CGFloat angel=(position-CGRectGetMidX(self.bounds))/self.bounds.size.width*M_PI/10;

    CATransform3D transformlat=CATransform3DMakeTranslation(0, 0, 0);
    CATransform3D transformRotation = CATransform3DIdentity;
    transformRotation.m34= -1/230.0;
    transformRotation=CATransform3DRotate(transformRotation,angel, 0, 1, 0);
    CATransform3D transformScale=CATransform3DMakeScale(1-chaFloat*_scaleFloat, 1-chaFloat*_scaleFloat,1);
    
    return CATransform3DConcat(CATransform3DConcat(transformRotation, transformScale), transformlat);
    
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


-(CGFloat)positiveFloatFrom:(CGFloat)fromFloat
{
    if (fromFloat<0) {
        return -fromFloat;
    }
    return fromFloat;
}


@end

