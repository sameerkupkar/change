//
//  Utilities.m
//  Essel World
//
//  Created by Karan Ram Pal on 14/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <UIKit/UIViewController.h>




@implementation Utilities




+ (BOOL) isConnected {
    
    
    Reachability * reachability;
    if (!reachability) {
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        //DLog(@"No Network Reachability!");
        return NO;
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        //DLog(@"WiFi Network Reachability");
        return YES;
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        // DLog(@"Cellular Network Reachability");
        return YES;
    }
    return NO;
}

+(void)removeCallMethod
{
    [[NSUserDefaults standardUserDefaults]setValue:@"Flase" forKey:@"LoginFlag"];
    // [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PinDigit"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CustomerId"];
    //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LoginMobileNumb"];
    // [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PinDigit"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NAME"];
    
}

+(NSString*)getAmmountFormat:(NSString*)AMount
{
    
    
    
    NSString *amount = [AMount stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    float b =[amount floatValue];
    
  
    return [NSString stringWithFormat:@"%.02f",b];
    
    
}

+(NSString*)getBalanceFormat:(NSString*)balance
{
    
    
 
    
 float bal =[balance floatValue];

//    float bal = -1.00;
    
    NSString  *VAL =[NSString stringWithFormat:@"%.02f",bal];
    
    float bal1 = [VAL floatValue];
    

    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    
    
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [currencyFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [currencyFormatter setGroupingSeparator:@","];
    [currencyFormatter setDecimalSeparator:@"."];
    
    
    
    
    NSString *value = [NSString stringWithFormat:@"%@",[currencyFormatter stringFromNumber:[NSNumber numberWithFloat:bal1]]];
    
    
    NSString * NValue;
    
    if([value containsString:@"-"])
    {
        value = [value stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        NValue = value;
    }
    else
    {
       NValue = [value substringFromIndex:1];
    }
    
    
    
    
    
    
    NSString *balN = [NSString stringWithFormat:@"N$ %@",NValue];
    
    
    
    
    return balN;
    
    
    
}


+ (void)checkInternetAndCallWebserviceWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters withLoaderOnView:(UIView *)view callBack:(webServiceCompletion)completion {
    
    if ([self isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD showHUDAddedTo:view animated:true];
        
        });
        
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        NSLog(@"%@",parameters);
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error != nil) {
                NSLog(@"error%@", error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:view animated:YES];
            });
            
            completion(data, true);
            
        }];
        
        [postDataTask resume];
        
        
    }else {
        completion(nil, false);
    }
    
}



+ (void)checkInternetAndCallWebserviceWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters callBack:(webServiceCompletion)completion {
    
    
    if ([self isConnected]) {
        
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        

        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        
  
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error != nil) {
                NSLog(@"%@", error);
            }
            
            completion(data, true);
            
        }];
        
        [postDataTask resume];
        
    }else {
        
        NSLog(@"NO RESPONSE FROM JSON REQUEST");
        completion(nil, false);
    }
    
}

+ (void)checkInternetAndCallWebserviceWithUrl:(NSString *)urlString andParameters:(NSDictionary *)parameters callself:(NSURLSession *)session  callBack:(webServiceCompletion)completion{
    
    
    if ([self isConnected]) {
        
        
        
        
        NSError *error;
        

        
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        NSLog(@"%@",urlString);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:@"POST"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        [request setHTTPBody:postData];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error != nil) {
                
                
                NSLog(@"CHECK00005%@", error);
                
                
            }
            
            completion(data, true);
            
        }];
        
        [postDataTask resume];
        
    }else {
        
        NSLog(@"NO RESPONSE FROM JSON REQUEST");
        completion(nil, false);
    }
    
}




+(NSString *)dateAndTimeProfile {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"ddMMyyyyHHmmssSSS";
    
    return [NSString stringWithFormat:@"IMG%@", [formatter stringFromDate:date]];
    
    
}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (void)checkInternetAndUploadImage:(UIImage *)image onURL:(NSString *)urlString withLoaderOnView:(UIView *)view callBack:(imageUploadCompletion)completion {
    
    if ([self isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:view animated:true];
            
        });
        
        NSString *fileName;
        fileName = [self dateAndTimeProfile];
        
        
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", urlString]];
        NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:url];
        
        [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [urequest setHTTPShouldHandleCookies:NO];
        [urequest setTimeoutInterval:60];
        [urequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [urequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        
        UIImage*scaleimage = [self imageWithImage:image convertToSize:CGSizeMake(640, 640)];
        
        NSData *imageData = UIImageJPEGRepresentation(scaleimage,1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *contentDispositionString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"%@.jpg\"\r\n", fileName];
            [body appendData:[contentDispositionString dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [urequest setHTTPBody:body];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:view animated:YES];
            });
            if (error != nil) {
                NSLog(@"%@", error);
            }
            
            completion(data, true, fileName);
            
        }];
        
        [postDataTask resume];

        
    }else {
        completion(nil, false, nil);
    }
    
}

+ (void)showNoInternetOn:(id)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please check your internet connection and try again" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [viewController presentViewController:alertController animated:NO completion:nil];
    });
}

+ (void)showSomethingWentWrong:(id)viewController {
   
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];

    dispatch_async(dispatch_get_main_queue(), ^{

        [viewController presentViewController:alertController animated:NO completion:nil];
    });
    
    
    
}


//+(UIView *)addAlerBox:(NSString*)msg ALertview:(UIView*)alertView
//{
//
//
//
//
//
//                      test *tc = [[test alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-125,[[UIScreen mainScreen] bounds].size.height/2-90,250,180)];
//
//
//
//                       [tc.NameLabel setText:@"Alert"];
//
//                       [tc.MsgLabel setText:msg];
//
//                        return tc;
//
//
//
//
//
//
//
//
//
//}




+ (void)showAlertWithMessage:(NSString *)message on:(id)viewController {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [viewController presentViewController:alertController animated:NO completion:nil];
    });
    
}





@end
