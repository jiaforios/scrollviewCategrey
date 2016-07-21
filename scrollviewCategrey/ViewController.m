//
//  ViewController.m
//  scrollviewCategrey
//
//  Created by foscom on 16/7/19.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+_DScrollView.h"
@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *sc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, 375, 300)];

    for (int i=0; i<9; i++) {
        
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(i *375, 0, 375, 300)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        label.text = [@(i) stringValue];
        [view addSubview:label];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255. green:arc4random()%256/255. blue:arc4random()%256/255. alpha:1];
        [_sc addSubview:view];
        
    }
    _sc.contentSize = CGSizeMake(375*9, 0);
    _sc.delegate = self;
    _sc.pagingEnabled = YES;
    
    /**
     *  添加 3d 效果
     */
    
    _sc.dScrollView = YES;
    
    
    [self.view addSubview:_sc];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"page = %lu",(unsigned long)scrollView.pageNum);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
