//
//  RequestUnit.h
//  FiarfaxTest
//
//  Created by Loren Chen on 11/02/2014.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestDelegate <NSObject>

- (void)didReceiveImage:(UIImage*)image forUrl:(NSString*)url;

@end

@interface RequestUnit : NSObject

@property (nonatomic, retain) NSString *requestUrl;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id<RequestDelegate> delegate;

- (id)initWithUrl:(NSString*)requestUrl;

@end
