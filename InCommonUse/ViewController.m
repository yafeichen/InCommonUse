//
//  ViewController.m
//  InCommonUse
//
//  Created by 道说01 on 16/11/11.
//  Copyright © 2016年 道说01. All rights reserved.
//

#import "ViewController.h"
#import "JudgeStrIncludeEmoVC.h"
#import "DateDifferenceVC.h"
#import "VideoAddWatermark.h"
#import "InserMusicToVideoVC.h"
#import "ShowView.h"
#import "ExplainVideoVC.h"
#import "AlgorithmViewController.h"
#import "GetAudioFromVideoVC.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ShowViewDelegate>

@property(nonatomic, strong) NSArray        *commonArr;
@property(nonatomic, strong) ShowView        *sortView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常用方法搜集";
    self.commonArr = @[@"字符串表情判定",@"计算时间差",@"视频加水印",@"视频插入音乐",@"冒泡算法",@"选择排序",@"分解视频",@"算法",@"从视频中获取音频"];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
    window.rootViewController = nav;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commonArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [self.commonArr objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            JudgeStrIncludeEmoVC *judgeStrIncludeEmoVC = [[JudgeStrIncludeEmoVC alloc]init];
            [self.navigationController pushViewController:judgeStrIncludeEmoVC animated:YES];
        }
            break;
        case 1:
        {
            DateDifferenceVC *dateDifferenceVC = [[DateDifferenceVC alloc]init];
            [self.navigationController pushViewController:dateDifferenceVC animated:YES];
        }
            break;
        case 2:
        {
            VideoAddWatermark *videoAddWatermarkVC = [[VideoAddWatermark alloc]init];
            [self.navigationController pushViewController:videoAddWatermarkVC animated:YES];
        }
            break;
        case 3:
        {
            InserMusicToVideoVC *insertMusic = [[InserMusicToVideoVC alloc]init];
            [self.navigationController pushViewController:insertMusic animated:YES];
        }
            break;
        case 4:
        {
            int arry[7] = {20,1,8,40,12,13,9};
            int num = sizeof(arry)/sizeof(int);
            paoMethod(arry,num);
            NSString *str = @"冒泡排序 for (int i=0; i<num-1; i++) \n { \n for (int j=0; j<num-1-i; j++) \n { \n if (arr[j]>arr[j+1]) \n { \nint temp = arr[j]; \n arr[j] = arr[j+1]; \n arr[j+1] = temp; \n } \n } \n } ";
            [self creatShowCodeView:str];
//            int num = sizeof(arry)/sizeof(int);
//            for (int i=0; i<num-1; i++)
//            {
//                for (int j=0; j<num-1-i; j++)
//                {
//                    if (arry[j]>arry[j+1])
//                    {
//                        int temp = arry[j];
//                        arry[j] = arry[j+1];
//                        arry[j+1] = temp;
//                    }
//                }
//            }
//            for (int a=0; a<num; a++)
//            {
//                NSLog(@"%d",arry[a]);
//            }
        }
            break;
        case 5:
        {
            int arry2[10] = {86, 37, 56, 29, 92, 73, 15, 63, 30, 8};
            sort(arry2, 10);
            for (int i=0; i<10; i++)
            {
                NSLog(@"%d",arry2[i]);
            }
            NSString *str = @"选择排序 \n   \n \n  void sort(int a[],int n) \n{ \n int i,j,index; \n for (i=0; i<n-1; i++) \n for (i=0; i<n-1; i++) \n { \n index = i; \n for (j = i+1; j<n; j++) \n { \n if (a[index]>a[j]) \n { \nindex = j; \n } \n } \n if (index != i) \n { \n int temp = a[i]; \n a[i] = a[index]; \n a[index] = temp; \n } \n } \n }";
            [self creatShowCodeView:str];
        }
            break;
        case 6:
        {
            ExplainVideoVC *explainVC = [[ExplainVideoVC alloc] init];
            [self.navigationController pushViewController:explainVC animated:YES];
        }
            break;
        case 7:
        {
            AlgorithmViewController *algorithmViewController = [[AlgorithmViewController alloc] init];
            [self.navigationController pushViewController:algorithmViewController animated:YES];
        }
            break;
        case 8:
        {
            GetAudioFromVideoVC *getAudioFromVideoVC= [[GetAudioFromVideoVC alloc] init];
            [self.navigationController pushViewController:getAudioFromVideoVC animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)creatShowCodeView:(NSString *)str
{
    _sortView = [[ShowView alloc]initWithFrame:self.view.frame showContent:str];
    _sortView.backgroundColor = [UIColor whiteColor];
    _sortView.delegate = self;
    [self.view addSubview:_sortView];
}
//冒泡排序
void paoMethod(int arr[], int num)
{
    for (int i=0; i<num-1; i++)
    {
        for (int j=0; j<num-1-i; j++)
        {
            if (arr[j]>arr[j+1])
            {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
    for (int a=0; a<num; a++)
    {
        NSLog(@"%d",arr[a]);
    }
}
//选择排序
void sort(int a[],int n)
{
    int i,j,index;
    for (i=0; i<n-1; i++)
    {
        index = i;
        for (j = i+1; j<n; j++)
        {
            if (a[index]>a[j])
            {
                index = j;
            }
        }
        if (index != i)
        {
            int temp = a[i];
            a[i] = a[index];
            a[index] = temp;
        }
    }
}
//快速排序

-(void)dismissSelf
{
    [_sortView removeFromSuperview];
    _sortView = nil;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
