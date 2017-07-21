//
//  ShowView.h
//  InCommonUse
//
//  Created by 道说01 on 17/1/5.
//  Copyright © 2017年 道说01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowViewDelegate <NSObject>

-(void)dismissSelf;

@end
@interface ShowView : UIView

-(instancetype)initWithFrame:(CGRect)frame showContent:(NSString *)content;

@property (nonatomic, assign) id<ShowViewDelegate>      delegate;

@end
