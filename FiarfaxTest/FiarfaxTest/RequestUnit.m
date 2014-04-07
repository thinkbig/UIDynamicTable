//
//  RequestUnit.m
//  FiarfaxTest
//
//  Created by Loren Chen on 11/02/2014.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "RequestUnit.h"

@implementation RequestUnit

@synthesize requestUrl = _requestUrl;
@synthesize image = _image;
@synthesize delegate = _delegate;

- (id)initWithUrl:(NSString *)requestUrl
{
    self = [super init];
    if (nil != self) {
        self.requestUrl = requestUrl;
        self.image = nil;
        self.delegate = nil;
    }
    
    return self;
}

- (void)dealloc
{
    // Release the memory.
    self.requestUrl = nil;
    self.image = nil;
    self.delegate = nil;
    
    [super dealloc];
}

@end
