//
//  ListViewController.m
//  ListViewJson
//
//  Created by Loren Chen on 10/02/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "ListViewController.h"
#import "WebViewController.h"
#import "LineInfo.h"
#import "DataManager.h"
#import "LineCellView.h"

@interface ListViewController ()
{
    NSMutableArray *_linesArray; // All line information.
    BOOL _requesting; // Indicates whether controller is sending network request or waiting for response. No new requests are accept while YES.
    UITableView *_tableView;
    NSString *_name;
    NSInteger _identifier;
    DataManager *_dataManager;
}

@property (nonatomic, retain) NSString *name;

@end

@implementation ListViewController

@synthesize name = _name;

- (id)init
{
    self = [super init];
    if( self ) {
        // Add initialize here.
        _linesArray = [[NSMutableArray alloc] init];
        
        _dataManager = [[DataManager alloc] init];
        
        // Initialize the table view instance.
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.view addSubview:tableView];
        _tableView = tableView;
        [tableView release];
    }
    
    return self;
}

- (void)dealloc
{
    [_linesArray release];
    _linesArray = nil;
    
    _tableView = nil;
    
    self.name = nil;
    
    [_dataManager release];
    _dataManager = nil;
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set the right button bar.
    UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(onRefresh:)] autorelease];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    // Update title.
    self.navigationItem.title = @"Loading...";

    // Send request.
    [self requestData];
}

- (IBAction)onRefresh:(id)sender
{
    /*
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Quesntion?" message:@"Contact Loren on 0404 662 188 :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    
    [alertView show];*/
    
    [_linesArray removeAllObjects];
    [_tableView reloadData];
    [_dataManager clearRequest];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_linesArray release];
    _linesArray = nil;
}

- (void)setTitle
{
    self.navigationItem.title = self.name;

}

- (void)updateUi:(BOOL)hasNewData
{
    // Update UI event should be dispatched in main queue.
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (hasNewData) {
        dispatch_async(mainQueue, ^{[_tableView reloadData];});
        dispatch_async(mainQueue, ^{[self setTitle];});
    }
    
    dispatch_async(mainQueue, ^{[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];});
}

- (BOOL)requestData
{
    if (_requesting) {
        NSLog(@"Prevous request not finished yet!");
        return NO;
    }
    
    _requesting = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *strUrl = @"http://mobilatr.mob.f2.com.au/services/views/9.json";
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Send asynchronous request to fetch JSON data.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        int statusCode = [httpResponse statusCode];
        if ((200 == statusCode) && ([data length] > 0) && (nil == connectionError)) {
         
            NSString *strData = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"%@", strData);
            
            // Parse the json data.
            if ([self parseData:data]) {
                // Update title and table. Attention: Should be in main UI thread!!
                [self updateUi:YES];
            }
        } else {
            // TODO: Add error handling message here.
            [self updateUi:NO];
            }
        
        // Reset the status.
        _requesting = NO;
        
        // Release the OperationQueue to avoid memory leak.
        [queue release];
    }];
    
    return YES;
}

- (BOOL)parseData:(NSData*)jsonData
{
    if( (nil == jsonData) || ([jsonData length] <= 0) )
        return NO;
    
    [_linesArray removeAllObjects];
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    // Parse the total count.
    self.name = [jsonDict objectForKey:@"name"];
    _identifier = [[jsonDict objectForKey:@"identifier"] intValue];
    
    // Get the result for array.
    NSArray *items = [jsonDict objectForKey:@"items"];
    const NSInteger count = [items count];
    for (int nIdx = 0; nIdx < count; nIdx++) {
        NSDictionary *itemDict = [items objectAtIndex:nIdx];
        
        // Parse the items.
        LineInfo *beefInfo = [LineInfo fromJson:itemDict];
        if (nil != beefInfo) {
            // Save to array.
            [_linesArray addObject:beefInfo];
        }
    }
    
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [_tableView setFrame:self.view.bounds];
    [_tableView reloadData];
}

#pragma Delegate and DataSource actions from here

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LineInfo *entity = [_linesArray objectAtIndex:indexPath.row];
    CGSize size = [self measureCellContentSize:entity];
    
    return size.height + (CELL_CONTENT_MARGIN * 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_linesArray count];
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellViewId = @"ListViewCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellViewId];
    LineCellView *lineCellView = nil;
    if( nil == cell ) {
        // Create a new instance for the cell view.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellViewId] autorelease];
        
        lineCellView = [[LineCellView alloc] initWithFrame:CGRectZero];
        [lineCellView setTag:1];
        
        //[[cell contentView] addSubview:lineCellView];
        [cell.contentView addSubview:lineCellView];
        [lineCellView release];
    } else {
        lineCellView = (LineCellView*)[cell.contentView viewWithTag:1];
    }
    
    LineInfo *entity = [_linesArray objectAtIndex:indexPath.row];
    CGSize contentSize = [self measureCellContentSize:entity];
    [lineCellView setLineInfo:entity.headLine slug:entity.slugLine date:entity.dateLine];
    
    [lineCellView setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, contentSize.width, contentSize.height)];
    
    // Check whether image exists.
    if ([entity isThumbnailEmpty]) {
        [lineCellView setThumbnailEmpty:YES];
    } else if (nil != entity.thumbnail) {
        [lineCellView setThumbnailImage:entity.thumbnail];
        [lineCellView setThumbnailEmpty:NO];
    } else {
        [_dataManager requestImage:entity.thumbnailImageHref delegate:self];
        [lineCellView setThumbnailEmpty:NO];
    }
    
    return cell;
}

- (CGSize) measureCellContentSize: (LineInfo*) lineinfo
{
    CGFloat width = _tableView.frame.size.width - (CELL_CONTENT_MARGIN * 2);
    CGSize headSize = [LineCellView measureText:lineinfo.headLine constrainedToWidth:width fontSize:HEAD_FONT_SIZE];

    // Check whether current line info has image or not.
    CGSize imageSize = [lineinfo isThumbnailEmpty] ? CGSizeMake(0, 0) : CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
    CGFloat slugWidth = width - imageSize.width - VIEW_SPACE;
    
    CGSize slugSize = [LineCellView measureText:lineinfo.slugLine constrainedToWidth:slugWidth fontSize:SLUG_FONT_SIZE];
    
    CGSize dateSize = [LineCellView measureText:lineinfo.dateLine constrainedToWidth:slugWidth fontSize:SLUG_FONT_SIZE];
    
    CGFloat height = headSize.height + VIEW_SPACE + MAX(slugSize.height + VIEW_SPACE + dateSize.height , imageSize.height);
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LineInfo *selected = [_linesArray objectAtIndex:indexPath.row];
    WebViewController *webViewController = [[WebViewController alloc] initWithURL:selected.webHref];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    [webViewController release];
    
    // To avoid the cell keeping hightlight, we need deselect current item.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ( 0 >= [_linesArray count] ) {
        return @"I'm loading now...";
    } else {
        return @"All articles are loaded";
    }
}

- (void)didReceiveImage:(UIImage*)image forUrl:(NSString*)url;
{
    NSLog(@"url:%@", url);
    const NSInteger count = [_linesArray count];
    for (int nIdx = 0; nIdx < count; nIdx++) {
        LineInfo *entity = [_linesArray objectAtIndex:nIdx];
        if ((nil != entity) && (![entity isThumbnailEmpty]) && ([entity.thumbnailImageHref isEqualToString:url])) {
            entity.thumbnail = image;
            break;
        }
    }
}

@end
