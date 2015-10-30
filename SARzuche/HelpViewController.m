//
//  HelpViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-20.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "HelpViewController.h"
#import "NextHelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"使用帮助"];
    }
    _table=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---UITableViewDelegate,UITableViewDataSoource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"新手教学",@"业务介绍",@"车辆预定",@"车辆使用",@"费用结算",@"事故处理",@"优惠劵"];
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text=[titles objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
    view_line.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:223.0/255 alpha:1.0];
    [cell addSubview:view_line];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    NSString *type = [NSString stringWithFormat:@"help%d",indexPath.row+1];
    switch (indexPath.row) {
        case 0:
            next.title = @"新手教学";
            break;
        case 1:
            next.title = @"业务介绍";
            break;
        case 2:
            next.title = @"车辆预定";
            break;
        case 3:
            next.title = @"车辆使用";
            break;
        case 4:
            next.title = @"费用结算";
            break;
        case 5:
            next.title = @"事故处理";
            break;
        case 6:
            next.title= @"优惠劵";
        default:
            break;
    }
    next.type = type ;
    if (indexPath.row==6)
    {
#if 0
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"优惠劵使用，待客户提供" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return;
#endif
        next.type = nil;//@"help6";

    }
    [self.navigationController pushViewController:next animated:YES];
}


@end
