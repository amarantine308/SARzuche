//
//  LeftViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "LeftViewController.h"
#import "AboutUsViewController.h"
#import "ComplainViewController.h"
#import "UserCenterViewController.h"
#import "HomeViewController.h"
#import "DDMenuController.h"
#import "HelpViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

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
    // Do any additional setup after loading the view from its nib.
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 80;
    }
    else
    {
        return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"首页",@"关于我们",@"宝贵建议",@"使用帮助"/*,@"检查更新"*/];
    UITableViewCell *cell = nil;
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    if (indexPath.row==0)
    {
        cell.imageView.image=[UIImage imageNamed:@"left_home"];

    }
    if (indexPath.row==1)
    {
        cell.imageView.image=[UIImage imageNamed:@"left_aboutus"];
    }
    if (indexPath.row==2)
    {
        cell.imageView.image=[UIImage imageNamed:@"left_message"];
    }
    if (indexPath.row==3)
    {
        cell.imageView.image=[UIImage imageNamed:@"left_help"];
    }
    if (indexPath.row==4)
    {
        cell.imageView.image=[UIImage imageNamed:@"left_update"];
    }
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle=    UITableViewCellSelectionStyleNone
    ;
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *menuController=(UINavigationController *)appdelegate.menuController;
    UIViewController *tempViewController = nil;
    switch (indexPath.row)
    {
        
        case 0:
        {
            tempViewController=[[HomeViewController alloc] init];
        }
        break;
        case 1:
        {
            tempViewController=[[AboutUsViewController alloc] init];
            
        }
            break;
        case 2:
        {
            tempViewController=[[ComplainViewController alloc] init];

        }
            break;
        case 3:
        {
            tempViewController=[[HelpViewController alloc] init];

        }
            break;
        case 4:
        {
//            tempViewController=[[AboutUsViewController alloc] init];
        }
            break;
       
        default:
            break;
    }
    [appdelegate.menuController showRootController:YES];
    if (![tempViewController isKindOfClass:[HomeViewController class]]) {
        [menuController pushViewController:tempViewController animated:YES];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
