//
//  BranchesTableCell.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchesTableCell.h"
#import "ConstDefine.h"
#import "ConstImage.h"

#define DISTANCE_WIDTH      80
#define BLOCK_HEIGHT        40

#define FRAME_NAME          CGRectMake(0, 2, BRANCHE_TABLE_WIDTH - DISTANCE_WIDTH, 20)
#define FRAME_ADDRESS       CGRectMake(0, 25, BRANCHE_TABLE_WIDTH, 20)
#define FRAME_DISTANCE      CGRectMake(BRANCHE_TABLE_WIDTH - DISTANCE_WIDTH+1, 2, DISTANCE_WIDTH, 20)
#define FRAME_BLOCK      CGRectMake(0, 2, BLOCK_TABLE_WIDTH, BLOCK_HEIGHT)


#define FRAME_NAME_FOR_SEARCH          CGRectMake(0, 2, BRANCHE_SEARCH_WIDTH, 20)
#define FRAME_ADDRESS_FOR_SEARCH       CGRectMake(0, 25, BRANCHE_SEARCH_WIDTH, 20)

#define IMG_ICON                @"select.png"

@implementation BranchesStruct

@synthesize m_address;
@synthesize m_id;
@synthesize m_latitude;
@synthesize m_longitude;
@synthesize m_name;

@end


@implementation BranchesTableCell
@synthesize m_branchesAddress;
@synthesize m_branchesName;
@synthesize m_distance;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#define CELL_HEIGHT         45

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    m_blockName.textColor = [UIColor blackColor];
    if (selected) {
        m_blockName.textColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}

-(void)setBlockName:(NSString *)name
{
    m_blockName.text = name;
}

-(void)setBrancheName:(NSString *)name
{
    m_branchesName.text = name;
}

-(void)setBrancheAddress:(NSString *)address
{
    m_branchesAddress.text = address;
}

-(void)setDistance:(NSString *)distance
{
    m_distance.text = distance;
}

-(void)setCellForBlock:(branchesViewType)type
{
    m_isBlock = type;
    
    [self removeAllSubView];
    [self initBranchesCell];
//    [self showControlInCell];
}

-(void)removeAllSubView
{
    for (UIView *subView in [self.contentView subviews]) {
        [subView removeFromSuperview];
    }
    
    m_branchesName = nil;
    m_branchesAddress = nil;
    m_distance = nil;
    m_blockName = nil;
//    [self initBranchesCell];
}


-(void)showControlInCell
{
    if (m_isBlock) {
        m_branchesName.hidden = YES;
        m_branchesAddress.hidden = YES;
        m_distance.hidden = YES;
        m_blockName.hidden = NO;
    }
    else
    {
        m_branchesName.hidden = NO;
        m_branchesAddress.hidden = NO;
        m_distance.hidden = NO;
        m_blockName.hidden = YES;
    }
}

-(void)initBranchesCell
{
    if (m_isBlock == tableBlock) {
        m_blockName = [[UILabel alloc] initWithFrame:FRAME_BLOCK];
        m_blockName.textColor = [UIColor blackColor];
        [self.contentView addSubview:m_blockName];
        
        UIImage *tmpImg =[UIImage imageNamed:IMG_ICON];
        UIImageView *tmpView = [[UIImageView alloc] initWithImage:tmpImg];
//        tmpView.frame = CGRectMake(self.contentView.frame.size.width - tmpView.frame.size.width -5, (self.contentView.frame.size.height - tmpView.frame.size.height)/2, tmpView.frame.size.width, tmpView.frame.size.height);
        tmpView.frame = CGRectMake(BLOCK_TABLE_WIDTH - tmpView.frame.size.width-5, (BLOCK_HEIGHT - tmpView.frame.size.height)/2, tmpView.frame.size.width, tmpView.frame.size.height);
        [self.contentView addSubview:tmpView];
    }
    else
    {
        m_branchesName = [[UILabel alloc] initWithFrame:FRAME_NAME];
        [self.contentView addSubview:m_branchesName];
    
        m_branchesAddress = [[UILabel alloc] initWithFrame:FRAME_ADDRESS];
        [self.contentView addSubview:m_branchesAddress];
    
        m_distance = [[UILabel alloc] initWithFrame:FRAME_DISTANCE];
        [self.contentView addSubview:m_distance];

        m_distance.textColor = [UIColor blackColor];
        m_branchesName.textColor = [UIColor blackColor];
        m_branchesAddress.textColor = [UIColor blackColor];
        
        if (m_isBlock == tableSearch) {
            m_distance.hidden = YES;
            m_branchesName.frame = FRAME_NAME_FOR_SEARCH;
            m_branchesAddress.frame = FRAME_ADDRESS_FOR_SEARCH;
        }

    }
    
    m_line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPARATOR]];
    m_line.frame = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 1);
    [self.contentView addSubview:m_line];
}



@end
