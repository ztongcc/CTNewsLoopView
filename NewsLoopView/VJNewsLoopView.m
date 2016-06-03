//
//  VJNewsLoopView.m
//  VJWealth
//
//  Created by Admin on 16/5/30.
//  Copyright © 2016年 Excalibur-Tong. All rights reserved.
//

#import "VJNewsLoopView.h"

#define LABELTAG 1000


@interface VJNewsLoopView ()
{
    UIScrollView *abstractScrollview;
    CGPoint _offsetpy;
    NSInteger autoIndex;
    CGFloat _height;
    CGFloat _width;
    NSTimer *m_timer;
}

@property (nonatomic, strong) UIImageView * indatiorIV;

@property (nonatomic, assign) VJNewsLoopViewScrollDirection loopViewScrollDirection;

/**
 *   当前位置
 */
@property(nonatomic,readonly) CGPoint  currentOffset;

/**
 *  返回数据
 */
@property(nonatomic,strong) NSMutableArray *itemArray;

- (void)makeselfUI;

@end

@implementation VJNewsLoopView

- (NSUInteger)itemsCount
{
    NSUInteger itemCount = (_itemArray.count == 1)?1:(_itemArray.count+1);
    return itemCount;
}

-(void)makeselfUI
{
    autoIndex=0;

    if (_indicatorImage) {
        self.indatiorIV.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(_indatiorIV.bounds), 0, CGRectGetWidth(_indatiorIV.bounds), CGRectGetHeight(self.frame));
        [self addSubview:self.indatiorIV];
    }
    
    if (abstractScrollview)
    {
        [abstractScrollview removeFromSuperview];
        abstractScrollview = nil;
    }

    CGSize contSize;
    // 根据滚动方向设置ContentSize
    if (self.loopViewScrollDirection == VJNewsLoopViewScrollDirectionVertical)
    {
        contSize = CGSizeMake(self.frame.size.width, (self.itemsCount*_height));
    }
    else
    {
        contSize = CGSizeMake(self.itemsCount *_width, self.frame.size.height);
    }

    abstractScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(_leadSpace, 0,_width , _height)];
    [self addSubview:abstractScrollview];
    abstractScrollview.showsVerticalScrollIndicator = NO;
    [abstractScrollview setContentSize:contSize];

    for (int i=0; i< [_itemArray count]; i++)
    {
        id <VJNewsItemsProtocol> obj = [_itemArray objectAtIndex:i];

        NSAssert([obj conformsToProtocol:@protocol(VJNewsItemsProtocol)], @"传入的数据源必须实现 VJNewsItemsProtocol 协议");
        
        CGRect labelFram;
        // 根据滚动方向设置ContentSize
        if (self.loopViewScrollDirection == VJNewsLoopViewScrollDirectionVertical)
        {
            labelFram = CGRectMake(0, _height*i, _width, _height);
        }
        else
        {
            labelFram = CGRectMake(_width*i, 0, _width, _height);
        }

        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFram];
        [label setText:obj.title];
        label.font = self.font;
        label.textColor= self.textColor;
        label.tag = LABELTAG+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInLabel:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        [abstractScrollview addSubview:label];

        if (i== [_itemArray count] -1 && [_itemArray count] != 1)
        {

            id <VJNewsItemsProtocol> obj = [_itemArray objectAtIndex:0];

            CGRect lastFrame;

            if (self.loopViewScrollDirection == VJNewsLoopViewScrollDirectionVertical)
            {
                lastFrame = CGRectMake(0, _height*(i+1), _width, _height);
            }
            else
            {
                lastFrame = CGRectMake(_width*(i+1), 0, _width, _height);
            }
            UILabel *labelLast=[[UILabel alloc] initWithFrame:lastFrame];
            [labelLast setText:obj.title];
            labelLast.tag=LABELTAG+i+1;
            labelLast.font = self.font;
            labelLast.textColor= self.textColor;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInLabel:)];
            [label addGestureRecognizer:tap];
            label.userInteractionEnabled = YES;
            [abstractScrollview addSubview:labelLast];
        }
    }

    abstractScrollview.contentOffset=CGPointMake(0, 0);
    
   
}

- (void)tapInLabel:(UITapGestureRecognizer*)tap
{
    if (self.didSelectItemAtIndexHandler)
    {
        NSInteger index = tap.view.tag-LABELTAG;
        self.didSelectItemAtIndexHandler(self,index, [_itemArray[index] copy]);
    }

    NSLog(@"%d",tap.view.tag-LABELTAG);

}

-(CGPoint)currentOffset
{
    return _offsetpy;
}


- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray*)teams
                    direction:(VJNewsLoopViewScrollDirection)scrollDirection
                        block:(void (^)(VJNewsLoopView * loopView, NSInteger index, id<VJNewsItemsProtocol> itemObj))block

{
    self = [super initWithFrame:frame];
    if (self)
    {
        _itemArray      = [teams mutableCopy];
        _offsetpy       = CGPointMake(0, 0);

        self.leadSpace  = 5;
        self.trailSpace = 5;
        
        self.rollInterval = 3;
        self.animationInterval = 0.8;

        _width          = self.frame.size.width - _leadSpace - _trailSpace - CGRectGetWidth(self.indatiorIV.bounds);
        _height         = self.frame.size.height;

        assert([teams count]!=0);
        self.loopViewScrollDirection = scrollDirection;
        self.didSelectItemAtIndexHandler = block;

        self.font = [UIFont systemFontOfSize:16];
        self.textColor = [UIColor blackColor];

    }
    return self;
}

- (void)adjustUISpace
{
    CGFloat indicatorWidth = 0.0;
    if (_indicatorImage) {
         indicatorWidth = CGRectGetWidth(self.indatiorIV.bounds);
    }
    _width          = self.frame.size.width - _leadSpace - _trailSpace - indicatorWidth;
    _height         = self.frame.size.height;

}

/**
 *  开始时间
 */
- (void)start
{
    if (m_timer == nil && self.itemsCount != 1)
    {
        m_timer = [NSTimer timerWithTimeInterval:_rollInterval target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
    }
}

/**
 *  停止时间
 */
- (void)stop
{
    if ([m_timer isValid])
    {
        [m_timer invalidate];
        m_timer = nil;
    }
}

- (void)updateTitle
{
    // 起始位置
    UIView *topLabel = (UIView *)[abstractScrollview viewWithTag:LABELTAG];
    CGPoint point1 = CGPointMake(0, 0);
    point1 = topLabel.frame.origin;

    // 最后标签位置
    UIView *lastlabel=(UIView *)[abstractScrollview viewWithTag:LABELTAG+[_itemArray count]];

    // 当前标签位置
    CGPoint point = [abstractScrollview contentOffset];

    CGPoint pointmiddle=CGPointMake(0,0);

    if (self.loopViewScrollDirection == VJNewsLoopViewScrollDirectionVertical)
    {
        if (point.y >=lastlabel.frame.origin.y)
        {
            autoIndex=0;
            abstractScrollview.contentOffset = point1;
        }

        UIView *view=(UIView*)[abstractScrollview viewWithTag:autoIndex+LABELTAG+1];
        pointmiddle=CGPointMake(0, view.frame.origin.y);
    }
    else
    {
        if (point.x >=lastlabel.frame.origin.x)
        {
            autoIndex=0;
            abstractScrollview.contentOffset = point1;
        }
        UIView *view=(UIView*)[abstractScrollview viewWithTag:autoIndex+LABELTAG+1];
        pointmiddle=CGPointMake(view.frame.origin.x, 0);
    }


    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_animationInterval];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];

    autoIndex +=1;
    abstractScrollview.contentOffset = pointmiddle;

    [UIView commitAnimations];

}

- (void)updateItems:(NSArray *)items
{
    _itemArray = [items mutableCopy];
    [self startLoopAnimation];
}

- (void)updateAndDeleteIndex:(NSInteger)index
{
    [_itemArray removeObjectAtIndex:index];
    [self startLoopAnimation];
}

- (void)reStart
{
    [self startLoopAnimation];
}

- (void)startLoopAnimation
{
    [self adjustUISpace];
    [self makeselfUI];
    [self start];
}
/**
 *  关闭时间
 */
-(void)stopLoopAnimation
{
    [self stop];
}

- (void)setIndicatorImage:(UIImage *)indicatorImage
{
    _indicatorImage = indicatorImage;
    self.indatiorIV.image = indicatorImage;
}

- (UIImageView *)indatiorIV
{
    if (_indatiorIV == nil) {
        self.indatiorIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 18)];
        _indatiorIV.backgroundColor = [UIColor clearColor];
        _indatiorIV.contentMode = UIViewContentModeCenter;
    }
    return _indatiorIV;
}

-(void)dealloc
{
    [self stop];
}


@end
