//
//  DataManager.m
//  FiarfaxTest
//
//  Created by Loren Chen on 11/02/2014.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "DataManager.h"
#import "RequestUnit.h"

@interface DataManager()
{
    NSMutableArray *_unitArray;
    RequestUnit *_active;
    NSMutableData *_responseData;
}

@property (atomic, retain) NSMutableArray *unitArray;
@property (atomic, retain) RequestUnit *active;

@end

@implementation DataManager

@synthesize unitArray = _unitArray;
@synthesize active = _active;

- (id)init
{
    self = [super init];
    if(self) {
        _unitArray = [[NSMutableArray alloc] init];
        _responseData = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [_unitArray release];
    _unitArray = nil;
    
    self.active = nil;
    
    [_responseData release];
    _responseData = nil;
    
    [super dealloc];
}

- (BOOL)requestImage:(NSString *)imageUrl delegate:(id)delegate
{
    if ((nil == imageUrl) || ([imageUrl length] <= 0)) {
        return NO;
    }
    
    // Check whether image exists.
    const NSInteger count = [self.unitArray count];
    for (int nIdx = 0; nIdx < count; nIdx++) {
        RequestUnit *unit = [self.unitArray objectAtIndex:nIdx];
        if ([imageUrl isEqualToString:unit.requestUrl]) {
            return YES;
        }
    }
    
    // Create a new instance of Request Unit.
    RequestUnit *unit = [[RequestUnit alloc] initWithUrl:imageUrl];
    unit.requestUrl = imageUrl;
    unit.delegate = delegate;
    [self.unitArray addObject:unit];
    
    [unit release];
    
    // Try to send request.
    [self sendNextRequest];
    
    return YES;
}

- (void)clearRequest
{
    self.active = nil;
    
    [self.unitArray removeAllObjects];
}

- (void)sendNextRequest
{
    if ([self.unitArray count] <= 0 || (nil != self.active)) {
        return ;
    }
    
    self.active = [self.unitArray objectAtIndex:0];
    [self.unitArray removeObjectAtIndex:0];
    
    // Send the network request to fetch image.
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.active.requestUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];
    if( nil != connection ) {
        [_responseData release];
        _responseData = [[NSMutableData alloc] init];
    }
}

#pragma mark -- network connection delegate.
// occurs when the connection has been established and we’re ready to receive data.
// Clear my NSMutableData variable
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData resetBytesInRange:NSMakeRange(0, [_responseData length])];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    [_responseData resetBytesInRange:NSMakeRange(0, [_responseData length])];
}

// triggers when all data has been downloaded for the request
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (nil != self.active) {
        self.active.image = [[UIImage alloc] initWithData:_responseData];
        
        // Notify for the new image.
        [self.active.delegate didReceiveImage:self.active.image forUrl:self.active.requestUrl];
        
        // Clean up.
        [_responseData resetBytesInRange:NSMakeRange(0, [_responseData length])];
        self.active = nil;
        
        // Send next request.
        [self sendNextRequest];
    }
}

@end
