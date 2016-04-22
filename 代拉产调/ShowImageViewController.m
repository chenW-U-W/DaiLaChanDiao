//
//  ShowImageViewController.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/10.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "ShowImageViewController.h"

#import "UIImageView+WebCache.h"
@interface ShowImageViewController ()<UIScrollViewDelegate>
@property(nonatomic,assign)NSInteger currentNum;
@property(nonatomic,assign)NSInteger offset;
@property(nonatomic,assign)NSInteger scale_;

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    _offset = 0.0;
    _scale_ = 1.0;
}

- (void)cancelShowImage
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)creatScrollviewWithArray:(NSArray *)imageAray  withShowingNum:(NSInteger)showingNum isWebString:(BOOL)isWebString haveCancleBtn:(BOOL)canHaveCancleBtn
{
   
    
    NSInteger num = imageAray.count;
    CGRect frame = [UIScreen mainScreen].bounds;
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    //self.scrollView.autoresizingMask = 0xFF;
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(num*CGRectGetWidth(frame), CGRectGetHeight(frame));
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    
    NSInteger counter = 0;
    for (NSObject *obj in imageAray) {
        UIImageView*  contentView = [[UIImageView alloc] init];
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *objString = (NSString *)obj;
            
            if (isWebString) {
                NSURL *urlObj = [NSURL URLWithString:objString];
                [contentView sd_setImageWithURL:urlObj placeholderImage:[UIImage imageNamed:@"占位图.jpeg"]];
            }
            else
            {
               contentView.image = [UIImage imageWithContentsOfFile:objString];
            }
        }
        else
        {
            UIImage *contentImage = (UIImage *)obj;
            contentView.image = contentImage;
        }
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        
        
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(0+counter*frame.size.width, 0, frame.size.width, frame.size.height)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = [UIScreen mainScreen].bounds.size;
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = counter+100;
        [s setZoomScale:1.0];
        s.backgroundColor = [UIColor blackColor];
        [self.scrollView  addSubview:s];
        
        
        contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        NSLog(@"%@",NSStringFromCGSize(contentView.frame.size));
        contentView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        contentView.autoresizingMask = 0xFF;
        contentView.clipsToBounds = YES;
        contentView.contentMode = UIViewContentModeScaleAspectFit;
        contentView.userInteractionEnabled = YES;
        [contentView addGestureRecognizer:doubleTap];
        [s addSubview:contentView];
        counter++;

    }
    
    self.scrollView.contentOffset = CGPointMake(showingNum * frame.size.width, 0);
   

    if (canHaveCancleBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(frame.size.width-80, 20, 80, 40);
        [_cancelBtn addTarget:self action:@selector(cancelShowImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelBtn];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *imageView in scrollView.subviews){

        return imageView;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==_offset){
            
        }
        else {
            _offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                }
            }
        }
    }
}


- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView *)imageScrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}
@end
