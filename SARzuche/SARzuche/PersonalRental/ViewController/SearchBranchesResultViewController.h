//
//  SearchBranchesResultViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-25.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "BranchesTableView.h"

@protocol SearchBranchesResultViewControllerDelegate <NSObject>

-(void)selectSearchBranche:(NSDictionary *)branche;
@end

@interface SearchBranchesResultViewController : NavController<BranchesTableViewDelegate>

@property(nonatomic, weak)id<SearchBranchesResultViewControllerDelegate> delegate;

-(id)initWithSearch:(NSString *)strSearch;
@end
