//
//  NewVersionPromptView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-27.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewVersionPromptView : UIView
{
    UILabel *m_version;
    UILabel *m_size;
    UITextView *m_textView;
    
    NSString *m_strVersion;
}

-(void)setNewVersionValue:(NSString *)ver size:(NSString *)size content:(NSString *)strContent;
-(void) show;
@end
