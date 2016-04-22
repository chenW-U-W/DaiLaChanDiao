//
//  PendingDetailViewController.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

typedef NS_ENUM(NSInteger,TagOfBtn) {
TagOfBtnChosePic = 10,
    TagOfBtnChoseReason,
    TagOfBtnChoseNoPass
};
#import "UIImageView+WebCache.h"
#import "PendingDetailViewController.h"
#import "ShowImageViewController.h"
#import "PickerInformationView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PendDetailObj.h"
#import "MBProgressHUD.h"

#define imageViewWidth 110
#define intervalWidth 10
@interface PendingDetailViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) PickerInformationView *pickInV;
@property (nonatomic,assign) BOOL canPass;
@property (nonatomic,strong) NSString *tagString;
@property (nonatomic,strong) NSMutableArray *streamsArray;
@end

@implementation PendingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageScrollview.showsHorizontalScrollIndicator = NO;
    _imageScrollview.showsVerticalScrollIndicator = NO;
    _imageScrollview.delegate = self;
    
    _pickInV = [[PickerInformationView  alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
   __block PendingDetailViewController *pendingVC_weak = self;
    _pickInV.returnBackBlo = ^(NSString *string){
        [pendingVC_weak.reasonBtn setTitle:string forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            pendingVC_weak.pickInV.hidden = YES;
            pendingVC_weak.pickInV.frame = CGRectMake(0, pendingVC_weak.view.frame.size.height, pendingVC_weak.view.frame.size.width, 200);
            
        } completion:^(BOOL finished) {
            _tagString = string;
        }];
        
    };
    
    _pickInV.hidden = YES;
    [self.view addSubview:_pickInV];
    _imageArray = [[NSMutableArray alloc] init];
    _streamsArray = [[NSMutableArray alloc] init];
    _itemId = _pendDetailObj.itemId;
    
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/images_%@",_itemId ]];
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DocumentsPath error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSLog(@"apath: %@", aPath);
        NSString * fullPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",aPath ]];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
        {
            [_imageArray addObject:fullPath];
        }
    }
    [self newUpdateScrollview];
    _tagString = @"";//错误类型
    
    _addressLabel.text = [self.pendDetailObj.area_name stringByAppendingString: [NSString stringWithFormat:@"-%@",self.pendDetailObj.address ]];
    _phoneNumberLabel.text = self.pendDetailObj.mobile_num;
    _canPass = YES;
    _reasonBtn.hidden = YES;
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitClick:(id)sender {
    
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/images_%@",_itemId ]];
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DocumentsPath error:NULL];
    if (_streamsArray.count>0) {
        [_streamsArray removeAllObjects];
    }
    for (NSString *aPath in contentOfFolder) {
        NSLog(@"apath: %@", aPath);
        NSString * fullPath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",aPath ]];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
        {
            NSData *data = [NSData dataWithContentsOfFile:fullPath];
            UIImage *image1 = [UIImage imageWithData:data];
//            NSData *data1;
//            data1 = UIImageJPEGRepresentation(image1, 0.5);
//            UIImage *image = [UIImage imageWithData:data1];
            UIImage *image = [self imageWithImageSimple:image1 scaledToSize:CGSizeMake(0.2*image1.size.width, 0.2*image1.size.height)];
            NSLog(@"%@",NSStringFromCGSize(image.size));
            UIImage *maskImage = [UIImage imageNamed:@"ymb"];
            NSLog(@"%@",NSStringFromCGSize(maskImage.size));
            UIImage *finalImage = [self addImage:image addMsakImage:[UIImage imageNamed:@"ymb"] msakRect:CGRectMake(image.size.width-maskImage.size.width,image.size.height-maskImage.size.height,maskImage.size.width,maskImage.size.height)];
            NSData *finalData = UIImageJPEGRepresentation(finalImage, 1);
            [_streamsArray addObject:finalData];
        }
        
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PendDetailObj postPendingDetailWithBlock:^(id posts, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            if (!error) {
                if (self.returnBackB) {
                    self.returnBackB(_tagString);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                ALERTVIEW;
            }
        } tag:_tagString streams:_streamsArray itemID:_itemId];
        

    });
    }

- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext (newSize);
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    
    // Get the new image from the context
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    // End the context
    
    UIGraphicsEndImageContext ();
    
    // Return the new image.
    
    return newImage;
    
}


- (IBAction)buttonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case TagOfBtnChoseNoPass:
        {
        //改变btn 起先为NO
            _canPass = !_canPass;
            if (!_canPass) {
                [_disPassBtn setBackgroundColor:mainColor];//绿色为NO 有错误
                _reasonBtn.hidden = NO;
            }
            else
            {
                [_disPassBtn setBackgroundColor:[UIColor lightGrayColor]];//红色表示无错误
                _reasonBtn.hidden = YES;
            }
        }
            break;
        case TagOfBtnChosePic:
        {
        // 调用相册
            UIActionSheet *acctionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"调用相机",@"选择相册", nil];
            acctionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [acctionSheet showInView:self.view];
            
        }
            break;
        case TagOfBtnChoseReason:
        {
        //选择原因
            _pickInV.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                _pickInV.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200);

            } completion:^(BOOL finished) {
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takeCamers];
    }else if (buttonIndex == 1) {
        //调用相册
        [self getFromLibrary];
    }
}

- (void)getFromLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)takeCamers
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        DLog(@"------");
    }

}


//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //保存照片到数组中
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        UIImage *finalImage = [self addImage:image addMsakImage:[UIImage imageNamed:@"ymb"] msakRect:CGRectMake((image.size.width-image.size.width*0.5)/2.0, (image.size.height-image.size.width*0.5)/2.0, image.size.width*0.5, image.size.width*0.5)];
//        [_imageArray addObject:finalImage];
        [_imageArray addObject:image];
       
        [self dismissViewControllerAnimated:YES completion:^{
            //更新scrollview
            [self newUpdateScrollview];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //先把图片转成NSData
                //NSData *data2 = UIImageJPEGRepresentation(image, 1);
               // NSData *data1 = UIImageJPEGRepresentation(finalImage, 1);
                
                NSData *data;
                data = UIImageJPEGRepresentation(image, 0);
                NSDate *adate= [NSDate date];
                NSString *dateStr =[ NSString stringWithFormat:@"%lf", [adate timeIntervalSince1970]];
                NSString *finalDateStr = [[@"/image_" stringByAppendingString:dateStr] stringByAppendingString:@".png"];
                //图片保存的路径
                //这里将图片放在沙盒的documents文件夹中
                NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/images_%@",_itemId ]];
                //文件管理器
                NSFileManager *fileManager = [NSFileManager defaultManager];
                //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
                [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:finalDateStr] contents:data attributes:nil];
                
                //得到选择后沙盒中图片的完整路径
                NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,finalDateStr];
                //保存到数组中展示在界面上
                [_imageArray replaceObjectAtIndex:_imageArray.count-1 withObject:filePath];
                //            //保存到相册
                //            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
                //                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                //                [assetsLibrary writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                //                    //保存后返回assetUrl；如果error等于nil，则保存成功
                //                    NSLog(@"%@",assetURL);
                //                    [_imageArray addObject:[NSString stringWithFormat:@"%@",assetURL]];
                //                }];
                    
                });
        }];

        
        
    }
    
}


- (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage msakRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(useImage.size);
    DLog(@"%@",NSStringFromCGSize(useImage.size));
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    NSLog(@"%@",NSStringFromCGSize(useImage.size));
    //四个参数为水印图片的位置
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (void)newUpdateScrollview
{
    [_imageScrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _imageScrollview.contentSize = CGSizeMake((intervalWidth+imageViewWidth)*_imageArray.count, imageViewWidth);
    for (int i = 0 ; i<_imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+i*imageViewWidth+i*intervalWidth, 0, imageViewWidth, imageViewWidth)];
        UITapGestureRecognizer *single =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signalClick:)];
        [single setNumberOfTapsRequired:1];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+200;
        imageView.autoresizingMask = 0xFF;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addGestureRecognizer:single];
        if ([[_imageArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            NSString *pathStr = [_imageArray objectAtIndex:i];
            UIImage *image = [UIImage imageWithContentsOfFile:pathStr];
            imageView.image = image;
        }
        else
        {
           imageView.image = [_imageArray objectAtIndex:i];
        }
       [_imageScrollview addSubview:imageView];
    }

}


- (void)signalClick:(UIGestureRecognizer *)gesture
{
    UIImageView *imageView =(UIImageView *) gesture.view;
    ShowImageViewController *showImageViewVC = [[ShowImageViewController alloc] init];
     [showImageViewVC creatScrollviewWithArray:_imageArray withShowingNum:imageView.tag-200 isWebString:NO haveCancleBtn:YES];
    [self presentViewController:showImageViewVC animated:YES completion:^{
        
    }];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"%@",contextInfo);
    NSString *message = @"呵呵 失败了";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
