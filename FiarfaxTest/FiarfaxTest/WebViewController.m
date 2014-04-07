//
//  WebViewController.m
//  webview
//
//  Created by Loren Chen on 10/02/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *_webView;
    NSURLRequest *_request;
}

@property (nonatomic, retain) NSURLRequest *request;

@end

@implementation WebViewController

@synthesize  request = _request;


- (id)init
{
    self = [super init];
    if(self) {
        // Custom initialization
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        
        [_webView release];
    }
    
    return self;
}

- (id)initWithURL:(NSString *)strUrl
{
    self = [super init];
    if( self ) {
        // Custom initialization
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        
        [_webView release];
        
        NSURL *url = [NSURL URLWithString:strUrl];
        self.request = [NSURLRequest requestWithURL:url];
    }
    
    return self;
}

- (void)dealloc
{
    // Release the retain instance.
    self.request = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Send request for webview.
    [_webView loadRequest:self.request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [_webView setFrame:self.view.bounds];
}


@end
