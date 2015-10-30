//
//  ApplyInvoiceViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-20.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "OrderManager.h"
@interface ApplyInvoiceViewController : NavController<UITextFieldDelegate>
//srvOrderData *m_orderData;
{
    srvOrderData *m_orderData;
}

@property (nonatomic , retain) srvOrderData *m_orderData;
@end
