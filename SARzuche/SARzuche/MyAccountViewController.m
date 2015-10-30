//
//  MyAccountViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountCellTableViewCell.h"
#import "MyAccountDetailViewController.h"
#import "MyAccountChargeViewController.h"
#import "MyAccouontWithDrawViewController.h"
#import "constString.h"
#import  "User.h"
#import  "MyAccount.h"
#import "BLNetworkManager.h"
#import "FlowRecord.h"
@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (customNavBarView)
    {
        [customNavBarView setTitle:STR_MYCENTER_ACCOUNT];
    }
    pdataSource = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;

   

}

- (void)getData
{
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getMyAccountMessageWithUserId:[User shareInstance].id delegate:self];
    request = nil;
    
    FMNetworkRequest *tempRequest2 = [[BLNetworkManager shareInstance] getAccountDetailByUserId:[User shareInstance].id type:@"1"
                                                                                       pageSize:@"4"
                                                                                    pageNumber:@"1"
                                                                                       delegate:self];
    tempRequest2 = nil;
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----IBAction
- (IBAction)detailAction:(id)sender
{
    MyAccountDetailViewController *detail =[[MyAccountDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)chargeAction:(id)sender
{
    MyAccountChargeViewController *detail =[[MyAccountChargeViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)drawCashAction:(id)sender
{
    MyAccouontWithDrawViewController *detail =[[MyAccouontWithDrawViewController  alloc] init];
    detail.banlance= availeMoney.text;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark---UITableViewDataSource,delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    if (section == 1)
    {
        return [pdataSource count];
    }
    if (section == 2)
    {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row==0)
        {
            return _container1.frame.size.height;
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row==0)
        {
            return _container2.frame.size.height;
        }
    }
    
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0)
    {
        return 8;
    }
    if (section == 1)
    {
        return 8;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        if (indexPath.row==0)
        {
            [cell addSubview:_container1];
            return cell;

        }
    }
    else if (indexPath.section == 2)
    {
        [cell addSubview:_container2];
        return cell;

    }
    else if(indexPath.section == 1)
    {
        MyAccountCellTableViewCell * cell2= nil;
        if (cell2==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyAccountCellTableViewCell"
                                                         owner:self
                                                       options:nil];
            for(id obj in nib)
            {
                if([obj isKindOfClass:[MyAccountCellTableViewCell class]])
                {
                    cell2 = (MyAccountCellTableViewCell *)obj ;
                }
            }
            cell2.backgroundColor = [UIColor whiteColor];
            cell2.selectionStyle= UITableViewCellSelectionStyleNone;
            if (pdataSource.count!=0)
            {
                FlowRecord *flow=[pdataSource  objectAtIndex:indexPath.row];
                NSString *time = flow.time;
                NSString *realTime=@"";
                if (time.length!=0)
                {
                realTime = [[time stringByReplacingOccurrencesOfString:@"+" withString:@" "] substringToIndex:flow.time.length-2];
                }
                //时间
                cell2.time.text = realTime;
                //可用余额
                cell2.balance.text=[NSString stringWithFormat:@"可用余额%@元",flow.avaliable_amount];
                //充值金额
                float avaliableMoney = flow.avaliable_change.floatValue;
                NSString *change = @"";
                if (avaliableMoney>0)
                {
                   if(  [flow.flow_type isEqualToString:@"充值"]
                            ||[flow.flow_type isEqualToString:@"财务扣款"]
                            ||([flow.flow_type isEqualToString:@"提现"])
                            )
                    {
                        change = flow.avaliable_change;
                    }
                    else
                    {
                        change = flow.advance_change;
                    }
                    cell2.charage.text=[NSString stringWithFormat:@"+%@",change];
                }
                else
                {
                    if(  [flow.flow_type isEqualToString:@"充值"]
                       ||[flow.flow_type isEqualToString:@"财务扣款"]
                       ||([flow.flow_type isEqualToString:@"提现"])
                            )
                    {
                        change = flow.avaliable_change;
                    }
                    else
                    {
                        change = flow.advance_change;
                    }
                    cell2.charage.text=[NSString stringWithFormat:@"%@",change];
                    cell2.charage.textColor = [UIColor orangeColor];
                }
                //充值方式    //1提现中 2成功 3失败
                NSString *style;
                NSString *withdraw;
                cell2.chargeStyle.text = flow.flow_type;
                if ([flow.withdraw_status isEqualToString:@"1"])
                {
                    withdraw=@"申请提现";
                }
                if ([flow.withdraw_status isEqualToString:@"2"])
                {
                    withdraw=@"申请提现成功";
                    
                }
                if ([flow.withdraw_status isEqualToString:@"3"])
                {
                    withdraw=@"申请提现失败";
                }
                if ([flow.flow_type isEqualToString:@"提现"]&& (withdraw.length!=0))
                {
                    style = [NSString stringWithFormat:@"%@(%@)",flow.flow_type,withdraw];
                }
                else
                {
                    style = flow.flow_type;
                }
                cell2.chargeStyle.text = style;
                }
          return cell2;
        }
     }
    else
    {
    return nil;
    }
    return nil;
}
#pragma mark - dataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_getMyAccountMessage])
    {
        MyAccount *account = fmNetworkRequest.responseData;
        
        availeMoney.text=account.usefull;
        prepay.text = account.freeze;
        float sum = account.usefull.floatValue+account.freeze.floatValue;
        sumPrice.text = [NSString stringWithFormat:@"%.2f",sum];
    }
    else
    {
        pdataSource = fmNetworkRequest.responseData;
        [_table reloadData];
        [[LoadingClass shared] hideLoading];

        
    }
    
    
    
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_getMyAccountMessage])
    {
    }
    else
    {
        [[LoadingClass shared] hideLoading];

    }
}


@end
