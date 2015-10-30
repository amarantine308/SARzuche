//
//  TenancyPickView.m
//  SARzuche
//
//  Created by dyy on 14-10-29.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "TenancyPickView.h"
#import "UIColor+Helper.h"

//颜色和透明度设置
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@implementation TenancyPickView
@synthesize delegate;

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
        [self initPickUI:frame];
    }
    return self;
}

- (void)initPickUI:(CGRect)frame
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    list_tenancy = @[@"一周以内",@"一个月以内",@"三个月以内",@"半年以内",@"一年以内",@"一年以上"];
    
    float originY= 184.0;
    float pickHeight = 139.0;
    
    //透明层
    UIView *vi_alpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-originY)];
    vi_alpha.backgroundColor = [UIColor blackColor];
    vi_alpha.alpha = 0.5;
    [self addSubview:vi_alpha];
    
    //租期选择器
    pick_tenancy = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height-originY, frame.size.width, pickHeight)];
    pick_tenancy.delegate = self;
    pick_tenancy.dataSource = self;
    [pick_tenancy selectRow:1 inComponent:0 animated:YES];
    [pick_tenancy setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:pick_tenancy];
    
    UIButton *btn_cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height-45, frame.size.width/2, 45)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:RGBA(132.0, 132.0, 132.0, 1) forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [btn_cancel setBackgroundColor:[UIColor whiteColor]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    btn_cancel.layer.masksToBounds = YES;
    CGColorRef cgColor = RGBA(221.0, 221.0, 221.0, 1).CGColor;
    btn_cancel.layer.borderColor = cgColor;
    btn_cancel.layer.borderWidth = 1.0;
#endif
    [self addSubview:btn_cancel];
    
    UIButton *btn_sure = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height-45, frame.size.width/2, 45)];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure setTitleColor:RGBA(43.0, 131.0, 202.0, 1)forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [btn_sure setBackgroundColor:[UIColor whiteColor]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    btn_sure.layer.masksToBounds = YES;
    CGColorRef cColor = RGBA(43.0, 131.0, 202.0, 1).CGColor;
    btn_sure.layer.borderColor = cColor;
    btn_sure.layer.borderWidth = 1.0;
#endif
    [self addSubview:btn_sure];
    
//    UIView *vi_line = [[UIView alloc] initWithFrame:CGRectMake(self.center.x, frame.size.height-45, 1, 45)];
//    vi_line.backgroundColor = RGBA(43.0, 131.0, 202.0, 1);
//    [self addSubview:vi_line];
}

- (void)clickCancel
{
    [self setHidden:YES];
}

- (void)clickSure
{
    [self setHidden:YES];
    int selsctIndex = [pick_tenancy selectedRowInComponent:0];
    if (delegate && [delegate respondsToSelector:@selector(clickSureBtnInTenancyPick:)]) {
        [delegate clickSureBtnInTenancyPick:[list_tenancy objectAtIndex:selsctIndex]];
    }
}


//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回books.count，表明books包含多少个元素，该控件就包含多少行
    return list_tenancy.count;
}

// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回books中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用books中的第几个元素
    return [list_tenancy objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self setHidden:YES];
}

@end
