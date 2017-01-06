//
//  RecommendCell.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updataCell:(User *)model relation:(NSString *)relation{
     NSString *str = model.portrait;
    if ([str rangeOfString:@"http://img2.inke.cn/"].location == NSNotFound) {
        str = [NSString stringWithFormat:@"http://img2.inke.cn/%@",str];
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageLowPriority|SDWebImageRetryFailed];
    self.nickNameLabel.text = model.nick;
    self.subTextLabel.text = model.hometown;
    
    if (relation.length > 4) {
        [self.addButton setImage:[UIImage imageNamed:@"button_choose-on"] forState:UIControlStateNormal];
    } else {
        [self.addButton setImage:[UIImage imageNamed:@"icon_+"] forState:UIControlStateNormal];
    }
}


- (IBAction)payAttentionClick:(id)sender {
    UIButton *selectButton = (UIButton *)sender;
    if (self.payAttenBlock) {
        self.payAttenBlock(selectButton.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
