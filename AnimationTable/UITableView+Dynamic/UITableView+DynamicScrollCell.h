//
//  UITableView+DynamicScrollCell.h
//  FiarfaxTest
//
//  Created by alex tao on 2/25/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (DynamicScrollCell)

- (CGFloat)dynamicLastContentOffset;
- (void)setDynamicLastContentOffset:(CGFloat)offset;

@end
