//
//  Utilities.h
//  Essel World
//
//  Created by Karan Ram Pal on 14/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef void(^webServiceCompletion)(NSData* data, BOOL connected);

typedef void(^imageUploadCompletion)(NSData* data, BOOL connected, NSString *imageName);

@interface Utilities : UIViewController<NSURLSessionDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLAuthenticationChallengeSender>



+ (void)checkInternetAndCallWebserviceWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters callself:(NSURLSession *)session  callBack:(webServiceCompletion)completion;



+(UIView *)addAlerBox:(NSString*)msg ALertview:(UIView*)alertView;
+ (BOOL) isConnected;

+(void)callCardList:(NSString*)mobNumber authtoken:(NSString*)authtoken completionHandler:(void(^)(NSMutableDictionary*))result;

+(void)removeCallMethod;
+ (void)showNoInternetOn:(id)viewController;
+ (void)showSomethingWentWrong:(id)viewController;
+ (void)showAlertWithMessage:(NSString *)message on:(id)viewController;

+ (void)customAlert:(NSString *)message on:(id)viewController;

+(NSString*)getAmmountFormat:(NSString*)AMount;

+ (void)checkInternetAndCallWebserviceWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters withLoaderOnView:(UIView *)view callBack:(webServiceCompletion)completion;

+ (void)checkInternetAndCallWebserviceWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters callBack:(webServiceCompletion)completion;

+ (void)checkInternetAndUploadImage:(UIImage *)image onURL:(NSString *)urlString withLoaderOnView:(UIView *)view callBack:(imageUploadCompletion)completion;


+(NSString*)getBalanceFormat:(NSString*)balance;

@property (strong, nonatomic) UIWindow *window1;


@end
