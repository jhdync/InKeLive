//
//  TableViewCell.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //添加长按缩小、离开还原的动画
    self.imageViewF.userInteractionEnabled = YES;
    self.imageViewS.userInteractionEnabled = YES;
    self.imageViewT.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *pressF = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    pressF.minimumPressDuration = 0.3;
    [self.imageViewF addGestureRecognizer:pressF];
    UIView *singleTapView = [pressF view];
    singleTapView.tag = self.imageViewF.tag;
    
    UILongPressGestureRecognizer *pressS = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    pressS.minimumPressDuration = 0.3;
    [self.imageViewS addGestureRecognizer:pressS];
    UIView *singleTapViewS = [pressS view];
    singleTapViewS.tag = self.imageViewS.tag;
    
    UILongPressGestureRecognizer *pressT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    pressT.minimumPressDuration = 0.3;
    [self.imageViewT addGestureRecognizer:pressT];
    UIView *singleTapViewT = [pressT view];
    singleTapViewT.tag = self.imageViewT.tag;
}

//长按
- (void)longPressClick:(UILongPressGestureRecognizer *)sender{
    NSInteger tag = [sender view].tag;
    if (sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.5 animations:^{
            switch (tag) {
                case 50:
                    self.imageViewF.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    break;
                case 51:
                    self.imageViewS.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    break;
                case 52:
                    self.imageViewT.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    break;
                default:
                    break;
            }
        }];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageViewF.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.imageViewS.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.imageViewT.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    
}

- (void)updataCell:(Live_Nodes *)model{
    for (NSInteger i = 0; i < model.lives.count; i++) {
        NSString *str = model.lives[i].creator.portrait;
        NSString *titleStr = [NSString stringWithFormat:@"%zd人",model.lives[i].online_users];
        if ([str rangeOfString:@"http://img2.inke.cn/"].location == NSNotFound) {
            str = [NSString stringWithFormat:@"http://img2.inke.cn/%@",str];
        }
        
        switch (i) {
            case 0:
                [self.imageViewF sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageRetryFailed];
                self.LabelF.text = titleStr;
                break;
            case 1:
                [self.imageViewS sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageRetryFailed];
                self.LabelS.text = titleStr;
                break;
            case 2:
                [self.imageViewT sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageRetryFailed];
                self.LabelT.text = titleStr;
                break;
            default:
                break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
