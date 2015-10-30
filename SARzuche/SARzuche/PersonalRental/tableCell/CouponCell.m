//
//  CouponCell.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CouponCell.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "PublicFunction.h"

#define LABEL_X             30
#define LABEL_W             280

#define FRAME_NAME      CGRectMake(LABEL_X, 5, LABEL_W, LABEL_H)
#define FRAME_TYPE      CGRectMake(LABEL_X, LABEL_H + 5, 100, LABEL_H)
#define FRAME_TIME      CGRectMake(130, LABEL_H + 5, 180, LABEL_H)
#define FRAME_DESC      CGRectMake(LABEL_X, LABEL_H * 2 + 5, LABEL_W, LABEL_H *2)
#define FRAME_SEPARATOR CGRectMake(0, COUPON_CELL_HIGHT -1, MainScreenWidth, 1)

#define FRAME_CHECKBOX  CGRectMake(5, (COUPON_CELL_HIGHT - 20)/2, 20, 20)

#define IMG_CHECKBOX_SEL            @"checkbox_sel.png"
#define IMG_CHECKBOX_UNSEL          @"checkbox_unsel.png"

@implementation CouponCell
@synthesize m_checkboxBtn;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCouponCell];
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

-(void)initCouponCell
{
    m_name = [[UILabel alloc] initWithFrame:FRAME_NAME];
    m_name.font = FONT_LABEL;
    [self.contentView addSubview:m_name];
    
    m_type = [[UILabel alloc] initWithFrame:FRAME_TYPE];
    m_type.font = FONT_SMALL;
    [self.contentView addSubview:m_type];
    
    m_time = [[UILabel alloc] initWithFrame:FRAME_TIME];
    m_time.font = FONT_SMALL;
    [self.contentView addSubview:m_time];
    
    m_desc = [[UILabel alloc] initWithFrame:FRAME_DESC];
    m_desc.font = FONT_SMALL;
    m_desc.numberOfLines = 2;
    [self.contentView addSubview:m_desc];
    
    UIImage *tmpImg = [UIImage imageNamed:IMG_CHECKBOX_SEL];
    m_checkboxBtn = [[UIButton alloc] initWithFrame:FRAME_CHECKBOX];
    [m_checkboxBtn setBackgroundImage:tmpImg forState:UIControlStateSelected];
    [m_checkboxBtn setBackgroundImage:[UIImage imageNamed:IMG_CHECKBOX_UNSEL] forState:UIControlStateNormal];
    m_checkboxBtn.backgroundColor = [UIColor lightGrayColor];
    [m_checkboxBtn addTarget:self action:@selector(checkBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    m_checkboxBtn.tag = self.tag;
    [self.contentView addSubview:m_checkboxBtn];
    
    UIView *sperator = [[PublicFunction ShareInstance] getSeparatorView:FRAME_SEPARATOR];
    [self.contentView addSubview:sperator];
}

/*area = "\U6ea7\U9633";
 branch = "";
 enddate = "2014-11-01";
 iscountinue = 0;
 leftnum = 1;
 name = "\U4e8e\U91d1\U6c11";
 no = 20141016140000000;
 remarks = "lkjdf+lkjafl+kjdflkjsldk+fasdf+asdf";
 startdate = "2014-10-08";
 type = 2;*/
-(void)setCouponCellData:(NSDictionary *)couponDic withTag:(NSInteger)tag
{
    if (nil == couponDic) {
        return;
    }
//    NSString *strModel = [couponDic objectForKey:@"modle"];
    NSString *strType = [couponDic objectForKey:@"type"];
    
    m_name.text = [couponDic objectForKey:@"name"];
    m_type.text = [NSString stringWithFormat:@"%@",  [self getTypeString:strType]];
    m_time.text = [NSString stringWithFormat:@"%@: %@至%@", @"有效", [couponDic objectForKey:@"startdate"], [couponDic objectForKey:@"enddate"]];
    m_desc.text = [NSString stringWithFormat:@"%@: %@", STR_DESCRIPTION, [couponDic objectForKey:@"remarks"]];
    
    m_checkboxBtn.tag = tag;
//    m_leftNum.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"leftnum"]];
//    m_carMode.text = [NSString stringWithFormat:@"%@", strModel ? strModel : @"所有车型"];
//    m_id.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"no"]];
//    m_scope.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"area"]];
//    m_validTime.text = [NSString stringWithFormat:@"%@ ~ %@", [m_couponDic objectForKey:@"startdate"], [m_couponDic objectForKey:@"enddate"]];
//    m_desc.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"remarks"]];
}



-(NSString *)getTypeString:(NSString *)type
{
    NSInteger nInter = [type integerValue];
    switch (nInter) {
        case 1:
            return STR_DURATION_CONSUMPTION;
            break;
        case 2:
            return STR_MILEAGE_CONSUMPTION;
            break;
        case 3:
            return STR_ALL_COUPON;
            break;
        case 4:
            return STR_CASH_COUPON;
            break;
        default:
            return @"";
            break;
    }
}


-(void)checkBoxPressed:(id)sender
{
    UIButton *btn = sender;
    BOOL bSelected = btn.selected;
    
    NSString *strTag = [NSString stringWithFormat:@"%d", btn.tag];
    
    if (bSelected) {
        btn.selected = NO;
    }
    else
    {
        btn.selected = YES;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(radioSel:)]) {
        [delegate radioSel:strTag];
    }
}


@end
