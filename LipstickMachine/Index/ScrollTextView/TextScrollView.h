//
//  TextScrollView.h
//  Marquee(Up and Down)
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextScrollView : UIView
+ (instancetype)instance;
- (void)addTager:(id)tager action:(SEL)action;
- (void)setText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
