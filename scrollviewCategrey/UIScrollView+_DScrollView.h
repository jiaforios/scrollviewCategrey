//
//  UIScrollView+_DScrollView.h
//  scrollviewCategrey
//
//  Created by foscom on 16/7/19.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (_DScrollView)
@property(nonatomic,assign)BOOL dScrollView;
@property(nonatomic,assign)NSUInteger pageNum;
@property(nonatomic,assign)CGFloat rightScale;
@property(nonatomic,assign)CGFloat leftScale;

@end
