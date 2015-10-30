//
//  RenewRecordCell.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrdersData.h"
#import "PublicFunction.h"

@interface RenewRecordCell : UITableViewCell
{
    UIButton *m_checkboxBtn;
    UILabel *m_renewTime;
    UILabel *m_renewDuration;
    UILabel *m_renewDeposit;
}

-(void)setRnewRecordCellData:(srvRenewData *)renewData;
@end
