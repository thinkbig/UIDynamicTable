//
//  BeefInfo.h
//  ListViewJson
//
//  Created by Loren Chen on 10/02/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineInfo : NSObject

@property (nonatomic, retain) NSString *webHref;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, retain) NSString *headLine;
@property (nonatomic, retain) NSString *slugLine;
@property (nonatomic, retain) NSString *dateLine;
@property (nonatomic, retain) NSString *tinyUrl;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *thumbnailImageHref;
@property (nonatomic, retain) UIImage *thumbnail;

/**
 * Try to Create a new instance of BeefInfo.
 * If dict is not nil or no content, return nil.
 */
+ (LineInfo*)fromJson:(NSDictionary*)dict;

- (BOOL)isThumbnailEmpty;

@end
