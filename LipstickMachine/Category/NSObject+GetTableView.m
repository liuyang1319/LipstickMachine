//
//  NSObject+GetTableView.m
//  PipixiaTravel
//
//  Created by admin on 2017/7/13.
//  Copyright © 2017年 easyto. All rights reserved.
//

#import "NSObject+GetTableView.h"
#import "LipstickMachine-Swift.h"

@implementation NSObject (GetTableView)

- (void)getTopTableView:(void(^)(UITableView *))complation {
    [self getViewWithClass:@"UITableView" complation:^(UIView *view) {
        complation((UITableView *)view);
    }];
}

- (void)getTopCollectionView:(void(^)(UICollectionView *))complation {
    [self getViewWithClass:@"UICollectionView" complation:^(UIView *view) {
        complation((UICollectionView *)view);
    }];
}

- (void)getScrollView:(void(^)(UIScrollView *))complation {
    [self getViewWithClass:@"UIScrollView" complation:^(UIView *view) {
        complation((UIScrollView *)view);
    }];
}

#pragma mark ---
- (void)getViewWithClass:(NSString *)className complation:(void(^)(UIView *view))complation{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        id rootController = app.window.rootViewController;
        UINavigationController *navigation;
        if ([rootController isKindOfClass:NSClassFromString(@"_TtC15LipstickMachine22LYNavigationController")]) {
            navigation = rootController;
        } else if ([rootController isKindOfClass:NSClassFromString(@"_TtC15LipstickMachine18LYTabbarController")]) {
            LYTabbarController *tabbar = (LYTabbarController *)rootController;
            navigation = tabbar.selectedViewController;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                complation(nil);
            });
        }
        
        UIViewController *controller = navigation.topViewController;
        UIView *view = controller.view;
        UIView *complationView;
        
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:NSClassFromString(className)]) {
                complationView = subView;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complation(complationView);
        });
}

@end
