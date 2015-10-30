//
//  RentCarView.m
//  SARzuche
//
//  Created by dyy on 14-10-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RentCarView.h"
#import "ConstDefine.h"
#import "PublicFunction.h"

#define RGB(r,g,b,al) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:al]

@implementation RentCarView
@synthesize delegate;
@synthesize dic_rent;
@synthesize table_rentCar;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        list_titles = @[@"意向1",@"意向提交时间",@"取车时间",@"品牌",@"车系",@"周期",@"数量",@"企业名称",@"联系人",@"",@""];
        
        list_tenancy = @[@"一周以内",@"一个月以内",@"三个月以内",@"半年以内",@"一年以内",@"一年以上"];
        
        UIView *vi_alpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        vi_alpha.backgroundColor= [UIColor blackColor];
        vi_alpha.alpha = 0.5;
        [self addSubview:vi_alpha];
        self.backgroundColor = [UIColor clearColor];
        
        table_rentCar = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-30, 300)];
        table_rentCar.delegate = self;
        table_rentCar.dataSource = self;
        table_rentCar.alpha = 1.0;
        table_rentCar.center = self.center;
        table_rentCar.scrollEnabled = NO;
        [table_rentCar setBackgroundColor:[UIColor whiteColor]];
        table_rentCar.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:table_rentCar];
    }
    return self;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44.0;
    }
    return 28.4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"CarInfoViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    cell.textLabel.text = [list_titles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:14];
    
    UILabel *labtemp  = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, 205, cell.bounds.size.height)];
    [cell.contentView addSubview:labtemp];
    labtemp.font = [UIFont fontWithName:@"helvetica" size:14];
    labtemp.textColor = RGB(136, 136, 136, 1);
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:15];
            cell.textLabel.text =  [NSString stringWithFormat:@"意向%@",GET([dic_rent objectForKey:@"rentNumber"])];
            
            UIView *viLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, cell.bounds.size.width, 1)];
            viLine.backgroundColor = RGB(215, 215, 215, 1);
            [cell.contentView addSubview:viLine];
        }
            break;
        case 1: // 取车城市
        {
            NSString *strDate = GET([dic_rent objectForKey:@"createdate"]);
            labtemp.text = [NSString stringWithFormat:@"%@",[[PublicFunction ShareInstance] getYMDHMString:strDate]];
            break;
        }
        case 2: // 取车日期
        {
            NSString *strTime = GET([dic_rent objectForKey:@"getTime"]);
//            labtemp.text = [NSString stringWithFormat:@"%@",[[PublicFunction ShareInstance] getYMDHMString:strTime]];
            labtemp.text = [NSString stringWithFormat:@"%@",strTime];
            break;
        }
        case 3: // 意向车型
            labtemp.text = [NSString stringWithFormat:@"%@",GET([dic_rent objectForKey:@"brand"])];
            break;
        case 4: // 租期
            labtemp.text = [NSString stringWithFormat:@"%@",GET([dic_rent objectForKey:@"carseries"])];
            break;
        case 5: // 车辆
        {
            NSInteger tenancyInt = [GET([dic_rent objectForKey:@"tenancytime"]) integerValue];
            labtemp.text = [list_tenancy objectAtIndex:tenancyInt];
//            labtemp.text = [NSString stringWithFormat:@"%@",GET([dic_rent objectForKey:@"tenancytime"])];
            break;
        }
        case 6: // 取车日期
            labtemp.text = [NSString stringWithFormat:@"%@",GET([dic_rent objectForKey:@"carNum"])];
            break;
        case 7: // 取车日期
            labtemp.text = [NSString stringWithFormat:@"%@",GET([dic_rent objectForKey:@"company"])];
            break;
//        case 8: // 是否代驾
//        {
//            NSString *drivingstr = @"是";
//            NSString *tempstr = GET([dic_rent objectForKey:@"designated_driver"]);
//            if (![tempstr isEqualToString:@"1"]) {
//                drivingstr = @"否";
//            }
//            labtemp.text = drivingstr;
//        }
//            break;
        case 8:
            
//            labtemp.text = [NSString stringWithFormat:@"%@(%@)",GET([dic_rent objectForKey:@"linkman"],GET([dic_rent objectForKey:@"phone"])];
            labtemp.text = [NSString stringWithFormat:@"%@(%@)",GET([dic_rent objectForKey:@"linkman"]),GET([dic_rent objectForKey:@"phone"])];
            
                                                                    
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hidenRentCarView)]) {
        [self.delegate hidenRentCarView];
    }
}

@end
