//
//  SearchView.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView

@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong)UIButton *cancleButton;

@property (nonatomic,copy)void (^cancleBlock)();

@end
