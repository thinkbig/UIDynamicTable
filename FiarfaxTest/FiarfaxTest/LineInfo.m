//
//  BeefInfo.m
//  ListViewJson
//
//  Created by Loren Chen on 10/02/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "LineInfo.h"

@implementation LineInfo

@synthesize webHref = _webHref;
@synthesize identifier = _identifier;
@synthesize headLine = _headLine;
@synthesize slugLine = _slugLine;
@synthesize dateLine = _dateLine;
@synthesize tinyUrl = _tinyUrl;
@synthesize type = _type;
@synthesize thumbnailImageHref = _thumbnailImageHref;
@synthesize thumbnail = _thumbnail;

- (id)init
{
    self = [super init];
    if( nil != self ) {
        self.webHref = nil;
        self.headLine = nil;
        self.slugLine = nil;
        self.dateLine = nil;
        self.tinyUrl = nil;
        self.type = nil;
        self.thumbnailImageHref = nil;
        self.thumbnail = nil;

    }
    
    return self;
}

- (void)dealloc
{
    self.webHref = nil;
    self.headLine = nil;
    self.slugLine = nil;
    self.dateLine = nil;
    self.tinyUrl = nil;
    self.type = nil;
    self.thumbnailImageHref = nil;
    self.thumbnail = nil;
    
    [super dealloc];
}

- (BOOL)isThumbnailEmpty
{
    return ((nil == self.thumbnailImageHref) || ([self.thumbnailImageHref isKindOfClass:[NSNull class]]) || ([self.thumbnailImageHref length] <= 0) || (![self.thumbnailImageHref hasPrefix:@"http://"]));
}

+ (LineInfo*)fromJson:(NSDictionary *)dict
{
    if ((nil == dict) || ([dict count] <= 0)) {
        return nil;
    }
    
    LineInfo *entity = [[[LineInfo alloc] init] autorelease];
    
    entity.webHref = [dict objectForKey:@"webHref"];
    entity.identifier = [[dict objectForKey:@"identifier"] intValue];
    entity.headLine = [dict objectForKey:@"headLine"];
    entity.slugLine = [dict objectForKey:@"slugLine"];
    entity.dateLine = [dict objectForKey:@"dateLine"];
    entity.tinyUrl = [dict objectForKey:@"tinyUrl"];
    entity.type = [dict objectForKey:@"type"];
    entity.thumbnailImageHref = [dict objectForKey:@"thumbnailImageHref"];
    if ([entity.thumbnailImageHref isKindOfClass:[NSNull class]]) {
        entity.thumbnailImageHref = nil;
    }
    
    return entity;
}

@end
