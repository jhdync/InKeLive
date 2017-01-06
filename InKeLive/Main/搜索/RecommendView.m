//
//  RecommendView.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)recommendClick:(id)sender {
    if (self.recommdMoreClick) {
        self.recommdMoreClick(self.recommedTitle.text);
    }
}

@end
