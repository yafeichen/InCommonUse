//
//  VideoAddWatermark.m
//  InCommonUse
//
//  Created by 道说01 on 16/11/16.
//  Copyright © 2016年 道说01. All rights reserved.
//

#import "VideoAddWatermark.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
@interface VideoAddWatermark ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation VideoAddWatermark

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 50, 50);
    [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnCLick:(UIButton *)sender
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
    NSLog(@"%@",info);
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@",mediaUrl);
    //    NSString  *mediaValue = [info objectForKey:UIImagePickerControllerMediaMetadata];
    //   获取视频的thumbnail
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:mediaUrl ];
//    UIImage *img = [player thumbnailImageAtTime:4.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [self MixVideoWithText:mediaUrl];
    [self dismissViewControllerAnimated:YES completion:nil];//照片选择器模态消失
}
-(void)MixVideoWithText:(NSURL *)url
{
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //If you need audio as well add the Asset Track for audio here
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipVideoTrack atTime:kCMTimeZero error:nil];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    CGSize sizeOfVideo=[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
    
    //TextLayer defines the text they want to add in Video
    //Text of watermark
    CATextLayer *textOfvideo=[[CATextLayer alloc] init];
    textOfvideo.string=[NSString stringWithFormat:@"%@",@"道说"];//text is shows the text that you want add in video.
    [textOfvideo setFont:(__bridge CFTypeRef)([UIFont fontWithName:[NSString stringWithFormat:@"%@",@"道说"] size:13])];//fontUsed is the name of font
    [textOfvideo setFrame:CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height/6)];
    [textOfvideo setAlignmentMode:kCAAlignmentCenter];
    [textOfvideo setForegroundColor:[[UIColor yellowColor] CGColor]];
    
    //Image of watermark
    UIImage *myImage=[UIImage imageNamed:@"已赞@2x.png"];
    CALayer *layerCa = [CALayer layer];
    layerCa.contents = (id)myImage.CGImage;
    layerCa.frame = CGRectMake(50, 50, 50, 50);
    layerCa.opacity = 1.0;
    
    CALayer *optionalLayer=[CALayer layer];
    [optionalLayer addSublayer:textOfvideo];
    optionalLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [optionalLayer setMasksToBounds:YES];
    
    CALayer *parentLayer=[CALayer layer];
    CALayer *videoLayer=[CALayer layer];
    parentLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    videoLayer.frame=CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:optionalLayer];
    [parentLayer addSublayer:layerCa];
    
    AVMutableVideoComposition *videoComposition=[AVMutableVideoComposition videoComposition] ;
    videoComposition.frameDuration=CMTimeMake(1, 30);
    videoComposition.renderSize=sizeOfVideo;
    videoComposition.animationTool=[AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/utput_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exportSession.videoComposition=videoComposition;
    
    exportSession.outputURL = [NSURL fileURLWithPath:destinationPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"Export OK");
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationPath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export Cancelled");
                break;
        }
    }];
}
-(void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error)
        NSLog(@"Finished saving video with error: %@", error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
