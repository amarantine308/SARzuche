//
//  MessageCell.m
//  SARzuche
//
//  Created by admin on 14-10-31.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MessageCell.h"

#define Width_SeparatorLine     580.0 / 2.0
#define Height_SeparatorLine    1.0   / 2.0
#define OriginX_SeparatorLine   (self.bounds.size.width - Width_SeparatorLine) / 2.0

#define Width_TitleLabel        160
#define Height_TitleLabel       30

#define width_TimeLabel         (self.bounds.size.width - Width_TitleLabel - originX*2)
#define Height_TimeLabel        Height_TitleLabel

#define Width_ImageView         48.0 / 2.0
#define Height_ImageView        48.0 / 2.0

#define Height_SpaceView        5

#define Width_ContentLabel      self.bounds.size.width - originX*2
#define Height_ContentLabel     Height_Cell - Height_TitleLabel - Height_SpaceView*2 - 5

@implementation MessageCell
{
    UIImageView *newMessageImg;
    UIView *spaceView;
}
@synthesize titleLabel, timeLabel, separatorLine, contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        float originX = OriginX_SeparatorLine;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, Width_TitleLabel, Height_TitleLabel)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        newMessageImg = [[UIImageView alloc] init];
        newMessageImg.image = [UIImage imageNamed:@"NEW.png"];
        [self addSubview:newMessageImg];
        newMessageImg.hidden = YES;
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - originX - width_TimeLabel, 0, width_TimeLabel, Height_TimeLabel)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        
        separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_SeparatorLine, Height_TitleLabel, Width_SeparatorLine, Height_SeparatorLine)];
        separatorLine.image = [UIImage imageNamed:@"separator@2x.png"];
        [self addSubview:separatorLine];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, Height_TitleLabel+5, Width_ContentLabel, Height_ContentLabel)];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.userInteractionEnabled = NO;
        [self addSubview:contentLabel];
        
        spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_Cell - Height_SpaceView, self.bounds.size.width, Height_SpaceView)];
        spaceView.backgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        [self addSubview:spaceView];
    }
    return self;
}

-(void)showNewMessageImageView:(BOOL)show
{
    if (show)
    {
        CGSize labelSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(FLT_MAX,FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        newMessageImg.frame = CGRectMake(OriginX_SeparatorLine+labelSize.width, 0, Width_ImageView, Height_ImageView);
        newMessageImg.hidden = NO;
    }
    else
        newMessageImg.hidden = YES;
}

-(void)showSpaceView:(BOOL)show
{
    if (show)
        spaceView.hidden = NO;
    else
        spaceView.hidden = YES;
}

@end
