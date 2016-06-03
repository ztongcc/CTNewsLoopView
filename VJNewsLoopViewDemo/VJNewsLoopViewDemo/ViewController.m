//
//  ViewController.m
//  VJNewsLoopViewDemo
//
//  Created by Admin on 16/6/3.
//  Copyright © 2016年 Tong. All rights reserved.
//

#import "ViewController.h"
#import <VJNewsLoopView.h>

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    VJNewsItem * item1 = [[VJNewsItem alloc] init];
    item1.title = @"老外的钱真好赚 这样的一台手机都能卖9万元";

    VJNewsItem * item2 = [[VJNewsItem alloc] init];
    item2.title = @"谷歌又调皮了 开发软件帮用户找丢失的iPhone";
    
    VJNewsItem * item3 = [[VJNewsItem alloc] init];
    item3.title = @"卡宴手动挡进中国了？众泰SR8内饰谍照曝光";
    
    VJNewsLoopView * loopView1 = [[VJNewsLoopView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 30) items:@[item1,item2,item3] direction:VJNewsLoopViewScrollDirectionHorizontal block:^(VJNewsLoopView *loopView, NSInteger index, id<VJNewsItemsProtocol> itemObj) {
        NSLog(@" click index %ld  %@ ", index, [itemObj title]);
    }];
    loopView1.indicatorImage = [UIImage imageNamed:@"left"];
    loopView1.textColor = [UIColor whiteColor];
    loopView1.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9];
    [self.view addSubview:loopView1];
    
    [loopView1 startLoopAnimation];

    
    VJNewsItem * item4 = [[VJNewsItem alloc] init];
    item4.title = @"老外的钱真好赚 这样的一台手机都能卖9万元";
    
    VJNewsItem * item5 = [[VJNewsItem alloc] init];
    item5.title = @"谷歌又调皮了 开发软件帮用户找丢失的iPhone";
    
    VJNewsItem * item6 = [[VJNewsItem alloc] init];
    item6.title = @"卡宴手动挡进中国了？众泰SR8内饰谍照曝光";
    
    VJNewsLoopView * loopView2 = [[VJNewsLoopView alloc] initWithFrame:CGRectMake(0, 200, screenWidth, 30) items:@[item4,item5,item6] direction:VJNewsLoopViewScrollDirectionVertical block:^(VJNewsLoopView *loopView, NSInteger index, id<VJNewsItemsProtocol> itemObj) {
        NSLog(@" click index %ld  %@ ", index, [itemObj title]);
    }];
    loopView2.indicatorImage = [UIImage imageNamed:@"left"];
    loopView2.textColor = [UIColor whiteColor];
    loopView2.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.9];
    [self.view addSubview:loopView2];
    
    [loopView2 startLoopAnimation];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
