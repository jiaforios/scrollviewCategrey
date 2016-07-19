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
    
    _sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
    
    for (int i=0; i<4; i++) {
        
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(i *375, 0, 375, 300)];
        
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255. green:arc4random()%256/255. blue:arc4random()%256/255. alpha:1];
        [_sc addSubview:view];
    }
    _sc.contentSize = CGSizeMake(375*4, 0);
    _sc.delegate = self;
    _sc.dScrollView = YES;
    _sc.pagingEnabled = YES;
    [self.view addSubview:_sc];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"scoage = %d",scrollView.pageNum);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
