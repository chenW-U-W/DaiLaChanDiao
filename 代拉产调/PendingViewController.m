//
//  PendingViewController.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "PendingViewController.h"
#import "MJRefresh.h"
#import "PullingListTableViewCell.h"
#import "ContentListTableViewCell.h"
#import "PendingObj.h"
#import "LoginViewController.h"
#import "PendingContentTableViewCell.h"
#import "PendingDetailViewController.h"
#import "PendedDetailViewController.h"
#import "User.h"
#import "LoginViewController.h"
typedef NS_ENUM(NSInteger,TagType) {
    TagTypePullListTag = 10 ,
    TagTypePendingTag,
    TagTypePendedTag
};

#define pullingListTableViewHeight  self.view.frame.size.height-_chosedAreaBtn.frame.origin.y-_chosedAreaBtn.frame.size.height-1
#define pullingListTableViewHeightZero 0
#define pullingListTableViewOriginY  _chosedAreaBtn.frame.size.height+_chosedAreaBtn.frame.origin.y+1
#define pullingListIntervel 0.35
@interface PendingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *pullListTableView;
@property (nonatomic,assign) BOOL isHiden;
@property (nonatomic,strong) PullingListTableViewCell *previousChosedCell;
@property (nonatomic,assign) NSInteger selectedNumber;
@property (nonatomic,strong) NSArray *pullListContentArray;

//待处理订单
@property (nonatomic,strong) UITableView *pendingContentTableView;
@property (nonatomic,strong) NSMutableArray *pendingContentArray;
@property (nonatomic,assign) NSInteger currentTag;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger areaId;

//已处理订单
@property (nonatomic,strong) UITableView *pendedContentTableView;
@property (nonatomic,strong) NSMutableArray *pendedContentArray;
@property (nonatomic,assign) BOOL isFirstAppear;
@property (nonatomic,assign) TagType tagType;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) NSInteger pendedNumber;
@property (nonatomic,assign) BOOL isUpPull;
@property (nonatomic,strong) LoginViewController  *loginVC ;
@end

@implementation PendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    _setmentControl.tintColor = mainColor;
    _loginVC  = [[LoginViewController alloc] init];
    __block PendingViewController *weakPendingVC = self;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoneNumber"]) {
        [self.navigationController pushViewController:self.loginVC animated:NO];
       _loginVC.successLB = ^{
            [weakPendingVC operateClass];
        };
        
    }
    else
    {
        // Do any additional setup after loading the view from its nib.
        [self operateClass];
    }
   
   
//默认为待处理
    _currentTag = 0;
    _pageSize = 0;
    _isFirstAppear = YES;
    _areaId = 0;
    _number = 1;//默认为1 没有0；
    _selectedNumber = 0;
    
    
    self.navigationItem.leftBarButtonItem = nil;
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    //leftButton.backgroundColor = [UIColor redColor];
    [rightBtn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightBtn setTitle:@"退出"  forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
}
-(void)loginOut:(UIButton *)btn
{
    [User signOut ];
    [self.navigationController pushViewController:_loginVC animated:NO];
    

}

- (void)operateClass
    {
        [self setUI];
        
        self.pendingContentTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _isUpPull = NO;
            _number = 1;
            [self startLoadDataWithNumber:_number];
        }];
        self.pendedContentTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _isUpPull = NO;
            _pendedNumber = 1;
            
            [self startLoadDataWithNumber:_pendedNumber];
        }];
        self.pendingContentTableView.tableFooterView = [[UIView alloc] init];
        self.pendingContentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _isUpPull = YES;
            _number++;
            [self startLoadDataWithNumber:_number];
        }];
        self.pendedContentTableView.tableFooterView = [[UIView alloc] init];
        self.pendedContentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _isUpPull = YES;
            _pendedNumber++;
            // 进入刷新状态后会自动调用这个block
            [self startLoadDataWithNumber:_pendedNumber];
        }];
        
        [self.pendingContentTableView.header beginRefreshing];
        self.navigationController.navigationBarHidden = NO;
    }

- (void)setUI
{
    //更改navigationItem的title
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"real_name"])
    {
        NSString *realname = [[NSUserDefaults standardUserDefaults] objectForKey:@"real_name"];
         self.navigationItem.title =[ NSString stringWithFormat:@"%@,欢迎您！",realname];
    }
   
    
    _setmentControl.frame = CGRectMake(0, 0, 262, 35);
    _setmentControl.center = CGPointMake(_headerView.frame.size.width/2.0, 18);
    
   
    
    
    _selectedNumber = 0;
    
    _pullListContentArray = @[@"全部区域",@"崇明县",@"奉贤区",@"金山区",@"青浦区",@"宝山区",@"嘉定区",@"松江区",@"黄浦区",@"虹口区",@"静安区",@"普陀区",@"杨浦区",@"浦东新区",@"徐汇区",@"闵行区",@"闸北区",@"长宁区"];
    
    
    //----未处理内容列表-----//
    _pendingContentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, pullingListTableViewOriginY, [UIScreen mainScreen].bounds.size.width,self.view.frame.size.height-pullingListTableViewOriginY) style:UITableViewStylePlain];
    _pendingContentTableView.tag = TagTypePendingTag;
    _pendingContentTableView.delegate = self;
    _pendingContentTableView.dataSource = self;
    [self.view addSubview:_pendingContentTableView];
    
    // ----下拉内容列表---//
    _pullListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, pullingListTableViewOriginY, [UIScreen mainScreen].bounds.size.width,0) style:UITableViewStylePlain];
    _pullListTableView.tag = TagTypePullListTag;
    _pullListTableView.delegate = self;
    _pullListTableView.dataSource = self;
    [self.view addSubview:_pullListTableView];
    
    //-------已处理内容列表------//
    _pendedContentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height+_headerView.frame.origin.y, [UIScreen mainScreen].bounds.size.width,self.view.frame.size.height-_headerView.frame.size.height-_headerView.frame.origin.y-20) style:UITableViewStylePlain];
    _pendedContentTableView.tag = TagTypePendedTag;
    _pendedContentTableView.delegate = self;
    _pendedContentTableView.dataSource = self;

}

- (void)startLoadDataWithNumber:(NSInteger)anumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *statusString;
        if (_currentTag == 0) {
            statusString = @"0";
        }
        else
        {
            statusString = @"1,2";
        }
        [PendingObj getPendingListWithBlock:^(id posts, NSError *error, NSString *tag) {
            if (_isUpPull) {//----------------上提加载
                [self.pendedContentTableView.footer endRefreshing];
                [self.pendingContentTableView.footer endRefreshing];
                if (error) {
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alerView show];
                }
                if ([tag integerValue] == 0) {//待处理完成
                    if (!error) {
                        
                        [_pendingContentArray addObjectsFromArray:posts];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_pendingContentTableView reloadData];
                        });
                    }
                    
                    
                }else if ([tag integerValue] == 1)
                {//已处理
                    if (!error) {
                       
                        [_pendedContentArray addObjectsFromArray:posts];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_pendedContentTableView reloadData];
                        });
                    }
                    
                }
                
            }
            
            else//---------------下拉刷新
            {
             [self.pendedContentTableView.header endRefreshing];
             [self.pendingContentTableView.header endRefreshing];
            if (error) {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alerView show];
            }
            if ([tag integerValue] == 0) {//待处理完成
                if (!error) {
                   
                    _pendingContentArray = posts;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_pendingContentTableView reloadData];
                    });
                }
                
                
            }else if ([tag integerValue] == 1)
            {//已处理
                if (!error) {
                   
                    _pendedContentArray = posts;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_pendedContentTableView reloadData];
                    });
                }
                
            }
        }
        } ButTag:[NSString stringWithFormat:@"%ld",_currentTag] Status:statusString Numbers:[NSString stringWithFormat:@"%ld",anumber] Size:@"5" withAreaID:[NSString stringWithFormat:@"%ld",_areaId]];//[NSString stringWithFormat:@"%ld",_pageSize]
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TagTypePullListTag ) {
        return _pullListContentArray.count;
    }
    else if (tableView.tag == TagTypePendingTag)
    {
    return _pendingContentArray.count;
    }
    return _pendedContentArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TagTypePullListTag) {
        static NSString *ID = @"identitifer";
        PullingListTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell= [[[NSBundle  mainBundle] loadNibNamed:@"PullingListTableViewCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleNameLabel.text = [_pullListContentArray objectAtIndex:indexPath.row];
        if (indexPath.row == _selectedNumber) {
            cell.cellImageView.image = [UIImage imageNamed:@"drop_down_checked"];
            _previousChosedCell = cell;
        }
        else
        {
        cell.cellImageView.image = [UIImage imageNamed:@""];
        }
        return cell;
    }
    else if (tableView.tag == TagTypePendedTag)//已处理
    {
    static NSString *Identifer= @"Cell";
    ContentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifer];
    if (!cell) {
        cell= [[[NSBundle  mainBundle] loadNibNamed:@"ContentListTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.pendDetailObj =[_pendedContentArray objectAtIndex:indexPath.row] ;
    return cell;
    }
    //未处理
    static NSString *Identifer= @"pendingCell";
    PendingContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifer];
    if (!cell) {
        cell= [[[NSBundle  mainBundle] loadNibNamed:@"PendingContentTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   cell.pendDetailObj =[_pendingContentArray objectAtIndex:indexPath.row] ;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 11 || tableView.tag == 12) {
        return 54;
    }
    return 44;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)segmentClick:(id)sender {
    UISegmentedControl *segMent = (UISegmentedControl *)sender;
    if (_currentTag == segMent.selectedSegmentIndex) {
        
    }else
    {
        _currentTag = segMent.selectedSegmentIndex;
        if (_currentTag == 0) {
            //-- 点击切换到未处理
            [_pendedContentTableView removeFromSuperview];
            [self.view addSubview:_pendingContentTableView];
            [self.view addSubview:_pullListTableView];
            [self.view addSubview:_chosedAreaBtn];
//            _pendedContentTableView.hidden = YES;
//            _pendingContentTableView.hidden = NO;
//            _pullListTableView.hidden = NO;
//            _chosedAreaBtn.hidden = NO;
        }
        else if (_currentTag == 1)
        {
        //点击切换到已处理
            [_pendingContentTableView removeFromSuperview];
            [_pullListTableView  removeFromSuperview];
            [_chosedAreaBtn removeFromSuperview];
//            _chosedAreaBtn.hidden = YES;
//            _pendedContentTableView.hidden = NO;
//            _pendingContentTableView.hidden = YES;
//            _pullListTableView.hidden = YES;
            [self.view addSubview:_pendedContentTableView];
            if (_isFirstAppear) {
                _isFirstAppear = NO;
                _currentTag = 1;
                _number = 1;
                [self.pendedContentTableView.header beginRefreshing];
            }
        }
    }
    
}

- (IBAction)areaClick:(id)sender {
    _isHiden = !_isHiden;
    if (_isHiden) {
        //显示下拉列表
        [UIView animateWithDuration:pullingListIntervel animations:^{
            _pullListTableView.frame = CGRectMake(0, pullingListTableViewOriginY, [UIScreen mainScreen].bounds.size.width,pullingListTableViewHeight);
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [UIView animateWithDuration:pullingListIntervel animations:^{
            _pullListTableView.frame = CGRectMake(0, pullingListTableViewOriginY, [UIScreen mainScreen].bounds.size.width,pullingListTableViewHeightZero);
        } completion:^(BOOL finished) {
            
        }];
    }
    [_pullListTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TagTypePullListTag) {
        PullingListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.cellImageView.image = [UIImage imageNamed:@"drop_down_checked"];        
        _selectedNumber = indexPath.row;
        NSString *chosedString = [_pullListContentArray objectAtIndex:_selectedNumber];
        _areaId = [self chosedAreaIDWithString:chosedString];
        _isHiden = NO;
        _previousChosedCell.cellImageView.image = [UIImage imageNamed:@""];
        _previousChosedCell = cell;
        [UIView animateWithDuration:pullingListIntervel animations:^{
            _pullListTableView.frame = CGRectMake(0, pullingListTableViewOriginY, [UIScreen mainScreen].bounds.size.width,pullingListTableViewHeightZero);
            
        } completion:^(BOOL finished) {
            [_chosedAreaBtn setTitle:chosedString forState:UIControlStateNormal];
            //刷新表
            //[self startLoadData];
           [self.pendingContentTableView.header beginRefreshing];
        }];

    }
    else if(tableView.tag == TagTypePendingTag)//待处理
    {
        PendingDetailViewController *pendingDetailVC = [[PendingDetailViewController alloc] init];
        pendingDetailVC.pendDetailObj = [self.pendingContentArray objectAtIndex:indexPath.row];
        PendingViewController *weakPendingVC = self;
        pendingDetailVC.returnBackB = ^ (NSString *str){
            [weakPendingVC.pendingContentTableView.header beginRefreshing];
        };
        pendingDetailVC.title = pendingDetailVC.pendDetailObj.address;
        [self.navigationController pushViewController:pendingDetailVC animated:YES  ];
    }
    else
    {
         PendedDetailViewController *pendedDetailVC = [[PendedDetailViewController alloc] init];
         pendedDetailVC.pendDetailObj = [self.pendedContentArray objectAtIndex:indexPath.row];
        pendedDetailVC.title = pendedDetailVC.pendDetailObj.address;
         [self.navigationController pushViewController:pendedDetailVC animated:YES  ];
    }
    
}



- (NSInteger)chosedAreaIDWithString:(NSString *)astring
{
    if([astring isEqualToString:@"崇明县"]){
        return 2721;
    }else if([astring isEqualToString:@"奉贤区"]){
        return 2720;
    }else if([astring isEqualToString:@"金山区"]){
        return 2719;
    }else if([astring isEqualToString:@"青浦区"]){
        return 2718;
    }else if([astring isEqualToString:@"宝山区"]){
        return 2717;
    }else if([astring isEqualToString:@"嘉定区"]){
        return 2716;
    }else if([astring isEqualToString:@"松江区"]){
        return 2715;
    }else if([astring isEqualToString:@"黄浦区"]){
        return 2713;
    }else if([astring isEqualToString:@"虹口区"]){
        return 2712;
    }else if([astring isEqualToString:@"静安区"]){
        return 2710;
    }else if([astring isEqualToString:@"普陀区"]){
        return 2709;
    }else if([astring isEqualToString:@"杨浦区"]){
        return 2708;
    }else if([astring isEqualToString:@"浦东新区"]){
        return 2707;
    }else if([astring isEqualToString:@"徐汇区"]){
        return 2706;
    }else if([astring isEqualToString:@"闵行区"]){
        return 2705;
    }else if([astring isEqualToString:@"闸北区"]){
        return 2704;
    }else if([astring isEqualToString:@"长宁区"]){
        return 2703;
    }else{
        return 0;
    }

}

@end
