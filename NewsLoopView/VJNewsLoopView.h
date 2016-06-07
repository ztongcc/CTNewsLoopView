//
//  VJNewsLoopView.h
//  VJWealth
//
//  Created by Admin on 16/5/30.
//  Copyright © 2016年 Excalibur-Tong. All rights reserved.
//
#import <UIKit/UIKit.h>

/**
    滑动方向
 */
typedef NS_ENUM(NSInteger, VJNewsLoopViewScrollDirection)
{
    /**
     *  竖直方向
     */
    VJNewsLoopViewScrollDirectionVertical,
    /**
     *  水平方向
     */
    VJNewsLoopViewScrollDirectionHorizontal,
};

@protocol VJNewsItemsProtocol <NSObject>
@required
// 显示文本
- (NSString *)title;

@end



@interface VJNewsItem : NSObject <VJNewsItemsProtocol>

@property (nonatomic,   copy)NSString * title;
@property (nonatomic,   copy)NSString * itemId;
@property (nonatomic, assign)BOOL       isClick;

@end




@interface VJNewsLoopView : UIView
/**
 *  文本字体
 */
@property (nonatomic, strong)UIFont * font;
/**
 *  文本颜色
 */
@property (nonatomic, strong)UIColor * textColor;
/**
 *  首部预留空间
 */
@property (nonatomic, assign)CGFloat leadSpace;

/**
 *  尾部预留空间有图片的话据图片的距离
 */
@property (nonatomic, assign)CGFloat trailSpace;
/**
 *  滚动间隔 默认 3 秒
 */
@property (nonatomic, assign)CGFloat rollInterval;

/**
 *  动画时间 默认 0.8 秒
 */
@property (nonatomic, assign)CGFloat animationInterval;
/**
 *  最右边图片名字
 */
@property (nonatomic, strong)UIImage * indicatorImage;

/**
 *   block监听点击方式
 */
@property (nonatomic, copy) void (^didSelectItemAtIndexHandler)(VJNewsLoopView * loopView, NSInteger index, id <VJNewsItemsProtocol> itemObj);

/**
 *  初始化
 *
 *  @param frame           frame大小
 *  @param teams           teams 里面包含的是 对象实现 <VJNewsItemsProtocol>
 *  @param scrollDirection 滑动方向 默认垂直方向
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray *)teams
                    direction:(VJNewsLoopViewScrollDirection)scrollDirection
                        block:(void (^)(VJNewsLoopView * loopView, NSInteger index, id <VJNewsItemsProtocol> itemObj))block;

/**
 *  更新数据源
 *
 *  @param items
 */
- (void)updateItems:(NSArray *)items;
/**
 *  删除某一条数据
 *
 *  @param index 数据索引
 */
- (void)updateAndDeleteIndex:(NSInteger)index;
/**
 *  重新开始 (从第一个开始滚动)
 */
- (void)reStartLoop;
/**
 *  开始滚动 在最后调用
 */
- (void)startLoopAnimation;

/**
 *  关闭时间
 */
-(void)stopLoopAnimation;

@end
