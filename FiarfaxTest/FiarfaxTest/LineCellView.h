//
//  LineCell.h
//  FiarfaxTest
//
//  Created by Loren Chen on 10/02/2014.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEAD_FONT_SIZE 14.0f
#define SLUG_FONT_SIZE 12.0f
#define IMAGE_WIDTH 100.0f
#define IMAGE_HEIGHT 50.0f
#define VIEW_SPACE 10.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface LineCellView : UIView

- (void)setLineInfo:(NSString*)headLine slug:(NSString*)slugLine date:(NSString*)dateLine;

- (void)setThumbnailImage:(UIImage *)image;

- (void)setThumbnailEmpty:(BOOL)isEmpty;

+ (CGSize)measureText:(NSString*)text constrainedToWidth:(CGFloat)width fontSize:(CGFloat)fontSize;

@end
