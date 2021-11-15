//
//  TextScrollView.m
//  Marquee(Up and Down)
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 花花. All rights reserved.
//

#import "TextScrollView.h"

@interface TextScrollView()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation TextScrollView

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"TextScrollView"
                                          owner:self
                                        options:nil] lastObject];
}

- (void)addTager:(id)tager action:(SEL)action {
    [self.btn addTarget:tager
                 action:action
       forControlEvents:UIControlEventTouchUpInside];
}

- (void)setText:(NSString *)text {
    [self.btn setTitle:text forState:UIControlStateNormal];
}
@end
