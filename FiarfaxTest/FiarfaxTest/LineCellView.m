//
//  LineCell.m
//  FiarfaxTest
//
//  Created by Loren Chen on 10/02/2014.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "LineCellView.h"
#import "LineInfo.h"

@interface LineCellView ()
{
    UILabel  *_headLine;
    UILabel  *_slugLine;
    UILabel  *_dateLine;
    UIImageView *_thumbnail;
    BOOL _isThumbnailEmpty;
}

@property (nonatomic, retain) UILabel *headLine;
@property (nonatomic, retain) UILabel *slugLine;
@property (nonatomic, retain) UILabel *dateLine;
@property (nonatomic, retain) UIImageView *thumbnail;

@end

@implementation LineCellView

@synthesize headLine = _headLine;
@synthesize slugLine = _slugLine;
@synthesize dateLine = _dateLine;
@synthesize thumbnail = _thumbnail;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubview];
    }
    return self;
}

- (void)dealloc
{
    // Release the member instances.
    self.headLine = nil;
    self.slugLine = nil;
    self.dateLine = nil;
    self.thumbnail = nil;
    
    [super dealloc];
}

- (void)initSubview
{
    // Head line
    _headLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self initLabel:self.headLine fontSize:SLUG_FONT_SIZE];
    [self.headLine setTextColor: [UIColor blueColor]];
    [self addSubview:self.headLine];
    
    // Slug line.
    _slugLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self initLabel:self.slugLine fontSize:SLUG_FONT_SIZE];
    [self addSubview:self.slugLine];
    
    // Date line
    _dateLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self initLabel:self.dateLine fontSize:SLUG_FONT_SIZE];
    [self.dateLine setTextColor:[UIColor grayColor]];
    [self addSubview:self.dateLine];
    
    _thumbnail = [[UIImageView alloc]init];
    [self addSubview:self.thumbnail];
    _isThumbnailEmpty = NO;
}

- (void)initLabel:(UILabel*)label fontSize:(CGFloat)fontSize
{
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setMinimumScaleFactor:fontSize];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)setLineInfo:(NSString *)headLine slug:(NSString *)slugLine date:(NSString *)dateLine
{
    [self.headLine setText:headLine];
    [self.slugLine setText:slugLine];
    [self.dateLine setText:dateLine];
}

- (void)setThumbnailImage:(UIImage *)image;
{
    self.thumbnail.image = image;
}

- (void)setThumbnailEmpty:(BOOL)isEmpty
{
    _isThumbnailEmpty = isEmpty;
    
    self.thumbnail.hidden = _isThumbnailEmpty;
    
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    // Set layout for head.
    CGRect rcHead = CGRectZero;
    rcHead.size = [LineCellView measureText:self.headLine.text constrainedToWidth:frame.size.width fontSize:HEAD_FONT_SIZE];
    [self.headLine setFrame:rcHead];
    
    // Check whether is empty.
    CGFloat imageWidth = (_isThumbnailEmpty ? 0 : IMAGE_WIDTH);
    
    CGRect rcSlug;
    rcSlug.origin = CGPointMake(0, rcHead.origin.y + rcHead.size.height + VIEW_SPACE);
    CGFloat slugWidth = frame.size.width - imageWidth - VIEW_SPACE;
    NSString * slug = self.slugLine.text;
    rcSlug.size = [LineCellView measureText:slug constrainedToWidth:slugWidth fontSize:SLUG_FONT_SIZE];
    
    CGFloat topOffset = rcSlug.origin.y + rcSlug.size.height;
    if (_isThumbnailEmpty) {
        [self.slugLine setFrame:rcSlug];
    }
    else {
        CGRect rcImage = CGRectMake(frame.size.width - IMAGE_WIDTH, rcSlug.origin.y, IMAGE_WIDTH, IMAGE_HEIGHT);
        
        // Check the layout for slug and image, make the smaller one stay vertical center.
        CGFloat maxHeight = MAX(rcSlug.size.height, rcImage.size.height);
        rcSlug.origin.y = rcSlug.origin.y + (maxHeight - rcSlug.size.height) / 2;
        rcImage.origin.y = rcImage.origin.y + (maxHeight - rcImage.size.height) / 2;
        [self.slugLine setFrame:rcSlug];
        [self.thumbnail setFrame:rcImage];
        
        topOffset = MAX(rcSlug.origin.y + rcSlug.size.height, rcImage.origin.y + rcImage.size.height);
    }
    
    // Layout of date line. Get the max one of image or slug.
    CGRect rcDate;
    rcDate.origin = CGPointMake(0, topOffset + VIEW_SPACE);
    rcDate.size = [LineCellView measureText:self.dateLine.text constrainedToWidth:slugWidth fontSize:SLUG_FONT_SIZE];
    [self.dateLine setFrame:rcDate];
}

+ (CGSize)measureText:(NSString *)text constrainedToWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGSize size = size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
