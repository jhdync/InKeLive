//
//  AutoCommon.h
//  51AutoPersonNew
//
//  Created by jh on 16/3/8.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

static NSString *UUID;

@interface AutoCommon : NSObject

// 获取uuid
+ (NSString *)getUUID;

//  获取IP
+ (NSString *)getIPAddress;

// 获取版本号
+ (double)getCurrentIOS;

// 将16进制颜色转换成UIColor
+(UIColor *)getColor:(NSString *)color;

//判断是否有网
+ (BOOL)isEnbnleNet;

//关闭所有键盘
+ (void)hideKeyBoard;

//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string;

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string;

//判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

//邮箱验证
+ (BOOL)isAvailableEmail:(NSString *)email;

//全屏截图
+ (UIImage *)shotScreen;

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;

//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

//压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

//图片转字符串
+(NSString *)UIImageToBase64Str:(UIImage *) image;

//字符串转图片
+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

// 转换json字符串
+(NSString *)toJSON:(id)aParam;

//字符串转字典
+(NSDictionary *)dicWithJSonStr:(NSString *)jsonString;

/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color;

/*
 对图片进行滤镜处理
 怀旧 -> CIPhotoEffectInstant                         单色 -> CIPhotoEffectMono
 黑白 -> CIPhotoEffectNoir                            褪色 -> CIPhotoEffectFade
 色调 -> CIPhotoEffectTonal                           冲印 -> CIPhotoEffectProcess
 岁月 -> CIPhotoEffectTransfer                        铬黄 -> CIPhotoEffectChrome
 CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

/*
对图片进行模糊处理
CIGaussianBlur -> 高斯模糊
CIBoxBlur      -> 均值模糊(Available in iOS 9.0 and later)
CIDiscBlur     -> 环形卷积模糊(Available in iOS 9.0 and later)
CIMedianFilter -> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
CIMotionBlur   -> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

//毛玻璃效果   Avilable in iOS 8.0 and later
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

@end
