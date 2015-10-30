//
//  CaptureViewController.h
//  SARzuche
//
//  Created by admin on 14-11-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "AGSimpleImageEditorView.h"

@protocol PassImageDelegate <NSObject>
-(void)passImage:(UIImage *)image;
@end

@interface CaptureViewController : NavController
{
    AGSimpleImageEditorView *editorView;
}
@property(nonatomic, assign)id<PassImageDelegate> delegate;
@property(nonatomic, strong)UIImage *image;

@end
