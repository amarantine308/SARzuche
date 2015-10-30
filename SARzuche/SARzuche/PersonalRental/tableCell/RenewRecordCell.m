//
//  RenewRecordCell.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RenewRecordCell.h"
#import "ConstString.h"
#import "ConstDefine.h"

#define LABEL_START_X           30

#define FRAME_CHECKBOX             CGRectMake(10, 20, 20, 20)
#define FRAME_RENEW_TIME        CGRectMake(LABEL_START_X, 5, MainScreenWidth - LABEL_START_X - 10, 20)
#define FRAME_RENEW_DURATION    CGRectMake(LABEL_START_X, 25, MainScreenWidth- LABEL_START_X - 10, 20)
#define FRAME_RENEW_DEPOSIT     CGRectMake(LABEL_START_X, 45, MainScreenWidth- LABEL_START_X - 10, 20)

#define IMG_CHECKBOX_SEL            @"checkbox_sel.png"
#define IMG_CHECKBOX_UNSEL          @"checkbox_unsel.png"

@implementation RenewRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initRenewRecordCell];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initRenewRecordCell
{
    UIImage *tmpImg = [UIImage imageNamed:IMG_CHECKBOX_SEL];
    m_checkboxBtn = [[UIButton alloc] initWithFrame:FRAME_CHECKBOX];
    [m_checkboxBtn setBackgroundImage:tmpImg forState:UIControlStateSelected];
    [m_checkboxBtn setBackgroundImage:[UIImage imageNamed:IMG_CHECKBOX_UNSEL] forState:UIControlStateNormal];
    m_checkboxBtn.backgroundColor = [UIColor lightGrayColor];
    [m_checkboxBtn addTarget:self action:@selector(checkBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    m_checkboxBtn.tag = self.tag;
//    [self.contentView addSubview:m_checkboxBtn];
    
    m_renewTime = [[UILabel alloc] initWithFrame:FRAME_RENEW_TIME];
    m_renewTime.textColor = COLOR_LABEL;
    [self.contentView addSubview:m_renewTime];
    
    m_renewDuration = [[UILabel alloc] initWithFrame:FRAME_RENEW_DURATION];
    m_renewDuration.textColor = COLOR_LABEL;
    [self.contentView addSubview:m_renewDuration];
    
    m_renewDeposit = [[UILabel alloc] initWithFrame:FRAME_RENEW_DEPOSIT];
    m_renewDeposit.textColor = COLOR_LABEL;
    [self.contentView addSubview:m_renewDeposit];
    
    CGRect rect = m_renewDeposit.frame;
    rect.origin.x = 10;
    rect.origin.y = m_renewDeposit.frame.origin.y + m_renewDeposit.frame.size.height -1;
    rect.size.height = 1;
    UIImageView *tmpView = [[PublicFunction ShareInstance] getSeparatorView:rect];
    [self.contentView addSubview:tmpView];
}

-(void)setRnewRecordCellData:(srvRenewData *)renewData
{
    m_renewTime.text = [NSString stringWithFormat:@"%@     %@", STR_RENEW_DATETIME, [[PublicFunction ShareInstance] getYMDHMString:GET(renewData.m_creatTime)]];
    NSString *srvTime = GET(renewData.m_time);
    NSArray *timeArr = [srvTime componentsSeparatedByString:@"."];
    if (2 == [timeArr count]) {
        NSString *hour = [timeArr objectAtIndex:0];
        NSString *strDot = [timeArr objectAtIndex:1];
        NSInteger nDot = [strDot integerValue] > 10 ? [strDot integerValue] / 10 : [strDot integerValue];
        NSString *min = [NSString stringWithFormat:@"%d", nDot * 6];
        NSString *time = [NSString stringWithFormat:STR_DROVE_HHMM, hour, min];
        m_renewDuration.text = [NSString stringWithFormat:@"%@     %@", STR_GO_ON_TIME, time];
    }
    else
    {
        NSString *time = [NSString stringWithFormat:STR_DROVE_HH, srvTime];
        m_renewDuration.text = [NSString stringWithFormat:@"%@     %@", STR_GO_ON_TIME, time];
    }
    
    NSString *tmpCost = [[PublicFunction ShareInstance] checkAndFormatMoeny:GET(renewData.m_deposit)];
    NSString *strCost = [NSString stringWithFormat:STR_COST_FORMAT, tmpCost];
    CGRect tmpRect = m_renewDeposit.frame;
    tmpRect.origin.x = 90;
    tmpRect.origin.y = 0;
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:tmpRect];
    tmpLabel.text = strCost;
    tmpLabel.textColor = COLOR_LABEL_BLUE;
    tmpLabel.tag = 10010;
    for(UIView *subView in [m_renewDeposit subviews])
    {
        if (10010 == subView.tag) {
            [subView removeFromSuperview];
        }
    }
    [m_renewDeposit addSubview:tmpLabel];

    m_renewDeposit.text = [NSString stringWithFormat:@"%@", STR_GO_ON_DEPOSIT];
}



-(void)checkBoxPressed:(id)sender
{
    UIButton *btn = sender;
    BOOL bSelected = btn.selected;
    
//    NSString *strTag = [NSString stringWithFormat:@"%d", btn.tag];
    
    if (bSelected) {
        btn.selected = NO;
    }
    else
    {
        btn.selected = YES;
    }
#if 0
    if (delegate && [delegate respondsToSelector:@selector(radioSel:)]) {
        [delegate radioSel:strTag];
    }
#endif
}


@end
