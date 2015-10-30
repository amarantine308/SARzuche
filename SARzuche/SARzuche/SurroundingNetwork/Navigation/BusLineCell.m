//
//  BusLineCell.m
//  SARzuche
//
//  Created by admin on 14-10-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BusLineCell.h"

#define CELL_HEIGHT 70

@implementation BusLineCell
@synthesize busNumLabel, detailLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        busNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 10 * 2, 30)];
        busNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [self addSubview:busNumLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 30, self.bounds.size.width - 10 * 2, 20)];
        detailLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:detailLabel];
    }
    return self;
}

@end
