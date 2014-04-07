//
//  UITableView+DynamicScrollCell.m
//  FiarfaxTest
//
//  Created by alex tao on 2/25/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "UITableView+DynamicScrollCell.h"
#import "NSObject+RuntimeSwizzle.h"
#import "UITableViewCell+Dynamic.h"

static NSString * KMyLastContentOffset = @"KMyLastContentOffset";
static int kObservingContentSizeChangesContext = 912341234;

@implementation UITableView (DynamicScrollCell)

- (void)setDynamicLastContentOffset:(CGFloat)offset {
    objc_setAssociatedObject(self, &KMyLastContentOffset, @(offset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)dynamicLastContentOffset {
    return [objc_getAssociatedObject(self, &KMyLastContentOffset) floatValue];
}

- (id)__DynamicInitWithCoder__:(NSCoder *)aDecoder
{
    id returnSelf = [self __DynamicInitWithCoder__:aDecoder];
    [self addObserver:self forKeyPath:@"contentOffset" options:0 context:&kObservingContentSizeChangesContext];
    return returnSelf;
}

- (id)__DynamicInitWithFrame__:(CGRect)frame style:(UITableViewStyle)style
{
    id returnSelf = [self __DynamicInitWithFrame__:frame style:style];
    [self addObserver:self forKeyPath:@"contentOffset" options:0 context:&kObservingContentSizeChangesContext];
    return returnSelf;
}

- (void)__DynamicDealloc__
{
    [self removeObserver:self forKeyPath:@"contentOffset" context:&kObservingContentSizeChangesContext];
    [self __DynamicDealloc__];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingContentSizeChangesContext) {
        UIScrollView *scrollView_ = object;
        UITableView * tableView = nil;
        if ([scrollView_ isKindOfClass:[UITableView class]]) {
            tableView = (UITableView*)scrollView_;
        }
        
        if (tableView)
        {
            CGFloat scrollDelta = [tableView dynamicLastContentOffset] - scrollView_.contentOffset.y;
            [tableView setDynamicLastContentOffset:scrollView_.contentOffset.y];
            if (fabs(scrollDelta) < 1.0f) {
                return;
            }
            
            CGPoint touchLocation = [scrollView_.panGestureRecognizer locationInView:scrollView_];
            NSArray * cells = tableView.visibleCells;
            for (UITableViewCell *cell in cells)
            {
                CGFloat distanceFromTouch = fabsf(touchLocation.y - cell.center.y);
                CGFloat scrollResistance = distanceFromTouch / 900.0; // higher the number, larger the bounce
                
                CGPoint center = cell.contentView.center;
                center.y -= scrollDelta * scrollResistance;
                cell.contentView.center = center;
                
                [[cell dynamicAnimator] updateItemUsingCurrentState:cell.contentView];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (void)load {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self swizzle:[self class] with:@selector(initWithCoder:) and:@selector(__DynamicInitWithCoder__:)];
        [self swizzle:[self class] with:@selector(initWithFrame:style:) and:@selector(__DynamicInitWithFrame__:style:)];
        [self swizzle:[self class] with:NSSelectorFromString(@"dealloc") and:@selector(__DynamicDealloc__)];
    }
}

@end
