//
//  AlgorithmViewController.m
//  InCommonUse
//
//  Created by 陈亚飞 on 2017/7/13.
//  Copyright © 2017年 道说01. All rights reserved.
//

#import "AlgorithmViewController.h"

@interface AlgorithmViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}


/**
 五个人偷苹果
 */
int n=1;
-(void)fivePeopleStealApple
{
    float m=0;
    //最后一个人有n个苹果（n大于0）
    int count = [self apple:m count:n];
    NSLog(@"%d",count);
//    NSLog(@"%f",m);
}
-(int)apple:(int)value count:(int)value2
{
    for (int i=0; i<6; i++)
    {
        //        m+=n*1.2;
        //        n=m;
        //        最后扔了一个
        if(i==0)
        {
            value = 5*value2+1;//第六次分
        }else
        {
            value+=value*1.25+1;
            NSLog(@"%d",value);
            if (value%5 != 0)
            {
                n++;
                [self apple:0 count:n];
            }
        }
    }
    return value;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"五人偷苹果";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        [self fivePeopleStealApple];
    }

}


@end
