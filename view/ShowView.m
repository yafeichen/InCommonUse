//
//  ShowView.m
//  InCommonUse
//
//  Created by 道说01 on 17/1/5.
//  Copyright © 2017年 道说01. All rights reserved.
//

#import "ShowView.h"

@implementation ShowView

-(instancetype)initWithFrame:(CGRect)frame showContent:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self layoutShowView:content];
    }
    return self;
}
-(void)layoutShowView:(NSString *)contentStr
{
    UILabel *contentLabel = [UILabel new];
    contentLabel.frame = self.frame;
    contentLabel.numberOfLines = 0;
    contentLabel.text = contentStr;
    [self addSubview:contentLabel];
    
    UIButton *removeShowViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeShowViewBtn.backgroundColor = [UIColor greenColor];
    removeShowViewBtn.frame = CGRectMake(self.frame.size.width-50, self.frame.size.height-50, 30, 30);
    [self addSubview:removeShowViewBtn];
    [removeShowViewBtn addTarget:self action:@selector(removeShowViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)removeShowViewBtnClick
{
    if ([_delegate respondsToSelector:@selector(dismissSelf)])
    {
        [_delegate dismissSelf];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
