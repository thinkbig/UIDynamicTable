//
//  ListViewController.h
//  ListViewJson
//
//  Created by Loren Chen on 10/02/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#include <UIKit/UIKit.h>
#include "RequestUnit.h"

@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RequestDelegate>

- (id)init; // Init the view controller to parsing the xib file name inside.

@end
