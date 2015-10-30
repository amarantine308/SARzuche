//
//  BranchesTableCell.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, branchesViewType)
{
    tableBlock,
    tableBranches,
    tableSearch,
};

@interface BranchesStruct : NSObject
{
    NSString *m_address;
    NSString *m_id;
    NSString *m_latitude;
    NSString *m_longitude;
    NSString *m_name;
}

@property(nonatomic, strong)NSString *m_address;
@property(nonatomic, strong)NSString *m_id;
@property(nonatomic, strong)NSString *m_latitude;
@property(nonatomic, strong)NSString *m_longitude;
@property(nonatomic, strong)NSString *m_name;

@end



#define BLOCK_TABLE_WIDTH       100
#define BRANCHE_TABLE_WIDTH     200
#define BRANCHE_SEARCH_WIDTH    300

@interface BranchesTableCell : UITableViewCell
{
    UILabel *m_branchesName;
    UILabel *m_branchesAddress;
    UILabel *m_distance;
    
    UILabel *m_blockName;
    UIImageView *m_line;
    branchesViewType m_isBlock;
}

@property(nonatomic, strong)UILabel *m_branchesName;
@property(nonatomic, strong)UILabel *m_branchesAddress;
@property(nonatomic, strong)UILabel *m_distance;

-(void)setCellForBlock:(branchesViewType)type;
-(void)setBlockName:(NSString *)name;
-(void)setBrancheName:(NSString *)name;
-(void)setBrancheAddress:(NSString *)address;
-(void)setDistance:(NSString *)distance;
@end
