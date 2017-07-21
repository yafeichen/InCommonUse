//
//  ExplainVideoVC.m
//  InCommonUse
//
//  Created by 陈亚飞 on 2017/7/10.
//  Copyright © 2017年 道说01. All rights reserved.
//

#import "ExplainVideoVC.h"
#import "HandlerVideo.h"


@interface ExplainVideoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray               *imgArr;
@property (nonatomic, strong) UITableView                  *imgTableView;
@property (nonatomic, strong) UIImageView                  *videoImg;

@end

@implementation ExplainVideoVC

-(NSMutableArray *)imgArr
{
    if (!_imgArr)
    {
        _imgArr = [NSMutableArray new];
    }
    return _imgArr;
}

-(UIImageView *)videoImg
{
    if (!_videoImg)
    {
        _videoImg = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_videoImg];
    }
    return _videoImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *chooseVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:chooseVideo];
    chooseVideo.frame = CGRectMake(0, 0, 50, 50);
    chooseVideo.center = CGPointMake(self.view.center.x, 89);
    chooseVideo.backgroundColor = [UIColor greenColor];
    [chooseVideo addTarget:self action:@selector(chooseVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height-114) style:UITableViewStylePlain];
    self.imgTableView.delegate = self;
    self.imgTableView.dataSource = self;
    [self.view addSubview:self.imgTableView];
}

-(void)chooseVideoMethod:(UIButton *)sender
{
    //            从相册中寻找视频资源
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    [[HandlerVideo sharedInstance] splitVideo:mediaUrl fps:30 splitCompleteBlock:^(BOOL success, NSMutableArray *splitimgs) {
        if (success && splitimgs.count != 0) {
            NSLog(@"----->> success");
            NSLog(@"---> splitimgs个数:%lu",(unsigned long)splitimgs.count);
            weakSelf.imgArr = splitimgs;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imgTableView reloadData];
            });
            UIImage *img = [splitimgs firstObject];
            CGSize size = CGSizeMake(CGImageGetWidth(img.CGImage), CGImageGetHeight(img.CGImage));
            NSLog(@"%f",size.width);
            NSLog(@"%f",size.height);
            UIImage *img2 = [weakSelf OriginImage:img scaleToSize:CGSizeMake(100, 1000)];
            NSLog(@"%f,%f",img2.size.height,img2.size.width);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];//照片选择器模态消失
}


/**
 图片的人脸识别

 @param image 图片资源
 */
-(void)beginDetectorFacewithImage:(UIImage *)image
{
//    CIImage *ciimage = [CIImage imageWithCGImage:image.CGImage];
//    //缩小图片，默认照片的图片像素很高，需要将图片的大小缩小为我们现实的ImageView的大小，否则会出现识别五官过大的情况
//    float factor = self.videoImg.bounds.size.width/image.size.width;
//    ciimage = [ciimage imageByApplyingTransform:CGAffineTransformMakeScale(factor, factor)];
//    
//    //2.设置人脸识别精度
//    NSDictionary* opts = [NSDictionary dictionaryWithObject:
//                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
//    //3.创建人脸探测器
//    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                                              context:nil options:opts];
//    //4.获取人脸识别数据
//    NSArray* features = [detector featuresInImage:ciimage];
//    //5.分析人脸识别数据
//    for (CIFaceFeature *faceFeature in features){
//        
//        //注意坐标的换算，CIFaceFeature计算出来的坐标的坐标系的Y轴与iOS的Y轴是相反的,需要自行处理
//        
//        // 标出脸部
//        CGFloat faceWidth = faceFeature.bounds.size.width;
//        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
//        faceView.frame = CGRectMake(faceView.frame.origin.x, self.videoImg.bounds.size.height-faceView.frame.origin.y - faceView.bounds.size.height, faceView.frame.size.width, faceView.frame.size.height);
//        faceView.layer.borderWidth = 1;
//        faceView.layer.borderColor = [[UIColor redColor] CGColor];
//        [self.videoImg addSubview:faceView];
//        // 标出左眼
//        if(faceFeature.hasLeftEyePosition) {
//            UIView* leftEyeView = [[UIView alloc] initWithFrame:
//                                   CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15,
//                                              self.videoImg.bounds.size.height-(faceFeature.leftEyePosition.y-faceWidth*0.15)-faceWidth*0.3, faceWidth*0.3, faceWidth*0.3)];
//            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            //            [leftEyeView setCenter:faceFeature.leftEyePosition];
//            leftEyeView.layer.cornerRadius = faceWidth*0.15;
//            [self.videoImg  addSubview:leftEyeView];
//        }
//        // 标出右眼
//        if(faceFeature.hasRightEyePosition) {
//            UIView* leftEye = [[UIView alloc] initWithFrame:
//                               CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15,
//                                          self.videoImg.bounds.size.height-(faceFeature.rightEyePosition.y-faceWidth*0.15)-faceWidth*0.3, faceWidth*0.3, faceWidth*0.3)];
//            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            leftEye.layer.cornerRadius = faceWidth*0.15;
//            [self.videoImg  addSubview:leftEye];
//        }
//        // 标出嘴部
//        if(faceFeature.hasMouthPosition) {
//            UIView* mouth = [[UIView alloc] initWithFrame:
//                             CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2,
//                                        self.videoImg.bounds.size.height-(faceFeature.mouthPosition.y-faceWidth*0.2)-faceWidth*0.4, faceWidth*0.4, faceWidth*0.4)];
//            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
//            
//            mouth.layer.cornerRadius = faceWidth*0.2;
//            [self.videoImg  addSubview:mouth];
//        }
//        
//    }
    
    for (UIView *view in self.videoImg.subviews) {
        [view removeFromSuperview];
    }
    // 图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择，因为想让准确度高一些在这里选择CIDetectorAccuracyHigh
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 将图像转换为CIImage
    CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    // 得到图片的尺寸
    CGSize inputImageSize = [faceImage extent].size;
    //将image沿y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    // 取出所有人脸
    for (CIFaceFeature *faceFeature in features){
        //获取人脸的frame
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        CGSize viewSize = self.videoImg.bounds.size;
        CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                            viewSize.height / inputImageSize.height);
        CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
        CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
        // 缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        // 修正
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        
        //描绘人脸区域
        UIView* faceView = [[UIView alloc] initWithFrame:faceViewBounds];
        faceView.layer.borderWidth = 2;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.videoImg addSubview:faceView];
        
        // 判断是否有左眼位置
        if(faceFeature.hasLeftEyePosition){}
        // 判断是否有右眼位置
        if(faceFeature.hasRightEyePosition){}
        // 判断是否有嘴位置
        if(faceFeature.hasMouthPosition){}
    }

}


-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imgArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"imgCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.image = [self.imgArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIImage *img = [UIImage imageNamed:@"timg.jpeg"];
    UIImage *img = [self.imgArr objectAtIndex:indexPath.row];
    self.videoImg.image = img;
    [self beginDetectorFacewithImage:img];
}
@end
