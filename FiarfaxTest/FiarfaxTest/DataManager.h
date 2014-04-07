//
//  DataManager.h
//  FiarfaxTest
//
//  Created by Loren Chen on 11/02/2014.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

- (BOOL)requestImage:(NSString*)imageUrl delegate:(id)delegate;

- (void)clearRequest;

@end
