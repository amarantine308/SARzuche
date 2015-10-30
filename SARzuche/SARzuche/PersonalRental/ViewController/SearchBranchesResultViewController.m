//
//  SearchBranchesResultViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-25.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "SearchBranchesResultViewController.h"
#import "ConstString.h"
#import "BLNetworkManager.h"
#import "LoadingClass.h"
#import "ConstDefine.h"
#import "ConstImage.h"
#import "CustomAlertView.h"

#define TABEL_START_Y               130


#define FRAME_SEARCH_RESULT_TABLE       CGRectMake(10, TABEL_START_Y, BRANCHE_TABLE_WIDTH + BLOCK_TABLE_WIDTH + 10, MainScreenHeight - TABEL_START_Y)
#define FRAME_NO_RESULT                 CGRectMake(10, 300, 300, 40)

#define FRAME_TEXTFIELD_VIEW        CGRectMake(10, 70, 250, 40)
#define FRAME_SEARCH_BUTTON         CGRectMake(259, 71, 50, 38)
#define FRAME_NO_CAR            CGRectMake(10, 260, 300, 100)

#define NUM_OF_PERPAGE          20

// img
#define IMG_SEARCH_BTN      @"icon_search.png"

@interface SearchBranchesResultViewController ()
{
    BranchesTableView *m_searchResult;
    NSMutableArray *m_searchDataArray;
    
    UITextField *m_searchFeild;
    UIButton *m_searchBtn;
    NSString *m_searchStr;
    
    NSInteger m_curPage;
    NSInteger m_pageSize;
    
    UILabel *m_noCarInfo;
}

@end

@implementation SearchBranchesResultViewController
@synthesize delegate;

-(id)initWithSearch:(NSString *)strSearch
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        m_searchStr = strSearch;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initSearchResultView];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_SELECT_BRANCHES];
    }
}

-(void)initData
{
    m_curPage = 1;
    m_pageSize = NUM_OF_PERPAGE;
}


-(void)initSearchResultView
{
    m_searchFeild = [[UITextField alloc] initWithFrame:FRAME_TEXTFIELD_VIEW];
    [m_searchFeild setBackground:[UIImage imageNamed:IMG_SEARCH]];
    m_searchFeild.text = m_searchStr;
    [self.view addSubview:m_searchFeild];
    
    m_searchBtn = [[UIButton alloc] initWithFrame:FRAME_SEARCH_BUTTON];
    [m_searchBtn addTarget:self action:@selector(searchButton) forControlEvents:UIControlEventTouchUpInside];
    m_searchBtn.backgroundColor = [UIColor whiteColor];
    [m_searchBtn setImage:[UIImage imageNamed:IMG_SEARCH_BTN] forState:UIControlStateNormal];
    [self.view addSubview:m_searchBtn];
    
    
    m_searchResult = [[BranchesTableView alloc] initWithFrame:FRAME_SEARCH_RESULT_TABLE forBlock:tableSearch];
    m_searchResult.delegate = self;
    [self.view addSubview:m_searchResult];
    
    m_noCarInfo = [[UILabel alloc] initWithFrame:FRAME_NO_CAR];
    m_noCarInfo.backgroundColor = [UIColor clearColor];
    [m_noCarInfo setText:STR_NOCAR_FORSELECTING];
    m_noCarInfo.textColor = [UIColor blackColor];
    m_noCarInfo.lineBreakMode = NSLineBreakByCharWrapping;
    m_noCarInfo.textAlignment = NSTextAlignmentCenter;
    m_noCarInfo.numberOfLines = 2;
    m_noCarInfo.hidden = YES;
    [self.view addSubview:m_noCarInfo];
    
}

/**
 *方法描述：显示未搜索到
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)showNoResult:(BOOL)bShow
{
    m_noCarInfo.hidden = !bShow;
    
    m_searchFeild.hidden = bShow;
    m_searchBtn.hidden = bShow;
    m_searchResult.hidden = bShow;

}


-(void)requestData
{
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] selectBranchByCondition:m_searchFeild.text city:nil area:nil pageNumber:m_curPage pageSize:m_pageSize delegate:self];
    
    req = nil;
}



-(void)getMoreDate:(branchesViewType)type
{
    [self requestData];
}

-(void)searchButton
{
    NSLog(@"search button");
    m_curPage = 1;
    m_pageSize = NUM_OF_PERPAGE;
    
    [self requestData];
}



-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    
    if (nil != m_searchDataArray) {
        m_searchDataArray = nil;
    }
    
    m_searchDataArray = [[NSMutableArray alloc] initWithArray:[fmNetworkRequest.responseData objectForKey:@"branches"]];
    
    m_searchResult.m_totalsItem = [[fmNetworkRequest.responseData objectForKey:@"totalNumber"] integerValue];
    if (m_searchDataArray && [m_searchDataArray count] > 0) {
        [m_searchResult searchTableData:m_searchDataArray];
    }
    else if(1 == m_curPage && [m_searchDataArray count] == 0)
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:STR_NORESULT_FORSEARCHING delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [alert needDismisShow];
    }
    
    m_curPage++;
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [m_searchDataArray removeAllObjects];
    [m_searchResult searchTableData:m_searchDataArray];
    [[LoadingClass shared] hideLoading];
}


-(void)selBlock:(NSString *)blockName
{
}

-(void)selBranche:(NSDictionary *)brancheData
{
    NSLog(@" sel branche");
    if (delegate && [delegate respondsToSelector:@selector(selectSearchBranche:)])
    {
        [self.navigationController popViewControllerAnimated:NO];
        [delegate selectSearchBranche:brancheData];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_searchFeild resignFirstResponder];
}

@end
