//
//  DateDifferenceVC.m
//  InCommonUse
//
//  Created by 道说01 on 16/11/11.
//  Copyright © 2016年 道说01. All rights reserved.
//

#import "DateDifferenceVC.h"

@interface DateDifferenceVC ()

@end

@implementation DateDifferenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureBtnClick:(id)sender
{
    self.timeDifferenceLabel.text = [NSString stringWithFormat:@"%d",[self getCurrentDateDifference]];
}
-(int)getCurrentDateDifference
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
//    NSDate *date1=[dateFormatter dateFromString:@"2010-3-3 11:00"];
//    NSDate *date1 = [dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"]];
    NSDate *date1 = [dateFormatter dateFromString:self.timeLabel.text];
    NSDate *date2=[dateFormatter dateFromString:str];
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
//    int days = ((int)time)/(3600*24);
    return time;
}
//缓存当前时间
-(void)cacheCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:currentDateStr forKey:@"currentDate"];
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
