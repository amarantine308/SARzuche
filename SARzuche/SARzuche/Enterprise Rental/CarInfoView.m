//
//  CarInfoView.m
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CarInfoView.h"
#import "RBCustomDatePickerView.h"
#import "AreaCitySelectController.h"
#import "TenancyPickView.h"
#import "ConstDefine.h"
#import "CustomAlertView.h"
#import "ConstString.h"

#define TAG_VIEW_DATE      201 // 取车日期
#define TAG_VIEW_TENANCY   202 // 租期

#define DIC_FOR_CITYNAME @"DIC_FOR_CITYNAME"  //城市
#define DIC_FOR_TAKEDATE @"DIC_FOR_TAKEDATE"  //取车日期
#define DIC_FOR_CARTYPE @"DIC_FOR_CARTYPE"    //意向车型
#define DIC_FOR_CAEBRAND @"DIC_FOR_CAEBRAND"  //意向汽车品牌
#define DIC_FOR_TENANCY @"DIC_FOR_TENANCY"      //租期
#define DIC_FOR_CARNUMBER @"DIC_FOR_CARNUMBER"  //车辆数
#define DIC_FOR_DRIVINGSERVICE @"DIC_FOR_DRIVINGSERVICE" //是否代驾
#define RGB(r,g,b,al) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:al]
#define labRGB RGB(156,156,156,1)

#define Height_Section0 35
#define Height_Section  15
#define Height_Cell     44

#define Width_NextBtn       580.0 / 2.0
#define Height_NextBtn      88.0  / 2.0
#define OriginX_NextBtn   (self.bounds.size.width - Width_NextBtn) / 2.0

#define Height_SepratorLine 0.5

@implementation CarInfoView
{
    UITableView *pTableView;
    NSMutableArray *pDataSource;
    int carNum;
    int tagOfSelectView;
    
    UIView *dateBackView;
    TenancyPickView *tenancyBackView;
    
    RBCustomDatePickerView *datePickerView;
    
    NSString *getCarDate;   // 取车日期
    NSString *tenancy;      // 租期
    
    CGRect constantFrame;
    
    UIPickerView *pick_tenancy; //租期选择器
    
    UILabel *m_moreCarPrompt;
}
@synthesize cartypeLabel;
@synthesize cityLabel;
@synthesize delegate;
@synthesize brand, carType;


- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        [self addGestureRecognizer:singleTapGR];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification *note){
        [self removeGestureRecognizer:singleTapGR];
    }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        constantFrame = frame;
        
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        pDataSource = [[NSMutableArray alloc] initWithObjects:@"取车城市", @"取车日期", @"意向车型", @"租期", @"车辆数", /*@"是否代驾", */nil];
        
        float Height_TableView = (Height_Section0 + Height_Cell) + (Height_Section + Height_Cell) * ([pDataSource count] - 1);
        pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, Height_TableView)];
        pTableView.delegate = self;
        pTableView.dataSource = self;
        pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        pTableView.backgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        [self addSubview:pTableView];
        
        CGRect tmpRect = CGRectMake(pTableView.frame.origin.x + 10, pTableView.frame.origin.y + pTableView.frame.size.height, pTableView.frame.size.width - 20, 40);
        m_moreCarPrompt = [[UILabel alloc] initWithFrame:tmpRect];
        m_moreCarPrompt.numberOfLines = 2;
        m_moreCarPrompt.text = STR_MORE_CAR_PROMPT;
        m_moreCarPrompt.font = FONT_LABEL;
        m_moreCarPrompt.textColor = [UIColor orangeColor];//COLOR_LABEL_GRAY;
        m_moreCarPrompt.backgroundColor = [UIColor clearColor];
        [self addSubview:m_moreCarPrompt];
        
        UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_TableView + m_moreCarPrompt.frame.size.height, self.bounds.size.width, self.bounds.size.height - Height_TableView - m_moreCarPrompt.frame.size.height)];
        btnBackView.backgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        [self addSubview:btnBackView];
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake(OriginX_NextBtn, (btnBackView.bounds.size.height - Height_NextBtn) / 2.0, Width_NextBtn, Height_NextBtn);
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [btnBackView addSubview:nextBtn];
        
        carNum = 1;
        getCarDate = [NSString string];
        tenancy = @"一周以内";
    }
    [self setUpForDismissKeyboard];
    return self;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
        return Height_Section0;
    
    return Height_Section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Height_Cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [pDataSource count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview;
    if (section == 0)
    {
        headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, Height_Section0)];
        headview.backgroundColor = tableView.backgroundColor;
        UILabel *lab_text = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, Height_Section0)];
        lab_text.text = @"车辆信息";
        lab_text.font = [UIFont fontWithName:@"helvetica" size:17];
        lab_text.backgroundColor = [UIColor clearColor];
        lab_text.textAlignment = NSTextAlignmentLeft;
        [headview addSubview:lab_text];
    }
    else
    {
        headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, Height_Section)];
        
    }
    headview.backgroundColor = tableView.backgroundColor;
    
    UIImageView *sepratorLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, Height_SepratorLine)];
    sepratorLine1.image = [UIImage imageNamed:@"分割线.png"];
    [headview addSubview:sepratorLine1];
    
    UIImageView *sepratorLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, headview.bounds.size.height - Height_SepratorLine, self.bounds.size.width, Height_SepratorLine)];
    sepratorLine2.image = [UIImage imageNamed:@"分割线.png"];
    [headview addSubview:sepratorLine2];
    
    return headview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

    UIImageView *accessoryImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 15 - 15, (Height_Cell - 15.0) / 2.0, 15, 15)];
    accessoryImg.image = [UIImage imageNamed:@"请选择.png"];
    [cell.contentView addSubview:accessoryImg];
    
    cell.textLabel.text = [pDataSource objectAtIndex:indexPath.section];
    cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:15];
    
    float OriginX_MiddleLabel = 100;
    float Width_Label = 150;
    switch (indexPath.section)
    {
        case 0: // 取车城市
        {
            cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_MiddleLabel, 0, Width_Label, Height_Cell)];
            cityLabel.text = @"南京";
            cityLabel.textColor = labRGB;
            cityLabel.textAlignment = NSTextAlignmentLeft;
            cityLabel.backgroundColor = [UIColor clearColor];
            cityLabel.font = [UIFont fontWithName:@"helvetica" size:15];
            [cell.contentView addSubview:cityLabel];
        }
            break;
            
        case 1: // 取车日期
        {
            dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_MiddleLabel, 0, Width_Label, Height_Cell)];
            dateLabel.textColor = labRGB;
            dateLabel.textAlignment = NSTextAlignmentLeft;
            dateLabel.backgroundColor = [UIColor clearColor];
            dateLabel.font = [UIFont fontWithName:@"helvetica" size:15];
            
            if ([getCarDate isEqualToString:@""])
            {
                NSDate *nowTime = [NSDate date];
                NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                [timeFormatter setDateFormat:@"YYYY-MM-dd"];
                dateLabel.text = [timeFormatter stringFromDate:nowTime];
            }
            else
            {
                dateLabel.text = getCarDate;
            }
            [cell.contentView addSubview:dateLabel];
        }
            break;
            
        case 2: // 意向车型
            cartypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_MiddleLabel, 0, Width_Label, Height_Cell)];
            [cell.contentView addSubview:cartypeLabel];
            cartypeLabel.textAlignment =NSTextAlignmentLeft;
            cartypeLabel.text = @"";
            cartypeLabel.textColor = labRGB;
            cartypeLabel.backgroundColor = [UIColor clearColor];
            cartypeLabel.font = [UIFont fontWithName:@"helvetica" size:15];
            break;
            
        case 3: // 租期
        {
            if (![tenancy isEqualToString:@""])
            {
                tenancyLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_MiddleLabel, 0, Width_Label, Height_Cell)];
                tenancyLabel.text = tenancy;
                tenancyLabel.textAlignment = NSTextAlignmentLeft;
                tenancyLabel.backgroundColor = [UIColor clearColor];
                tenancyLabel.textColor = labRGB;
                tenancyLabel.font = [UIFont fontWithName:@"helvetica" size:15];
                [cell.contentView addSubview:tenancyLabel];
            }
        }
            break;
            
        case 4: // 车辆数
        {
            accessoryImg.hidden = YES;
            
            float originX = 15;
            float btnWidth = 30;
            float btnHeight = 30;
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(self.bounds.size.width - originX - btnWidth+5, (Height_Cell - btnHeight) / 2.0, btnWidth, btnHeight);
            addBtn.layer.borderColor = [RGB(184, 210, 234, 1) CGColor];
            addBtn.layer.borderWidth = 1.0;
            addBtn.layer.masksToBounds = YES;
            [addBtn setTitle:@"+" forState:UIControlStateNormal];
            [addBtn setTitleColor:RGB(132, 132, 132, 1) forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addBtn];
            
            float numWidth = 50;
            numTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.bounds.size.width - originX - btnWidth - numWidth, (Height_Cell - btnHeight) / 2.0, numWidth, btnHeight)];
            numTextField.layer.borderColor = [RGB(232, 232, 232, 1) CGColor];
            numTextField.layer.borderWidth = 1.0;
            numTextField.layer.masksToBounds = YES;
            
            numTextField.text = [NSString stringWithFormat:@"%d", carNum];
            numTextField.delegate = self;
            numTextField.keyboardType = UIKeyboardTypeNumberPad;
            numTextField.textAlignment = NSTextAlignmentCenter;
            numTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [cell.contentView addSubview:numTextField];
            
            UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            subBtn.frame = CGRectMake(self.bounds.size.width - originX - btnWidth - numWidth - btnWidth-5, (Height_Cell - btnHeight) / 2.0, btnWidth, btnHeight);
            subBtn.layer.borderColor = [RGB(244, 181, 161, 1) CGColor];
            subBtn.layer.borderWidth = 1.0;
            subBtn.layer.masksToBounds = YES;
            [subBtn setTitle:@"-" forState:UIControlStateNormal];
            [subBtn setTitleColor:RGB(132, 132, 132, 1) forState:UIControlStateNormal];
            [subBtn addTarget:self action:@selector(subBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:subBtn];
        }
            break;
            
        case 5: // 是否代驾
        {
            accessoryImg.hidden = YES;
            
            drivingSerLab = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_MiddleLabel, 0, Width_Label, Height_Cell)];
            drivingSerLab.text = @"是";
            drivingSerLab.textColor = labRGB;
            drivingSerLab.textAlignment = NSTextAlignmentLeft;
            drivingSerLab.backgroundColor = [UIColor clearColor];
            drivingSerLab.font = [UIFont fontWithName:@"helvetica" size:15];
            [cell.contentView addSubview:drivingSerLab];

            if (IOS_VERSION_ABOVE_7)
            {
                drivingServiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.bounds.size.width - 65, 4, 0, 0)];
            }
            else
            {
                drivingServiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.bounds.size.width - 90, 4, 0, 0)];
            }
            
            [drivingServiceSwitch setOn:YES];
            drivingServiceSwitch.onTintColor = RGB(43, 133, 208, 1);
            [drivingServiceSwitch addTarget:self action:@selector(drivingServiceStatusChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:drivingServiceSwitch];
        }
            break;
            
        default:
            break;
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //收回键盘
    [self resignKeyBoard];
    
    dateBackView.hidden = YES;
    tenancyBackView.hidden = YES;
    
    switch (indexPath.section)
    {
        case 0: // 取车城市
            if (delegate && [delegate respondsToSelector:@selector(enterAreaCityController)])
            {
                [delegate enterAreaCityController];
            }
            break;
        case 4: // 车辆数
        case 5: // 是否代驾
            [tableView deselectRowAtIndexPath: indexPath animated: YES];
            break;
            
        case 1: // 取车日期
        {
            if (datePickerView)
            {
                datePickerView.hidden = NO;
            }
            else
            {
                datePickerView = [[RBCustomDatePickerView alloc] initWithFrame:self.bounds];
                datePickerView.delegate = self;
                [self addSubview:datePickerView];
            }
            break;
        }
        case 2: // 意向车型
        {
            if (delegate && [delegate respondsToSelector:@selector(enterIntensionCarView)])
            {
                [delegate enterIntensionCarView];
            }
        }
            break;
            
        case 3: // 租期
        {
            if (tenancyBackView)
            {
                tenancyBackView.hidden = NO;
            }
            else
            {
                tenancyBackView = [[TenancyPickView alloc] initWithFrame:self.bounds];
                tenancyBackView.delegate = self;
                [self addSubview:tenancyBackView];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 按钮点击事件
-(void)nextBtnClicked
{
//    if ([numTextField.text length] == 0 || [numTextField.text isEqualToString:@"0"])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"车辆数量不能为空或者为0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
    if ([cityLabel.text length] == 0 || [dateLabel.text length] == 0 || [cartypeLabel.text length] == 0 || [tenancyLabel.text length] == 0 || [numTextField.text length] == 0 || [numTextField.text isEqualToString:@"0"]) {
        [self showAlertMessageWithString:@"请补全所有信息"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setObject:GET(cityLabel.text) forKey:DIC_FOR_CITYNAME];
    [dic setObject:GET(dateLabel.text) forKey:DIC_FOR_TAKEDATE];
    [dic setObject:GET(self.carType) forKey:DIC_FOR_CARTYPE];
    [dic setObject:GET(self.brand) forKey:DIC_FOR_CAEBRAND];
    NSArray *list = @[@"一周以内", @"一个月以内", @"三个月以内", @"半年以内", @"一年以内", @"一年以上"];
    int index;
    for (index = 0; index < [list count]; index++)
    {
        if ([tenancyLabel.text isEqualToString:[list objectAtIndex:index]])
        {
            break;
        }
    }
    [dic setObject:[list objectAtIndex:index] forKey:DIC_FOR_TENANCY];
    [dic setObject:GET(numTextField.text) forKey:DIC_FOR_CARNUMBER];
    //是否代驾默认为是
    NSString *drivingStr = @"1";
//    if (drivingServiceSwitch.isOn) {
//        drivingStr = @"1";
//    }
    [dic setObject:GET(drivingStr) forKey:DIC_FOR_DRIVINGSERVICE];
    if (delegate && [delegate respondsToSelector:@selector(enterEnterpriseInfoView:)])
    {
        [delegate enterEnterpriseInfoView:dic];
    }
}


- (void)showAlertMessageWithString:(NSString *)str
{
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:str delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [alert needDismisShow];
}

-(void)addBtnClicked
{
    if (carNum < 100)
    {
        carNum ++;
    }
    numTextField.text = [NSString stringWithFormat:@"%d",carNum];
//    //刷新车辆列表数据
//    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:4];
//    [pTableView reloadSections:indexset withRowAnimation:NO];
}

-(void)subBtnClicked
{
    if (carNum > 1)
    {
        carNum --;
    }
    numTextField.text = [NSString stringWithFormat:@"%d",carNum];
//    //刷新车辆列表数据
//    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:4];
//    [pTableView reloadSections:indexset withRowAnimation:NO];
}

-(void)drivingServiceStatusChanged:(id)sender
{
    UISwitch *drivingSwitch = sender;
    if (drivingSwitch.isOn)
    {
        drivingSerLab.text = @"是";
    }
    else
    {
        drivingSerLab.text = @"否";
    }
}

-(void)cancelBtnClicked
{
    switch (tagOfSelectView)
    {
        case TAG_VIEW_DATE:
            dateBackView.hidden = YES;
            break;
            
        case TAG_VIEW_TENANCY:
            tenancyBackView.hidden = YES;
            break;
            
        default:
            break;
    }
}

#pragma mark - DateSelectViewDelegate
-(void)selectString:(NSString *)str
{
    switch (tagOfSelectView)
    {
        case TAG_VIEW_DATE:
            getCarDate = str;
            dateBackView.hidden = YES;
            break;
            
        case TAG_VIEW_TENANCY:
            tenancy = str;
            tenancyBackView.hidden = YES;
            break;
            
        default:
            break;
    }
    [pTableView reloadData];
}

#pragma mark - 取车日期选择界面协议方法
- (void)clickSureBtn:(int)year :(int)month :(int)day
{
    dateLabel.text = [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day];
    [datePickerView setHidden:YES];
}

#pragma mark - 租期选择界面协议方法
- (void)clickSureBtnInTenancyPick:(NSString *)str;
{
    tenancyLabel.text = str;
    [tenancyBackView setHidden:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
    [self DownSelfView];
}


- (void)resignKeyBoard{
    [numTextField resignFirstResponder];
    [self DownSelfView];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 3)
        return NO;
    if ([textField.text integerValue] > 100) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float boundsHeight = self.bounds.size.height;
    if (boundsHeight < 500)
    {
        [self upSelfView];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    float boundsHeight = self.bounds.size.height;
    if (boundsHeight < 500)
    {
        [self DownSelfView];
    }
    if ([textField.text integerValue] >100) {
        textField.text = @"100";
    }
    carNum = [textField.text integerValue];
}

- (void)upSelfView
{
    NSInteger width = [[UIScreen mainScreen] bounds].size.width;
    NSInteger height = [[UIScreen mainScreen] bounds].size.height;
    
    int y = -70;
//    if (IS_IPHONE5) {
//        y = -70;
//    }else{
//        y = -100;
//    }
    CGRect frame_old = CGRectMake(0, y, width, height);
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = frame_old;
    }];
}

- (void)DownSelfView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = constantFrame;
    }];
}

@end
