//
//  MarqueeView.m
//  Marquee(Up and Down)
//
//  Created by 花花 on 2017/8/15.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "MarqueeView.h"
#import "UIView+HHAddition.h"
#import "TextScrollView.h"

static NSInteger TAG = 32250;

@interface MarqueeView()

@property(assign, nonatomic)int index;
@property (nonatomic) NSArray *titles;
/**第一个*/
@property(nonatomic)TextScrollView *firstBtn;
/**更多个*/
@property(nonatomic)TextScrollView *moreBtn;
@property(nonatomic, strong) NSTimer *timer;
@end
@implementation MarqueeView

#pragma mark - init Methods
-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        self.clipsToBounds = YES;
        self.index = 0;
        self.firstBtn = [self btnframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height)  titleColor:_titleColor action:@selector(clickBtn:)];
        self.firstBtn.tag = self.index+TAG;
        [self addSubview:self.firstBtn];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextAd) userInfo:nil repeats:YES];
        
    }
    
    return self;
}

#pragma mark - SEL Methods
-(void)nextAd{
    TextScrollView *firstBtn = [self viewWithTag:self.index+TAG];
    self.moreBtn = [self btnframe: CGRectMake(0, self.bounds.size.height,[UIScreen mainScreen].bounds.size.width , self.bounds.size.height)
                       titleColor:_titleColor
                           action:@selector(clickBtn:)];
    self.moreBtn.tag = (self.index + 1 == self.titles.count ? 0 : self.index + 1)+TAG;

    if (self.titles.count == 0) {
        return;
    }
    [self.moreBtn setText:self.titles[self.index+1 == self.titles.count?0:self.index+1]];
    [self addSubview:self.moreBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        firstBtn.y = -self.bounds.size.height;
        self.moreBtn.y = 0;
        
    } completion:^(BOOL finished) {
        [firstBtn removeFromSuperview];
        
    } ];
    self.index++;
    if (self.index == self.titles.count) {
        self.index = 0;
    }
    
}
-(void)clickBtn:(UIButton *)btn{
    
    if (self.handlerTitleClickCallBack) {
        self.handlerTitleClickCallBack(btn.tag-TAG);
    }
}

#pragma mark - Custom Methods
- (TextScrollView *)btnframe:(CGRect)frame  titleColor:(UIColor *)titleColor action:(SEL)action{
    
    TextScrollView *btn = [TextScrollView instance];
    btn.frame = frame;
    [btn addTager:self action:action];
    return btn;
}
#pragma mark - Setter && Getter Methods
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
}
- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
}
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    if (titles.count == 0) {
        return;
    }
    TextScrollView *scrollView = [self viewWithTag:TAG];
    [scrollView setText:_titles[0]];
}

@end
