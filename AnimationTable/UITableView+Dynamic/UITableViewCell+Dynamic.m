//
//  UITableViewCell+Dynamic.m
//  FiarfaxTest
//
//  Created by alex tao on 2/24/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "UITableViewCell+Dynamic.h"
#import "NSObject+RuntimeSwizzle.h"

static NSString * KMyAnimatorKey = @"KMyAnimatorKey";

@interface RecycleAnimator : NSObject
@end

@implementation RecycleAnimator

+ (RecycleAnimator *)sharedInstance
{
    static RecycleAnimator *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[RecycleAnimator alloc] init];
    });
    return sharedInstance;
}

- (void) recycle:(UIDynamicAnimator*)animator {
    if (animator) {
        __block UIDynamicAnimator * lazyReleaseAnimator = animator;
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            lazyReleaseAnimator = nil;
        });
    }
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface LiveLongerObject : NSObject <UIDynamicAnimatorDelegate>
@property (nonatomic, retain) UIDynamicAnimator * animator;
@end

@implementation LiveLongerObject

- (void)dealloc {
    [[RecycleAnimator sharedInstance] recycle:_animator];
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UITableViewCell (Dynamic)

- (void)setDynamicAnimator:(UIDynamicAnimator*)animator {
    LiveLongerObject * liveObj = [[LiveLongerObject alloc] init];
    liveObj.animator = animator;
    objc_setAssociatedObject(self, &KMyAnimatorKey, liveObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIDynamicAnimator*)dynamicAnimator {
    return ((LiveLongerObject*)objc_getAssociatedObject(self, &KMyAnimatorKey)).animator;
}

- (void)__DynamicLayoutSubviews__
{
    [self __DynamicLayoutSubviews__];
    
    if ([self isKindOfClass:[UITableViewCell class]]) {
        self.contentView.superview.clipsToBounds = NO;
        UIDynamicAnimator * animator = [self dynamicAnimator];
        if (nil == animator) {
            animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
            [self setDynamicAnimator:animator];
        }
        if (animator.behaviors.count == 0) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:self.contentView attachedToAnchor:[self.contentView center]];
            spring.length = 0.0;
            spring.damping = 0.5;
            spring.frequency = 0.8;
            [animator addBehavior:spring];
        } else {
            UIAttachmentBehavior *spring = [animator.behaviors lastObject];
            spring.anchorPoint = [self.contentView center];
        }
    }
}


+ (void)load {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self swizzle:[self class] with:@selector(layoutSubviews) and:@selector(__DynamicLayoutSubviews__)];
    }
}

@end
