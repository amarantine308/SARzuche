//
//  ApplyInvoiceViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-20.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ApplyInvoiceViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "ConstImage.h"
#import "OrderManager.h"
#import "HZAreaPickerView.h"
#import "LoadingClass.h"
#import "PublicFunction.h"



#define ADDRESS_TAG             2001
#define HEAD_TAG                2002

#define LABLE_ROW_HEIGHT        30
#define NOTE_LABLE_ROW_HEIGHT        20
#define BUTTON_ROW_HEIGHT       40
#define SPACE_VIEW_HEIGHT       10
#define LABEL_START_X           10

#define FRAME_INVOICE_VIEW              CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight)
#define FRAME_INVOICE_INFO              CGRectMake(LABEL_START_X, 0, 300, LABLE_ROW_HEIGHT)
#define FRAME_INVOICE_HEAD              CGRectMake(10, 30, 300, LABLE_ROW_HEIGHT)
#define FRAME_INVOICE_HEAD_FIELD        CGRectMake(0, LABLE_ROW_HEIGHT, 320, BUTTON_ROW_HEIGHT)
#define FRAME_INVOICE_ADRESS            CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT + BUTTON_ROW_HEIGHT, 300, LABLE_ROW_HEIGHT)
#define FRAME_PROVINCE                  CGRectMake(15, LABLE_ROW_HEIGHT * 2 + BUTTON_ROW_HEIGHT, 90, BUTTON_ROW_HEIGHT)
#define FRAME_CITY                      CGRectMake(115, LABLE_ROW_HEIGHT * 2 + BUTTON_ROW_HEIGHT, 90, BUTTON_ROW_HEIGHT)
#define FRAME_DISTRICT                  CGRectMake(215, LABLE_ROW_HEIGHT * 2 + BUTTON_ROW_HEIGHT, 90, BUTTON_ROW_HEIGHT)
#define FRAME_ADRESS_FIELD              CGRectMake(0, LABLE_ROW_HEIGHT * 2 + BUTTON_ROW_HEIGHT * 2 + 10, 320, BUTTON_ROW_HEIGHT)
#define FRAME_ORDER_INFO                CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 2 + BUTTON_ROW_HEIGHT * 3 + 20, 300, LABLE_ROW_HEIGHT)
#define FRAME_ORDER_ID                  CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 3 + BUTTON_ROW_HEIGHT * 3 + 20, 300, LABLE_ROW_HEIGHT)
#define FRAME_COST                      CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 4 + BUTTON_ROW_HEIGHT * 3 + 20, 300, LABLE_ROW_HEIGHT)
#define FRAME_APPLY_NOTE                CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 5 + BUTTON_ROW_HEIGHT * 3 + 20, 300, LABLE_ROW_HEIGHT)
#define FRAME_NOTE1                     CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 6 + BUTTON_ROW_HEIGHT * 3 + 20, 300, NOTE_LABLE_ROW_HEIGHT)
#define FRAME_NOTE2                     CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 6 + BUTTON_ROW_HEIGHT * 3 + 20+NOTE_LABLE_ROW_HEIGHT, 300, NOTE_LABLE_ROW_HEIGHT)
#define FRAME_NOTE3                     CGRectMake(LABEL_START_X, LABLE_ROW_HEIGHT * 6 + BUTTON_ROW_HEIGHT * 3 + 20 +NOTE_LABLE_ROW_HEIGHT*2, 300, NOTE_LABLE_ROW_HEIGHT *3)


#define FRAME_APPLY_BTN                 CGRectMake(10, MainScreenHeight - bottomButtonHeight - controllerViewStartY - bottomButtonHeight/2, MainScreenWidth-20, bottomButtonHeight)


@interface ApplyInvoiceViewController ()<HZAreaPickerDelegate>
{
    UILabel *m_invoiceInfo;
    UILabel *m_invoiceHead;
    UITextField *m_invoiceHeadField;
    UILabel *m_invoiceAdress;
    UIButton *m_province;
    UIButton *m_city;
    UIButton *m_district;
    UITextField *m_invoiceAddressField;
    
    UILabel *m_orderInfo;
    UILabel *m_orderID;
    UILabel *m_cost;
    
    UILabel *m_applyNote;
    UILabel *m_note1;
    UILabel *m_note2;
    UILabel *m_note3;
    
    UIButton *m_applyInvoiceBtn;
    srvOrderData *m_oerderData;
    
    NSInteger m_nViewHeight;
}
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (copy , nonatomic)NSString *areaValue;
-(void)cancelLocatePicker;


@end

@implementation ApplyInvoiceViewController
@synthesize m_orderData;

-(id)initWithOrderData:(srvOrderData *)orderData
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        m_oerderData = orderData;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)cancelLocatePicker
{
    if (self.locatePicker)
    {
        [self.locatePicker cancelPicker];
        self.locatePicker.delegate = nil;
        self.locatePicker = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initApplyInvoicView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_REQUEST_TICKET];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initApplyInvoicView
{
    CGRect tmpRect;
    UIView *tmpView = [[UIView alloc] initWithFrame:FRAME_INVOICE_VIEW];
    tmpView.backgroundColor = COLOR_BACKGROUND;
    //发票信息
    tmpRect =   FRAME_INVOICE_INFO;
    m_invoiceInfo = [[UILabel alloc] initWithFrame:tmpRect];
    m_invoiceInfo.text = STR_TICKET_INFO;
    [tmpView addSubview:m_invoiceInfo];
    m_nViewHeight += m_invoiceInfo.frame.origin.y + m_invoiceInfo.frame.size.height;
#if 0
    //发票抬头
    m_invoiceHead = [[UILabel alloc] initWithFrame:FRAME_INVOICE_HEAD];
    m_invoiceHead.text = STR_TICKET_HEAD;
    [tmpView addSubview:m_invoiceHead];
#endif
    //发票抬头
    m_invoiceHeadField = [[UITextField alloc] initWithFrame:FRAME_INVOICE_HEAD_FIELD];
    m_invoiceHeadField.placeholder = STR_TICKET_ENTER_HEAD;
    m_invoiceHeadField.clearsOnBeginEditing=YES;
    m_invoiceHeadField.delegate = self;
    [m_invoiceHeadField setBackground:[UIImage imageNamed:IMG_AREA]];
    m_invoiceHeadField.tag = HEAD_TAG;
    [tmpView addSubview:m_invoiceHeadField];
    m_nViewHeight += m_invoiceHeadField.frame.size.height;
    
    //收票地址
    m_invoiceAdress = [[UILabel alloc] initWithFrame:FRAME_INVOICE_ADRESS];
    m_invoiceAdress.text = STR_TICKET_ADDRESS;
    [tmpView addSubview:m_invoiceAdress];
    
    //省
    m_province = [[UIButton alloc] initWithFrame:FRAME_PROVINCE];
    [m_province setTitle:@"请选择" forState:UIControlStateNormal];
    [m_province setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_province addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
    [m_province setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tmpView addSubview:m_province];
    //市
    m_city = [[UIButton alloc] initWithFrame:FRAME_CITY];
    [m_city setTitle:@"请选择" forState:UIControlStateNormal];
    [m_city setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_city addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
    [m_city setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tmpView addSubview:m_city];
    
    //区
    m_district = [[UIButton alloc] initWithFrame:FRAME_DISTRICT];
    [m_district setTitle:@"请选择" forState:UIControlStateNormal];
    [m_district setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_district addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
    [m_district setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tmpView addSubview:m_district];
    
    //输入具体地址
    m_invoiceAddressField = [[UITextField alloc] initWithFrame:FRAME_ADRESS_FIELD];
    m_invoiceAddressField.clearsOnBeginEditing=YES;
    m_invoiceAddressField.placeholder = STR_TICKET_ENTER_ADDRESS;
    m_invoiceAddressField.delegate = self;
    m_invoiceAddressField.tag = ADDRESS_TAG;
    [m_invoiceAddressField setBackground:[UIImage imageNamed:IMG_AREA]];
    [tmpView addSubview:m_invoiceAddressField];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:FRAME_ORDER_INFO];
    whiteView.frame = CGRectMake(0, FRAME_ORDER_INFO.origin.y, MainScreenWidth, 90);
    whiteView.backgroundColor = [UIColor whiteColor];
    [tmpView addSubview:whiteView];
    
    //订单信息
    m_orderInfo = [[UILabel alloc] initWithFrame:FRAME_ORDER_INFO];
    m_orderInfo.text = STR_ORDER_INFO;
    m_orderInfo.textColor = COLOR_LABEL_GRAY;
    [tmpView addSubview:m_orderInfo];
    
    UIView *separatroView = [[PublicFunction ShareInstance] getSeparatorView:CGRectMake(10, m_orderInfo.frame.origin.y + m_orderInfo.frame.size.height - 1, MainScreenWidth - 20, 1)];
    [tmpView addSubview:separatroView];
    
    //订单号
    m_orderID = [[UILabel alloc] initWithFrame:FRAME_ORDER_ID];
    m_orderID.text = STR_ORDER_ID;
    m_orderID.textColor = COLOR_LABEL_GRAY;
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_orderID withString:GET(m_orderData.m_orderNum) withColor:COLOR_LABEL];
    [tmpView addSubview:m_orderID];
    
    
    //消费金额
    m_cost = [[UILabel alloc] initWithFrame:FRAME_COST];
    m_cost.text = STR_ORDER_COST;
    m_cost.textColor = COLOR_LABEL_GRAY;
    NSString *strTotal = [NSString stringWithFormat:STR_COST_FORMAT, ([GET(m_orderData.m_totalPrice) length] == 0? @"0" : GET(m_orderData.m_totalPrice))];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_cost withString:strTotal withColor:COLOR_LABEL];
    [tmpView addSubview:m_cost];
    
    //开票须知
    m_applyNote = [[UILabel alloc] initWithFrame:FRAME_APPLY_NOTE];
    m_applyNote.text = STR_TICKET_NOTE;
    m_applyNote.textColor = COLOR_LABEL_GRAY;
    [tmpView addSubview:m_applyNote];
    
    //note1
    m_note1 = [[UILabel alloc] initWithFrame:FRAME_NOTE1];
    m_note1.text = STR_TICKET_NOTE1;
    m_note1.font = FONT_LABEL;
//    m_note1.numberOfLines = 2;
//    m_note1.lineBreakMode = NSLineBreakByWordWrapping;
//    m_note1.lineBreakMode = NSLineBreakByCharWrapping;
    m_note1.textAlignment = NSTextAlignmentLeft;
    m_note1.textColor = COLOR_LABEL;
    [tmpView addSubview:m_note1];
    
    //note2
    m_note2 = [[UILabel alloc] initWithFrame:FRAME_NOTE2];
    m_note2.text = STR_TICKET_NOTE2;
    m_note2.font = FONT_LABEL;
//    m_note2.numberOfLines = 2;
    m_note2.textColor = COLOR_LABEL;
    [tmpView addSubview:m_note2];
#if 0
    UIFont *font = [UIFont fontWithName:@"Arial" size:12];
    CGSize tmpsize = CGSizeMake(300,2000);
    CGSize labelsize = [STR_TICKET_NOTE3 sizeWithFont:font constrainedToSize:tmpsize lineBreakMode:UILineBreakModeWordWrap];
    //    CGSize size = [STR_TICKET_NOTE3 boundingRectWithSize:<#(CGSize)#> options: attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
//    [m_note3.frame = CGRectMake:(0 ,0, labelsize.width, labelsize.height)];
    
    m_note3 = [[UILabel alloc] initWithFrame:CGRectMake(FRAME_NOTE3.origin.x, FRAME_NOTE3.origin.y, FRAME_NOTE3.size.width, labelsize.height) ];
#endif
    //note3
    m_note3 = [[UILabel alloc] initWithFrame:FRAME_NOTE3];
    m_note3.text = STR_TICKET_NOTE3;
    m_note3.numberOfLines = 3;
    m_note3.font = FONT_LABEL;
    m_note3.textColor = COLOR_LABEL;
    m_note3.textAlignment = NSTextAlignmentLeft;
    m_note3.lineBreakMode = NSLineBreakByWordWrapping;
    [tmpView addSubview:m_note3];
    
    //申请开票按钮
    m_applyInvoiceBtn = [[UIButton alloc] initWithFrame:FRAME_APPLY_BTN];
    [m_applyInvoiceBtn setTitle:STR_REQUEST_TICKET forState:UIControlStateNormal];
    [m_applyInvoiceBtn addTarget:self action:@selector(applyBtn) forControlEvents:UIControlEventTouchUpInside];
    m_applyInvoiceBtn.backgroundColor = [UIColor greenColor];
    [m_applyInvoiceBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [tmpView addSubview:m_applyInvoiceBtn];
    
    [self.view addSubview:tmpView];
}


-(void)applyBtn
{
    NSLog(@"Apply invoice");
    //申请开票 m_orderData.m_orderNum
    if (!m_invoiceHeadField.text || [m_invoiceHeadField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                        message:@"发票抬头不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(!m_invoiceAddressField.text || [m_invoiceAddressField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"
                                                        message:@"详细地址不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];

    }
#if 0
    else if (!m_city.titleLabel.text)
    {
    }
    else if (!m_district.titleLabel.text)
    {
    }
    else if(!m_province.titleLabel.text)
    {
    }
#endif
    else
    {
        NSString *strTotal = ([GET(m_orderData.m_totalPrice) length] == 0? @"0" : GET(m_orderData.m_totalPrice));
    NSString *place = [NSString stringWithFormat:@"%@%@",GET(self.areaValue),m_invoiceAddressField.text];
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *temp1 = [[BLNetworkManager shareInstance]  addTicketWithUserId:[User shareInstance].id
                                                                            userName:[User shareInstance].name
                                                                             address:place
                                                                               phone:[User shareInstance].phone
                                                                               title:m_invoiceHeadField.text
                                                                               price:strTotal
                                                                             orderId:self.m_orderData.m_orderNum
                                                                            delegate:self];
    temp1 = nil;
    }
}
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict)
    {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        NSLog(@"========%@",self.areaValue);
        [m_province setTitle:picker.locate.state forState:UIControlStateNormal];
        [m_city setTitle:picker.locate.city forState:UIControlStateNormal];
        [m_district  setTitle:picker.locate.district forState:UIControlStateNormal];

    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case HEAD_TAG:
            [m_invoiceHeadField resignFirstResponder];
            break;
        case ADDRESS_TAG:
            [m_invoiceAddressField resignFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
//    CGRect rect = self.locatePicker.frame;
    
 
    
    [m_invoiceAddressField resignFirstResponder];
    [m_invoiceHeadField resignFirstResponder];
    
    NSEnumerator *enumurator = [touches objectEnumerator];
    
    id touch;
    while (touch = [enumurator nextObject])
    {
        if ([touch isKindOfClass:[UITouch class]])
        {
            UITouch *tmpTouch = touch;
            if ([NSStringFromClass([tmpTouch.view class]) isEqualToString:@"UIPickerTableViewTitledCell"])
            {
                [[self nextResponder] touchesBegan:touches withEvent:event];
                return;
            }
        }
    }

    [self cancelLocatePicker];

}

- (void)chooseArea:(id)sender
{
    [m_invoiceAddressField resignFirstResponder];
    [m_invoiceHeadField resignFirstResponder];
    
    if (self.locatePicker == nil) {
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self] ;
        self.locatePicker.userInteractionEnabled = YES;
        [self.locatePicker showInView:self.view];
        
        [self pickerDidChaneStatus:self.locatePicker];
    }
}
#pragma mark - FMNetworkManager delegate

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:fmNetworkRequest.responseData message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:fmNetworkRequest.responseData message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
   
}

@end
