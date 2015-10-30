//
//  NavigationTypeViewCell.m
//  SARzuche
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavigationTypeViewCell.h"

#define TITLE_LABEL_ORIGINX 20
#define TITLE_LABEL_WIDTH   100
#define TITLE_LABEL_HEIGHT  40
#define FRAME_TITLE_LABEL   CGRectMake(TITLE_LABEL_ORIGINX, (self.bounds.size.height - TITLE_LABEL_HEIGHT) / 2 , TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT)

#define SELECTBTN_ORIGINX   90
#define SELECTBTN_WIDTH     38.0/2.0
#define SELECTBTN_HEIGHT    38.0/2.0
#define FRAME_SELECTED_VIEW CGRectMake(self.bounds.size.width - SELECTBTN_WIDTH - SELECTBTN_ORIGINX, (self.bounds.size.height - SELECTBTN_HEIGHT) / 2 , SELECTBTN_WIDTH, SELECTBTN_HEIGHT)

@implementation NavigationTypeViewCell
@synthesize cellBtn, titleLabel, selectedView, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryNone;  // 去掉右侧小箭头
        
        cellBtn = [[UIButton alloc] initWithFrame:self.bounds];
        cellBtn.backgroundColor = [UIColor clearColor];
        cellBtn.exclusiveTouch = YES;
        [cellBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cellBtn];
        
        titleLabel = [[UILabel alloc] initWithFrame:FRAME_TITLE_LABEL];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        [cellBtn addSubview:titleLabel];
        
//        selectedView = [[UIImageView alloc] initWithFrame:FRAME_SELECTED_VIEW];
//        [cellBtn addSubview:selectedView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)btnClicked:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(cellBtnClicked:)])
        [delegate cellBtnClicked:sender];
}

@end
