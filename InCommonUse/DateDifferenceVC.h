//
//  DateDifferenceVC.h
//  InCommonUse
//
//  Created by 道说01 on 16/11/11.
//  Copyright © 2016年 道说01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateDifferenceVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeDifferenceLabel;

- (IBAction)sureBtnClick:(id)sender;

@end
