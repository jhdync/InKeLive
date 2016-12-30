//
//  BaseTabBarController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "CameraViewController.h"
#import "PersonViewController.h"
#import "TabBar.h"
#import "BaseViewController.h"
#import "CameraView.h"
#import "CameraViewController.h"

@interface BaseTabBarController ()<UITabBarDelegate,TabBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@end

@implementation BaseTabBarController
@synthesize imagePickerController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *backView=[[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor=[UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque=YES;
    
    self.tabBar.tintColor=[UIColor blackColor];
    [self initChildViewControllers];
    
    //隐藏tabBar上的线
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initChildViewControllers{
    //首页
    HomeViewController *homePageVC = [[HomeViewController alloc]init];
    BaseViewController *homeNav = [[BaseViewController alloc]initWithRootViewController:homePageVC];
    [self addChildViewController:homeNav image:@"tab_live" selectedImage:@"tab_live_p"];
    
    //个人
    PersonViewController *personVC = [[PersonViewController alloc]init];
    BaseViewController *personNav = [[BaseViewController alloc]initWithRootViewController:personVC];
    [self addChildViewController:personNav image:@"tab_me" selectedImage:@"tab_me_p"];
    
    TabBar *tabBar = [[TabBar alloc]init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)addChildViewController:(UIViewController *)nav image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    UIViewController *childViewController = nav.childViewControllers.firstObject;
    //tabBarItem图片,显示原图，否则变形
    UIImage *normal = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childViewController.tabBarItem.image = normal;
    childViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animatedWithindex:index];
}

- (void)animatedWithindex:(NSInteger )index{
    NSMutableArray *tabArr = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabArr addObject:tabBarButton];
        }
    }
    CABasicAnimation *base = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    base.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    base.duration = 0.1;
    base.repeatCount = 1;
    base.autoreverses = YES;
    base.fromValue = [NSNumber numberWithFloat:0.8];
    base.toValue = [NSNumber numberWithFloat:1.2];
    [[tabArr[index] layer] addAnimation:base forKey:@"Base"];

}

- (void)cameraButtonClick:(TabBar *)tabBar{
    CameraView *popCamera = [[CameraView alloc]initWithFrame:self.view.bounds];
    [popCamera setButtonClick:^(NSInteger tag) {
        switch (tag) {
            case 50:
                //直播
            {
                CameraViewController *cameraVc = [[CameraViewController alloc]init];
                [self presentViewController:cameraVc animated:YES completion:nil];
            }
                break;
           case 51:
                //短视频
            {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = NO;
                picker.delegate = self;
                self.imagePickerController = picker;
                [self setupImagePicker:sourceType];
                picker = nil;
                self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            
            }
                break;
            default:
                break;
        }
    }];
    [popCamera popShow];
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType{
    if (sourceType != UIImagePickerControllerSourceTypeCamera) {
        return;
    }
    self.imagePickerController.sourceType = sourceType;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}


@end
