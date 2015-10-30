//
//  IdentifyVerificationViewController.m
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "IdentifyVerificationViewController.h"
//#import "NSData+ExtendNSData.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "User.h"
#import "ConstDefine.h"
#import "UIImageView+WebCache.h"


#define TAG_BTN_IdCardFront    201 // 上传身份证正面
#define TAG_BTN_IdCardBack     202 // 上传身份证反面
#define TAG_BTN_DrivingLicense 203 // 上传驾驶证

#define OriginX_TextField       15
#define Width_TextField         self.view.bounds.size.width - OriginX_TextField * 2
#define Height_TextField        25

#define Height_SpaceView        5
#define Height_SepratorView     0.5

#define Width_IdCardLabel       100
#define Height_IdCardLabel      25

#define Width_FrontBackLabel    120
#define Height_FrontBackLabel   22

#define OriginX_IdCardImageView 40
#define Width_IdCardImageView   252.0 / 2.0
#define Height_IdCardImageView  (160.0) / 2.0
#define Height_DriverId         (200.0 + 20)/2.0

#define Width_dlImageView       500.0 / 2.0
#define Height_dlImageView      160.0 / 2.0

#define OriginX_TextView        10
#define Width_TextView          self.view.bounds.size.width - OriginX_TextView * 2
#define Height_TextView         50

#define Width_CommitBtn         580.0 / 2.0
#define Height_CommitBtn        88.0  / 2.0
#define Height_CommitBtnBk      74.0

#define OriginX                 0.0

#define Screen_With              [[UIScreen mainScreen] bounds].size.width

#define White_first_height      44.0

#define Color_SpaceView         [UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:245.0 / 255.0 alpha:1.0]
#define Color_Text              [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0]


@interface IdentifyVerificationViewController ()

@end

@implementation IdentifyVerificationViewController
{
    UIScrollView *scrollView;
    UIView *statusBackView;
    UILabel *contentLabel;
    
    UITextField *idCardNumTextField;
    UIImageView *frontImageView;
    UIImageView *backImageView;
    UIImageView *dlImageView;
    UIButton *frontBtn;
    UIButton *backBtn;
    UIButton *dlBtn;
    UIButton *commitBtn;
    UIView *btnBackView;
    
    BOOL frontBtnClicked;
    BOOL backBtnClicked;
    BOOL dlBtnClicked;
    
    BOOL frontImgSelected;
    BOOL backImgSelected;
    BOOL dlImgSelected;
    
    UILabel *idCardSizeLabel;
    UILabel *dlSizeLabel;
    
    int tagOfBtn;
    
    int IVStatus; // 1.未提交；2.提交待审核；3.成功；4.失败
}
@synthesize enterType;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"实名认证";
        
        frontBtnClicked = NO;
        backBtnClicked = NO;
        dlBtnClicked = NO;
        
        frontImgSelected = NO;
        backImgSelected = NO;
        dlImgSelected = NO;
        
        IVStatus = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (enterType == IVViewFromRegisterView)
    {
        [customNavBarView setRightButtonWithTitle:@"跳过" target:self rightBtnAction:@selector(backToHomeView)];
    }
    
    [self initView];
    [self getIdentifyVerificationStatus];   // 获取实名认证进度
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取实名认证进度
-(void)getIdentifyVerificationStatus
{
    NSString *userId = [User shareInstance].id;
    if (userId && userId.length > 0)
    {
        [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
        FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getUserInfoWith:userId delegate:self];
        tempRequest = nil;
    }
}

-(void)drawStatusView:(float)originY
{
    float height_statusTitleLabel = 25;
    float height_statusContentLabel = 22;
    float height_statusBackView = height_statusTitleLabel + height_statusContentLabel + Height_SepratorView + Height_SpaceView;
    statusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, height_statusBackView)];
    [self.view addSubview:statusBackView];
    statusBackView.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_TextField, 0, (self.view.bounds.size.width - OriginX_TextField) / 2.0, height_statusTitleLabel)];
    titleLabel.text = @"客服留言";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    [statusBackView addSubview:titleLabel];
    
    UIImageView *statusSepratorView = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_TextField, height_statusTitleLabel, Width_TextField, Height_SepratorView)];
    statusSepratorView.image = [UIImage imageNamed:@"separator@2x.png"];
    [statusBackView addSubview:statusSepratorView];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_TextField, height_statusTitleLabel + Height_SepratorView, self.view.bounds.size.width - OriginX_TextField*2, height_statusContentLabel)];
    contentLabel.text = @"";
    contentLabel.font = [UIFont systemFontOfSize:10];
    contentLabel.textColor = [UIColor orangeColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    [statusBackView addSubview:contentLabel];
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, height_statusTitleLabel + Height_SepratorView + height_statusContentLabel, self.view.bounds.size.width, Height_SpaceView)];
    spaceView.backgroundColor = Color_SpaceView;
    [statusBackView addSubview:spaceView];
}


-(void)drawBtnBackView:(float)originY :(float)height
{
    btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, height)];
    btnBackView.backgroundColor = Color_SpaceView;
    [self.view addSubview:btnBackView];
    
    commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake((self.view.bounds.size.width - Width_CommitBtn) / 2.0, (height - Height_CommitBtn) / 2.0, Width_CommitBtn, Height_CommitBtn);
    [commitBtn setTitle:@"提交意向" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnBackView addSubview:commitBtn];
}

// 初始化ScrollView
-(void)drawScrollView:(float)originY :(float)height
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, height)];
    //scrollView.contentSize = CGSizeMake(320, scrollView.bounds.size.height);
    scrollView.contentSize = CGSizeMake(320, 500);
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;     // 是否自己动适应
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    originY = 0;
    // 身份证号输入框
    idCardNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_TextField, Height_TextField)];
    idCardNumTextField.font = [UIFont systemFontOfSize:14];
    idCardNumTextField.delegate = self;
    idCardNumTextField.placeholder = @"请输入身份证号";
    idCardNumTextField.returnKeyType = UIReturnKeyDone;
    idCardNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scrollView addSubview:idCardNumTextField];
    
    originY += Height_TextField;
    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_SpaceView)];
    spaceView1.backgroundColor = Color_SpaceView;
    [scrollView addSubview:spaceView1];
    
    // 身份证上传label
    originY += Height_SpaceView;
    UILabel *idCardUploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_IdCardLabel, Height_IdCardLabel)];
    idCardUploadLabel.text = @"身份证上传";
    idCardUploadLabel.font = [UIFont systemFontOfSize:14];
    idCardUploadLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:idCardUploadLabel];
    
    idCardSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x+35, originY, Width_FrontBackLabel, Height_IdCardLabel)];
    idCardSizeLabel.text = @"大小限制(250x158)";
    idCardSizeLabel.font = [UIFont systemFontOfSize:10];
    idCardSizeLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:idCardSizeLabel];
    
    originY += Height_IdCardLabel;
    UIImageView *sepratorView1 = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_TextField, Height_SepratorView)];
    sepratorView1.image = [UIImage imageNamed:@"separator@2x.png"];
    [scrollView addSubview:sepratorView1];
    
    originY += Height_SepratorView;
    UILabel *frontLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_FrontBackLabel, Height_FrontBackLabel)];
    frontLabel.text = @"上传手持身份证的正面";
    frontLabel.font = [UIFont systemFontOfSize:10];
    frontLabel.textColor = Color_Text;
    frontLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:frontLabel];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - OriginX_TextField*2 - Width_FrontBackLabel, originY, Width_FrontBackLabel, Height_FrontBackLabel)];
    backLabel.text = @"上传手持身份证的反面";
    backLabel.font = [UIFont systemFontOfSize:10];
    backLabel.textColor = Color_Text;
    backLabel.textAlignment = NSTextAlignmentRight;
    backLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:backLabel];
    
    originY += Height_FrontBackLabel;
    frontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_IdCardImageView, originY, Height_IdCardImageView, Height_IdCardImageView)];
    frontImageView.image = [UIImage imageNamed:@"上传图.png"];
    //处理图片全部显示失真,按比例自适应
    frontImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:frontImageView];
    
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - OriginX_IdCardImageView - Height_IdCardImageView, originY, Height_IdCardImageView, Height_IdCardImageView)];
    backImageView.image = [UIImage imageNamed:@"上传图.png"];
    //处理图片全部显示失真,按比例自适应
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:backImageView];
    
    frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    frontBtn.tag = TAG_BTN_IdCardFront;
    frontBtn.frame = frontImageView.frame;
    frontBtn.backgroundColor = [UIColor clearColor];
    [frontBtn addTarget:self action:@selector(uploadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:frontBtn];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = TAG_BTN_IdCardBack;
    backBtn.frame = backImageView.frame;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(uploadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backBtn];
    
    originY += Height_IdCardImageView;
    UITextView *attentionTextView = [[UITextView alloc] initWithFrame:CGRectMake(OriginX_TextView, originY, Width_TextView, Height_TextView)];
    attentionTextView.font = [UIFont systemFontOfSize:10];
    attentionTextView.text = @"1. 请务必准确填写本人的身份信息，隐私信息未经许可严格保密；\n2. 仅支持5M以下的图片文件 ( jpg, png格式)";
    attentionTextView.textColor = Color_Text;
    attentionTextView.backgroundColor = [UIColor clearColor];
    attentionTextView.userInteractionEnabled = NO;
    [scrollView addSubview:attentionTextView];
    
    originY += Height_TextView;
    UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_SpaceView)];
    spaceView2.backgroundColor = Color_SpaceView;
    [scrollView addSubview:spaceView2];
    
    // 驾驶证上传label
    originY += Height_SpaceView;
    UILabel *dlUploadLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_IdCardLabel, Height_IdCardLabel)];
    dlUploadLabel.text = @"驾驶证上传";
    dlUploadLabel.font = [UIFont systemFontOfSize:14];
    dlUploadLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:dlUploadLabel];
    
    dlSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x+35, originY, Width_FrontBackLabel, Height_FrontBackLabel)];
    dlSizeLabel.text = @"大小限制(500x158)";
    dlSizeLabel.font = [UIFont systemFontOfSize:10];
    dlSizeLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:dlSizeLabel];
    
    originY += Height_IdCardLabel;
    UIImageView *sepratorView2 = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_TextField, Height_SepratorView)];
    sepratorView2.image = [UIImage imageNamed:@"separator@2x.png"];
    [scrollView addSubview:sepratorView2];
    
    originY += Height_SepratorView;
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_FrontBackLabel, Height_FrontBackLabel)];
    addLabel.text = @"上传您的驾驶证";
    addLabel.font = [UIFont systemFontOfSize:10];
    addLabel.textColor = Color_Text;
    addLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:addLabel];
    
    
    originY += Height_FrontBackLabel;
    dlImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - Height_dlImageView) / 2.0, originY, Height_dlImageView, Height_dlImageView)];
    dlImageView.image = [UIImage imageNamed:@"上传图.png"];
    //处理图片全部显示失真,按比例自适应
    //    dlImageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:dlImageView];
    
    dlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dlBtn.tag = TAG_BTN_DrivingLicense;
    dlBtn.frame = dlImageView.frame;
    dlBtn.backgroundColor = [UIColor clearColor];
    [dlBtn addTarget:self action:@selector(uploadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:dlBtn];
}

// 初始化View
-(void)initView
{
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    [self drawStatusView:originY];
    
    float btnBackViewHeight = Height_CommitBtnBk;
//    originY += statusBackView.bounds.size.height;
    [self drawScrollView:originY :self.view.bounds.size.height - originY - btnBackViewHeight];
    
    originY += scrollView.bounds.size.height;
    [self drawBtnBackView:originY :btnBackViewHeight];
}

// 重新加载
-(void)reloadView
{
    NSString *remark = [User shareInstance].remark;
    contentLabel.text = remark;
    if (1 == IVStatus)
    {
        return;
    }
    else if (4 == IVStatus)
    {
       // contentLabel.text = @"实名认证失败，请重新上传身份证和驾驶证照片哦~";
    }
    else
    {
        NSString *idCardNum = [User shareInstance].personId;    // 身份证号
        if ([idCardNum length] < 3) {
            return;
        }
        NSMutableString *str = [NSMutableString stringWithString:[idCardNum substringWithRange:NSMakeRange(0, 3)]];
        [str appendString:@"************"];
        [str appendString:[idCardNum substringWithRange:NSMakeRange(15, 3)]];
        idCardNumTextField.text = str;
        
        CGRect oldImageViewFrame = frontImageView.frame;
        frontImageView.frame = CGRectMake(20, oldImageViewFrame.origin.y, Width_IdCardImageView, Height_IdCardImageView);
        NSURL *personID1 = [NSURL URLWithString:[User shareInstance].personIdImage ];
        NSURL *personID2 = [NSURL URLWithString:[User shareInstance].personIdImage2];
        //[frontImageView  setImageWithURL:personID1  placeholderImage:[UIImage imageNamed:@"默认图1.png"]];
        frontImageView.image = [UIImage imageNamed:@"默认图1.png"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:personID1];
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    frontImageView.image = image;
                });
            }
        });


        
        oldImageViewFrame = backImageView.frame;
        backImageView.frame = CGRectMake(self.view.bounds.size.width - 20 - Width_IdCardImageView, oldImageViewFrame.origin.y, Width_IdCardImageView, Height_IdCardImageView);
        //[backImageView setImageWithURL:personID2 placeholderImage:[UIImage imageNamed:@"默认图1.png"]];
        backImageView.image = [UIImage imageNamed:@"默认图1.png"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:personID2];
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    backImageView.image = image;
                });
            }
        });

        
        NSURL *driverIDmage = [NSURL URLWithString:[User shareInstance].driverIdImage];
        oldImageViewFrame = dlImageView.frame;
        dlImageView.frame = CGRectMake((self.view.bounds.size.width - Width_dlImageView) / 2.0, oldImageViewFrame.origin.y, Width_dlImageView, Height_DriverId);
        
        dlImageView.image = [UIImage imageNamed:@"默认图2.png"];
        //[dlImageView setImageWithURL:driverIDmage  placeholderImage:[UIImage imageNamed:@"默认图2.png"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:driverIDmage];
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    dlImageView.image = image;
                });
            }
        });
        
        frontBtn.enabled = NO;
        backBtn.enabled = NO;
        dlBtn.enabled = NO;
        
        btnBackView.hidden = NO;
        if (2 == IVStatus)
        {
            //contentLabel.text = @"实名认证已提交，正在审核中，请您耐心等待...";
            btnBackView.hidden = YES;
        }
        else if (3 == IVStatus)
        {
            //contentLabel.text = @"实名认证成功！";
            btnBackView.hidden = YES;
        }
    }
    
    CGRect oldFrame = scrollView.frame;
    CGRect tmpRec = CGRectMake(oldFrame.origin.x, oldFrame.origin.y+statusBackView.bounds.size.height, oldFrame.size.width, oldFrame.size.height);
    if (btnBackView.hidden) {
        tmpRec.size.height += Height_CommitBtnBk;
    }
    scrollView.frame = tmpRec;
    statusBackView.hidden = NO;
}

#pragma mark - 导航栏按钮点击事件
// 调整页面
-(void)backToHomeView
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_home];
}

#pragma mark - UIImagePickerControllerDelegate
// 点击相册中的图片触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    NSData *data;
//    
//    if ([mediaType isEqualToString:@"public.image"])
//    {
//        // 切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
//        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        
//        // 图片压缩，因为原图都是很大的，不必要传原图
//        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
//        
//        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
//        if (UIImagePNGRepresentation(scaleImage) == nil)
//        {
//            //将图片转换为JPG格式的二进制数据
//            data = UIImageJPEGRepresentation(scaleImage, 1);
//        }
//        else
//        {
//            //将图片转换为PNG格式的二进制数据
//            data = UIImagePNGRepresentation(scaleImage);
//        }
//        
//        //将二进制数据生成UIImage
//        UIImage *image = [UIImage imageWithData:data];
//        
//        //将图片传递给截取界面进行截取并设置回调方法（协议）
//        CaptureViewController *captureView = [[CaptureViewController alloc] init];
//        captureView.delegate = self;    // PassImageDelegate
//        captureView.image = image;
//        
//        //隐藏UIImagePickerController本身的导航栏
//        picker.navigationBar.hidden = YES;
//        [picker pushViewController:captureView animated:YES];
//    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CGSize imageSize;
    imageSize.width = 250;
    imageSize.height = 158;
    
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    switch (tagOfBtn)
    {
        case TAG_BTN_IdCardFront:       // 上传身份证正面
        {
            if (!frontBtnClicked)
            {
                frontBtnClicked = YES;
                
                CGRect oldImageViewFrame = frontImageView.frame;
                frontImageView.frame = CGRectMake(20, oldImageViewFrame.origin.y, Width_IdCardImageView, Height_IdCardImageView);
            }

            frontImageView.image = [self scalingImageSize:imageSize sorceImgage:image];
            frontImgSelected = YES;
            
            // 身份证正面大小验证
            CGFloat width_img = frontImageView.image.size.width;
            CGFloat height_img = frontImageView.image.size.height;
           
            if (width_img > 250 || height_img > 158)
            {
                [self showAlertViewWithStr:@"您选择的照片不符合要求的大小"];
                frontImgSelected = NO;
                return;
            }
            
            // 身份证正面MB大小验证
            long frontByte = [self getMageByteByImage:frontImageView.image];
            if (frontByte >= 5.0)
            {
                [self showAlertViewWithStr:@"您选择的照片不能超过5M"];
                frontImgSelected = NO;
                return;
            }
            
        }
            break;
            
        case TAG_BTN_IdCardBack:        // 上传身份证反面
        {
            if (!backBtnClicked)
            {
                backBtnClicked = YES;
                
                CGRect oldImageViewFrame = backImageView.frame;
                backImageView.frame = CGRectMake(self.view.bounds.size.width - 20 - Width_IdCardImageView, oldImageViewFrame.origin.y, Width_IdCardImageView, Height_IdCardImageView);
            }
            backImageView.image = [self scalingImageSize:imageSize sorceImgage:image];
            backImgSelected = YES;
            
            //身份证背面大小验证
            CGFloat width_img = backImageView.image.size.width;
            CGFloat height_img = backImageView.image.size.height;
            
            if (width_img > 250 || height_img > 158) {
                [self showAlertViewWithStr:@"您选择的照片不符合要求的大小"];
                backImgSelected = NO;
                return;
            }
            
            //身份正背面MB大小验证
            long frontByte = [self getMageByteByImage:backImageView.image];
            if (frontByte > 5.0) {
                [self showAlertViewWithStr:@"您选择的照片不能超过5M"];
                backImgSelected = NO;
                return;
            }
        }
            break;
            
        case TAG_BTN_DrivingLicense:    // 上传驾驶证按钮
        {
            if (!dlBtnClicked)
            {
                dlBtnClicked = YES;
                
                CGRect oldImageViewFrame = dlImageView.frame;
                dlImageView.frame = CGRectMake((self.view.bounds.size.width - Width_dlImageView) / 2.0, oldImageViewFrame.origin.y, Width_dlImageView, Height_dlImageView);
            }
            
            imageSize.width = 500;
            imageSize.height = 158;
            dlImageView.image = [self scalingImageSize:imageSize sorceImgage:image];
            dlImgSelected = YES;
            
            //驾驶证大小验证
            CGFloat width_img = dlImageView.image.size.width;
            CGFloat height_img = dlImageView.image.size.height;
            
            if (width_img > 500 || height_img > 158) {
                [self showAlertViewWithStr:@"您选择的照片不符合要求的大小"];
                dlImgSelected = NO;
                return;
            }
            
            //身份正背面MB大小验证
            long frontByte = [self getMageByteByImage:backImageView.image];
            if (frontByte >= 5.0) {
                [self showAlertViewWithStr:@"您选择的照片不能超过5M"];
                dlImgSelected = NO;
                return;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)showAlertViewWithStr:(NSString *)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - PassImageDelegate
-(void)passImage:(UIImage *)image
{

}
#pragma mark---UIActionSheetDelegete
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *insertPicker = [[UIImagePickerController alloc] init];
                insertPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [insertPicker setDelegate:self];
                insertPicker.allowsEditing = YES;
                [self presentViewController:insertPicker animated:YES completion:^{
                }];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController *insertPicker = [[UIImagePickerController alloc] init];
            insertPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [insertPicker setDelegate:self];
            insertPicker.allowsEditing = YES;
            [self presentViewController:insertPicker animated:YES completion:^{
            }];
        }
            break;
        default:
            break;
    }

}
#pragma mark - 按钮点击事件
-(void)uploadBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    tagOfBtn = btn.tag;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [sheet showInView:self.view];
}
// 获取Image数据
- (long )getMageByteByImage:(UIImage *)img
{
    int  perMBBytes = 1024*1024;
    NSData *data =  UIImageJPEGRepresentation(img, 1.0);
    long  totalFileMB = data.length/perMBBytes;
    return totalFileMB;
}
//正则表达式验证身份证格式
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//正则表达式验证身份证格式
- (BOOL)checkIdCardNum
{
    //老身份证15位,二代身份证18位
    //^(\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$/
    //NSString *regex = @"^[0-9]{15}|[0-9]{18}$";
    NSString *regex = @"^[0-9]{15}|[0-9]{18}$|^d{17}(d|X|x))$/";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:idCardNumTextField.text];
    return isMatch;
}
// 提交实名认证
- (void)commitBtnClicked
{
    if (IVStatus == 2 || IVStatus == 3)
    {
        return;
    }
    
    NSLog(@"idCardNumTextField.text:%@",idCardNumTextField.text);
    if (!idCardNumTextField.text ||  [idCardNumTextField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您忘记输入身份证号了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //if (![self checkIdCardNum])
    if (![self validateIdentityCard:idCardNumTextField.text])
    {
        [self showAlertViewWithStr:@"您的身份证号码格式不正确"];
        return;
    }
    
    if (!frontImgSelected)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请上传您手持身份证正面的照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (!backImgSelected)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请上传您手持身份证反面的照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (!dlImgSelected)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请上传您的驾驶证照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] upLoadIdentifyCardWithPhoneNum:
        [User shareInstance].phone   idCode:idCardNumTextField.text
        pic1:frontImageView.image  pic1Type:@".jpg"
        pic2:dlImageView.image     pic2Type:@".jpg"
        pic3:backImageView.image   pic3Type:@".jpg" delegate:self];
    request = nil;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 18)
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - FMNetworkManager delegate
// 请求成功
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_RealName])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"上传成功，请耐心等待审核结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        if (enterType == IVViewFromRegisterView)
        {
            [self backToHomeView];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserInFo])
    {
        IVStatus = [[User shareInstance].status intValue];
        [self reloadView];
    }
}
// 请求失败
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_RealName])
    {
        NSString *message = [NSString stringWithFormat:@"实名认证失败了，失败原因：%@", fmNetworkRequest.responseData];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 图片裁剪函数
- (UIImage*)scalingImageSize:(CGSize)targetSize sorceImgage:(UIImage*) sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if ( CGSizeEqualToSize(imageSize, targetSize) == NO )
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // pop the context into memory
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if( newImage == nil )
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
