//
//  MarqueeView.h
//  Marquee(Up and Down)
//
//  Created by 花花 on 2017/8/15.
//  Copyright © 2017年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarqueeView : UIView
/** 标题的字体 默认为14 */
@property(nonatomic)UIFont *titleFont;
/**标题的颜色 默认红色*/
@property(nonatomic)UIColor *titleColor;
//回调
@property(nonatomic,copy)void(^handlerTitleClickCallBack)(NSInteger index);

#pragma mark - init Methods
-(instancetype)initWithFrame:(CGRect)frame;
- (void)setTitles:(NSArray *)titles;
@end
