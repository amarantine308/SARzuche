//
//  AreaCitySelectController.m
//  TYZX
//
//  Created by 丁鹏飞 on 14-10-9.
//  Copyright (c) 2014年 th-apple01. All rights reserved.
//

#import "AreaCitySelectController.h"
#import "ConstDefine.h"
#import "CarInfoViewController.h"

#define NOTIFICATION_AREA_CITY @"NOTIFICATION_AREA_CITY"

@interface AreaCitySelectController ()

@end

@implementation AreaCitySelectController
@synthesize area_list;
@synthesize areaCityType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self initInfoData];
    
    [self addtableview];
    
//    [self initUI];
    
    //因导航栏高度引起的tableviewcell现实问题
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//    [table_AreaCity scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)addtableview
{
    float originx = 10;
    float middleHeight = 10;
    float originy = 74;
    CGRect frame_table = CGRectMake(originx, originy, self.view.bounds.size.width-originx*2, self.view.bounds.size.height-middleHeight*2-64);
    table_AreaCity = [[UITableView alloc] initWithFrame:frame_table];
    table_AreaCity.layer.cornerRadius = 4.0;
    table_AreaCity.layer.borderWidth = 1.0;
    table_AreaCity.layer.borderColor = [[UIColor blackColor]CGColor];
    table_AreaCity.layer.shadowColor = [[UIColor blackColor]CGColor];
    table_AreaCity.delegate = self;
    table_AreaCity.dataSource = self;
    [self.view addSubview:table_AreaCity];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)initUI
//{
//    table_AreaCity.layer.cornerRadius = 4.0;
//    table_AreaCity.layer.borderWidth = 1.0;
//    table_AreaCity.layer.borderColor = [[UIColor blackColor]CGColor];
//    table_AreaCity.layer.shadowColor = [[UIColor blackColor]CGColor];
//}


- (void)initInfoData
{
    
}


#pragma mark - UItableviewDelegate协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [area_list count];
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *dic = [area_list objectAtIndex:indexPath.row];
    
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
    
    if (self.areaCityType == Select_Area){//省份
        cell.textLabel.text = GET([dic objectForKey:@"state"]);
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([dic objectForKey:@"cities"] != nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{//城市
        cell.textLabel.text = GET([dic objectForKey:@"city"]);
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [area_list objectAtIndex:indexPath.row];
    if (self.areaCityType == Select_Area) {
        if ([dic objectForKey:@"cities"] != nil) {
            NSMutableArray *list = [dic objectForKey:@"cities"];
            [self gotoNextController:list];
            return;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_AREA_CITY object:dic];
    [self popToBreakRuleController];
}

- (void)gotoNextController:(NSMutableArray *)list
{
    AreaCitySelectController *area = [[AreaCitySelectController alloc] init];
    area.title = @"选择城市";
    area.areaCityType = Select_City;
    area.area_list = list;
    [self.navigationController pushViewController:area animated:YES];
}


- (IBAction)backMainController:(id)sender
{
       [self.navigationController popViewControllerAnimated:YES];
}


- (void)popToBreakRuleController
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CarInfoViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
