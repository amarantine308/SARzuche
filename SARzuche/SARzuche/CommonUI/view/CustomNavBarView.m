//
//  CustomNavBarView.m
//  MediCare
//
//  Created by admin on 14-1-2.
//  Copyright (c) 2014年 ChinaSoft. All rights reserved.
//

#import "CustomNavBarView.h"
#import "ConstDefine.h"
#import "ConstImage.h"

#define LEFT_BTN_W          kNavigationBarHeight
#define LEFT_BTN_H          kNavigationBarHeight
#define FRAME_LEFT_BTN      CGRectMake(0, 0, LEFT_BTN_W, LEFT_BTN_H)

@implementation CustomNavBarView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString*)titleStr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        self.backgroundColor = kNavBackgroundColor;
        UIImageView *imgvBkg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgvBkg.image = [UIImage imageNamed:@"nav_tab.png"];
        [self addSubview:imgvBkg];
        
        float xPos = frame.size.width / 5;
        
        titleLb = [[UILabel alloc]initWithFrame:CGRectMake(xPos, 0, frame.size.width - xPos * 2, frame.size.height)];
        titleLb.text = titleStr;
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = [UIFont boldSystemFontOfSize:19.0f];
        titleLb.textColor = [UIColor whiteColor];
        titleLb.backgroundColor = kNavBackgroundColor;

        [self addSubview:titleLb];
    }
    return self;
}


-(void)resetTitleLabelFrame
{
    CGSize sz = CGSizeMake(0, 0);
    //重设标题位置,使之居中
    if (IOS_VERSION_ABOVE_7)
    {
        if ([titleLb.text length] > 0) {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:titleLb.text];
            NSRange range = NSMakeRange(0, attrStr.length);
            NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
            CGRect rec = [titleLb.text boundingRectWithSize:CGSizeMake(self.frame.size.width,self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];
            sz = CGSizeMake(rec.size.width, rec.size.height);
#endif
        }
    }
    else
    {
        sz = [titleLb.text sizeWithFont:titleLb.font constrainedToSize:CGSizeMake(self.frame.size.width,self.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    }
    // boundingRectWithSize: Opthons: attributes: context:
    float xPos = (self.frame.size.width - sz.width) / 2;
    float width = sz.width;
    UIButton *leftBtn = (UIButton*)[self viewWithTag:100];
    UIButton *rightBtn = (UIButton*)[self viewWithTag:101];
    if (leftBtn)
    {
        //有左按钮
        float leftBtnRight = CGRectGetMaxX(leftBtn.frame);
        if (xPos < leftBtnRight)
        {
            //标题较长
            xPos = leftBtnRight;
            if (rightBtn)
            {
                //有右侧按钮
                width = self.frame.size.width - leftBtnRight - rightBtn.frame.size.width;
            }
            else
            {
                //没有右侧按钮
                width = self.frame.size.width - leftBtnRight;
            }
        }
    }
    else if(!leftBtn && !rightBtn)
    {
        //左右都没按钮
        xPos = 0;
        width = self.frame.size.width;
    }
    
    if (0 == width) {
        return;
    }
    titleLb.frame = CGRectMake(xPos, titleLb.frame.origin.y, width, titleLb.frame.size.height);
}


-(void)adjustBtnFrame:(UIButton *)btn withImg:(UIImage *)image
{
    NSInteger imgW = image.size.width;
    NSInteger imgH = image.size.height;
    NSInteger x = 0;
    NSInteger y = 0;

    if (LEFT_BTN_W > imgW)
    {
        x = (LEFT_BTN_W - imgW)/2;
    }
    else
    {
        imgW = LEFT_BTN_W;
    }
    if (LEFT_BTN_H > imgH) {
        y = (LEFT_BTN_H - imgH)/2;
    }
    else
    {
        imgH = LEFT_BTN_H;
    }
    
//    btn.imageView.frame = CGRectMake(x, y, imgW, imgH);
    btn.frame = CGRectMake(x, y, imgW, imgH);
}


-(void)setLeftButton:(NSString *)ltImgName target:(id)target leftBtnAction:(SEL)lAction
{
    if(ltImgName && [ltImgName length] > 0)
    {
        UIButton *leftBtn = (UIButton*)[self viewWithTag:100];
        UIImage *img = [UIImage imageNamed:ltImgName];
        
        if(img)
        {
            if(leftBtn)
            {
                [leftBtn setImage:img forState:UIControlStateNormal];
                [self adjustBtnFrame:leftBtn withImg:img];
                [leftBtn addTarget:target action:lAction forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:img forState:UIControlStateNormal];
                [self adjustBtnFrame:btn withImg:img];
                btn.contentMode = UIViewContentModeScaleToFill;
                btn.backgroundColor = [UIColor clearColor];
                [btn addTarget:target action:lAction forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                btn.tag = 100;
            }
        }
        
//        [self resetTitleLabelFrame];
    }
}

-(void)setRightButton:(NSString *)rtImgName target:(id)target rightBtnAction:(SEL)rAction
{
    if(rtImgName && [rtImgName length] > 0)
    {
        UIButton *rightBtn = (UIButton*)[self viewWithTag:101];
        UIImage *img = [UIImage imageNamed:rtImgName];
        if(img)
        {
            if(rightBtn)
            {
                [rightBtn setImage:img forState:UIControlStateNormal];
                [rightBtn addTarget:target action:rAction forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(self.frame.size.width - img.size.width, 0, img.size.width, img.size.height-2);
                [btn setImage:img forState:UIControlStateNormal];
                btn.contentMode = UIViewContentModeScaleToFill;
                btn.backgroundColor = [UIColor clearColor];
                [btn addTarget:target action:rAction forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                btn.tag = 101;
            }
        }
        
//        [self resetTitleLabelFrame];
    }
}



-(void)setLeftButtonWithTitle:(NSString *)title target:(id)target leftBtnAction:(SEL)lAction
{
    if(!title || [title length] == 0)
    {
        return;
    }
    
    UIButton *leftBtn = (UIButton*)[self viewWithTag:100];
    if(leftBtn)
    {
        [leftBtn setTitle:title forState:UIControlStateNormal];
        [leftBtn addTarget:target action:lAction forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 6, 50, 32);
        [btn setTitle:title forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleToFill;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UIImage *img = [UIImage imageNamed:@"cancel.png"];
        UIImage *imgTemp = [img stretchableImageWithLeftCapWidth:15.f topCapHeight:15.f];
        [btn setBackgroundImage:imgTemp forState:UIControlStateNormal];
        [btn addTarget:target action:lAction forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = 100;
    }
}

-(void)setRightButtonWithTitle:(NSString *)title target:(id)target rightBtnAction:(SEL)rAction
{
    if(!title || [title length] == 0)
    {
        return;
    }
    
    UIButton *rightBtn = (UIButton*)[self viewWithTag:101];
    if(rightBtn)
    {
        rightBtn.hidden = NO;
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn addTarget:target action:rAction forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width - 60, 6, 50, 32);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleToFill;
        //btn.backgroundColor = [UIColor yellowColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UIImage *img = [UIImage imageNamed:@"cancel.png"];
        UIImage *imgTemp = [img stretchableImageWithLeftCapWidth:15.f topCapHeight:15.f];
        [btn setBackgroundImage:imgTemp forState:UIControlStateNormal];
        [btn addTarget:target action:rAction forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.tag = 101;
    }
}

-(void)setRightButtonFrame:(CGRect)frame
{
    UIButton *rightBtn = (UIButton*)[self viewWithTag:101];
    rightBtn.frame = frame;
}

-(void)setTitleBackImg:(NSString *)img
{
    if (img)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LOGO]];
        NSInteger x = (titleLb.frame.size.width - imgView.frame.size.width) / 2;
        NSInteger y = (titleLb.frame.size.height - imgView.frame.size.height) / 2;
//        if (titleLb.frame.size.height > 36)
        {
//            y = (titleLb.frame.size.height - 36)/2;
        }
        imgView.frame = CGRectMake(x, y, imgView.frame.size.width, imgView.frame.size.height);
        [titleLb addSubview:imgView];
    }
}

-(void)setTitle:(NSString *)title
{
    if(!titleLb)
    {
        return;
    }
    if(!title)
    {
        title = @"";
    }
    titleLb.text = title;
}

-(void)hideRightButton
{
    UIButton *rightBtn = (UIButton*)[self viewWithTag:101];
    if(rightBtn)
    {
        rightBtn.hidden = YES;
    }

}


-(void)btnClk:(id)sender
{
    NSLog(@"left btn click!!!!! ");
    
    if([sender isKindOfClass:[UIButton class]])
    {
        if([_delegate respondsToSelector:@selector(customNavBarView:didClickButtonOfType:)])
        {
            [_delegate customNavBarView:self didClickButtonOfType:((UIButton*)sender).tag];
        }
    }
    
}


@end
