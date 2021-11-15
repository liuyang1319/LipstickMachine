//
//  NSObject+GetTableView.h
//  PipixiaTravel
//
//  Created by admin on 2017/7/13.
//  Copyright © 2017年 easyto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (GetTableView)

- (void)getTopTableView:(void(^)(UITableView *))complation;
- (void)getTopCollectionView:(void(^)(UICollectionView *))complation;
- (void)getScrollView:(void(^)(UIScrollView *))complation;

@end
