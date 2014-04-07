//
//  UITableViewCell+Dynamic.h
//  FiarfaxTest
//
//  Created by alex tao on 2/24/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Dynamic)

- (void)setDynamicAnimator:(UIDynamicAnimator*)animator;
- (UIDynamicAnimator*)dynamicAnimator;

@end
