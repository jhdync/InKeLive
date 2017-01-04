//
//  NearHeadReusableView.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "NearHeadReusableView.h"

@implementation NearHeadReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//选择查看全部、选择女生、男生
- (IBAction)chooseClick:(id)sender {
    if (self.chooseCondition) {
        self.chooseCondition();
    }
}



@end
