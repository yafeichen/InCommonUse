//
//  GetAudioFromVideoVC.m
//  InCommonUse
//
//  Created by 陈亚飞 on 2017/7/17.
//  Copyright © 2017年 道说01. All rights reserved.
//

#import "GetAudioFromVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ExtAudioConverter.h"

@interface GetAudioFromVideoVC ()
{
    BOOL  isSelectingAssetOne;
    AVAsset   *firstAsset;
    AVAsset   *secondAsset;
    AVAsset   *audioAsset;
    NSString  *myPathDocs;
    
}

@end

@implementation GetAudioFromVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake(10, 100, 50, 50);
    btn1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn1];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(70, 100, 50, 50);
    btn2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn2];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(130, 100, 50, 50);
    btn3.backgroundColor = [UIColor yellowColor];
    btn3.tag = 3;
    [self.view addSubview:btn3];
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor purpleColor];
    btn4.tag = 4;
    btn4.frame = CGRectMake(190, 100, 50, 50);
    [self.view addSubview:btn4];

    
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton *)sender
{
    if (sender.tag==1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            isSelectingAssetOne = TRUE;
            [self startMediaBrowserFromViewController:self usingDelegate:self];
        }
    }else if(sender.tag==2)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            isSelectingAssetOne = FALSE;
            [self startMediaBrowserFromViewController:self usingDelegate:self];
        }
    }else if(sender.tag==3)
    {
        if (firstAsset !=nil && secondAsset!=nil) {
            
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            //创建一个AVMutableComposition实例
            AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
            
            // 2 - Video track
            //创建一个轨道,类型是AVMediaTypeAudio
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];
            
            //获取firstAsset中的音频,插入轨道
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                                ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
            //获取secondAsset中的音频,插入轨道
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                                ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:firstAsset.duration error:nil];
            
            // 4 - Get path
            //创建输出路径
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                                     [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
            NSLog(@"%@",myPathDocs);
            NSURL *url = [NSURL fileURLWithPath:myPathDocs];
            
            // 5 - Create exporter
            //创建输出对象
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                              presetName:AVAssetExportPresetHighestQuality];
            exporter.outputURL=url;
            exporter.outputFileType = AVFileTypeQuickTimeMovie;
            //        @"com.apple.quicktime-movie";
            exporter.shouldOptimizeForNetworkUse = YES;
            
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self exportDidFinish:exporter];
                });
            }];
        }
    }else
    {
        ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
        //converter.inputFile =  @"/Users/lixing/Desktop/playAndRecord.caf";
        NSLog(@"%@",myPathDocs);
        converter.inputFile =  myPathDocs;
        //output file extension is for your convenience
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *outputPath =  [documentsDirectory stringByAppendingPathComponent:
                       [NSString stringWithFormat:@"mergeVideo-%d.mp3",arc4random() % 1000]];
        converter.outputFile = outputPath;
        NSLog(@"%@",outputPath);
        //TODO:some option combinations are not valid.
        //Check them out
        converter.outputSampleRate = 8000;
        converter.outputNumberChannels = 1;
        converter.outputBitDepth = BitDepth_16;
        converter.outputFormatID = kAudioFormatMPEGLayer3;
        converter.outputFileType = kAudioFileMP3Type;
        [converter convert];
    }

}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    NSLog(@"%ld",session.status);
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]
                                                 initWithContentURL:outputURL];
        
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        
    }
    audioAsset = nil;
    firstAsset = nil;
    secondAsset = nil;
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate {
    // 1 - Validation
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Create image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentModalViewController: mediaUI animated: YES];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 1 - Get media type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    // 2 - Dismiss image picker
    [self dismissModalViewControllerAnimated:NO];
    
    // 3 - Handle video selection
    //判断是不是选中的第一个asset,分别加载到2个asset
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        if (isSelectingAssetOne){
            NSLog(@"Video One  Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video One Loaded"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            firstAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        } else {
            NSLog(@"Video two Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video Two Loaded"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            secondAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }
    }
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
