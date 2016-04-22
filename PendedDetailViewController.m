//
//  PendedDetailViewController.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "PendedDetailViewController.h"
#import "PendDetailObj.h"
#import "Example2CollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShowImageViewController.h"
@interface PendedDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *imageMutableArray;
@property (nonatomic,strong)ShowImageViewController *showImageVC;
@end

@implementation PendedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _linkMan.text = _pendDetailObj.post_address;
    _linkAddress.text = _pendDetailObj.address;
    _linkNumber.text = _pendDetailObj.mobile_num;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(110, 110);
    
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height-NAVHEIGHT-20)  collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    [_contentView addSubview:_collectionView];
    
    _imageMutableArray = [[NSMutableArray alloc] init];
    
    _imageMutableArray = _pendDetailObj.pictures;
    
   

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imageMutableArray.count;
}

- (Example2CollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Example2CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : @"Example2CollectionViewCell" forIndexPath :indexPath];
    NSString *string = [_imageMutableArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:string];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ymb"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _showImageVC = [[ShowImageViewController alloc] init];
    [_showImageVC creatScrollviewWithArray:_imageMutableArray withShowingNum:indexPath.item isWebString:YES haveCancleBtn:YES];
    [self presentViewController:_showImageVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
