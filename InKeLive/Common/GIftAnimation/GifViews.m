//
//  GifViews.m
//  NHGiftAnimationExample
//
//  Created by 1 on 2016/12/6.
//  Copyright © 2016年 jh All rights reserved.
// 帧动画

#import "GifViews.h"

@implementation GifViews

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.gifImageView.frame = frame;
        [self startAnimation];
        [self addSubview:_gifImageView];
    }
    return self;
}

- (void)startAnimation{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 1; i < 26; i ++) {
        
        NSString *strImage = [NSString stringWithFormat:@"meteor_after_%d",i];
        //不直接使用imageNamed（结束后不释放)
        NSString *path = [[NSBundle mainBundle] pathForResource:strImage ofType:@"png"];
        UIImage *image =  [UIImage imageWithContentsOfFile:path];;
        
        [tempArr addObject:image];
        
    }
    
    _gifImageView.animationImages = tempArr;
    
    _gifImageView.animationDuration = 2.5f;
    
    _gifImageView.animationRepeatCount = 1;
    
    [_gifImageView startAnimating];
    
    [self performSelector:@selector(deleteGif:) withObject:nil afterDelay:3];
}

//释放内存
- (void)deleteGif:(id)object{
    [_gifImageView stopAnimating];
    _gifImageView.animationImages = nil;
    [self removeFromSuperview];
}

- (UIImageView *)gifImageView{
    if (_gifImageView == nil) {
        _gifImageView = [[UIImageView alloc]init];
    }
    return _gifImageView;
}

@end
