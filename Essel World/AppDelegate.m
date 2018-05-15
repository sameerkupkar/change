//
//  AppDelegate.m
//  Essel World
//
//  Created by Karan Ram Pal on 25/10/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "Constants.h"
#import "AppDelegate.h"
#import "DrawerViewController.h"
#import <MMDrawerController.h>
#import "LandingViewController.h"
#import "SAPexcursionSOAPSoapBinding.h"
#import "SAPAuthenticateOperationResponse.h"
#import "SAPAuthenticateOperationResponseBody.h"
#import "SAPSoapError.h"
#import "Utilities.h"
#import "Reachability.h"
#import "BookingDetailsViewController.h"
#import "GifAnimatingViewController.h"

@interface AppDelegate ()
{
    Reachability *reachability;
    BOOL authenticationFailed;
    GifAnimatingViewController *gifAnimatingViewController;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"SessionId"];
//    [self openLandingViewController];
    
    [self loadData];
    
     UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self callAuthenticationWebService];
    
    [NSTimer scheduledTimerWithTimeInterval:600 repeats:true block:^(NSTimer * _Nonnull timer) {
        [self callAuthenticationWebService];
    }];
    
    
    [self setUpRechability];
    
    return YES;
}

-(void)loadData{
    
    
    
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Landing" bundle:nil];
    
    
    
    /* UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
     green:173.0/255.0
     blue:234.0/255.0
     alpha:1.0];
     */
/*    [self.window setTintColor:[UIColor redColor]];
    
    gifAnimatingViewController = [storyboard instantiateViewControllerWithIdentifier:@"GifAnimatingViewController"];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:gifAnimatingViewController];
    navigationController.navigationBar.hidden = true;
    [navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    self.window.rootViewController = gifAnimatingViewController; */

    DrawerViewController *drawerViewController = [storyboard instantiateViewControllerWithIdentifier:@"DrawerViewController"];
    LandingViewController *landingViewController = [storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    
    MMDrawerController *mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:landingViewController rightDrawerViewController:drawerViewController];
    
    [mmDrawerController setShowsShadow:NO];
    [mmDrawerController setRestorationIdentifier:@"MMDrawer"];
    [mmDrawerController setMaximumRightDrawerWidth:300.0];
    [mmDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [mmDrawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         UIViewController * sideDrawerViewController;
         if(drawerSide == MMDrawerSideLeft){
             sideDrawerViewController = drawerController.leftDrawerViewController;
         }
         else if(drawerSide == MMDrawerSideRight){
             sideDrawerViewController = drawerController.rightDrawerViewController;
         }
         [sideDrawerViewController.view setAlpha:percentVisible];
     }];
    mmDrawerController.view.backgroundColor = [UIColor colorWithRed:31.0/255.0
                                                              green:137.0/255.0
                                                               blue:182.0/255.0
                                                              alpha:1.0];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 800, 20)];
    topView.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                              green:156.0/255.0
                                               blue:51.0/255.0
                                              alpha:1.0];
    [mmDrawerController.view addSubview:topView];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:mmDrawerController];
    navigationController.navigationBar.hidden = true;
    [navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    
    self.window.rootViewController=navigationController;
    
  /*  UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    
    [self.view.window setTintColor:tintColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:navigationController animated:false completion:nil];
        //        [self pushViewController:mmDrawerController animated:true];
    });

    */
    
    
    
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString * deviceTokenString = [[[[deviceToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceToken"];
    NSLog(@"DeviceToken: %@", deviceTokenString);
}

-(void)callAuthenticationWebService {
    if ([Utilities isConnected]) {
        
        [self authenticateOperationWebservice];
    }else {
        
        authenticationFailed = true;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
        
    }

}

-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        NSLog(@"no");
        authenticationFailed = true;
        
    }
    else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        if (authenticationFailed) {
            
            [self authenticateOperationWebservice];
        }
    }
    
}

- (void) handleNetworkChange:(NSNotification *)notice
{
   
    
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        NSLog(@"no");
        authenticationFailed = true;
        
    }
    else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        if (authenticationFailed) {
            
            [self authenticateOperationWebservice];
        }
    }
    
}



-(void)authenticateOperationWebservice {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:authorization];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"TestURL CAll  %@", json);
            NSLog(@"TestURL CAll  %@", json[@"Response"][@"status"]);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                
                
                @try {
                   
                    
                    
                    if (json[@"Response"][@"Result"][@"sessionID"]) {
                        
                        
                        
                        
                        if ([json[@"Response"][@"Result"][@"sessionID"] isEqualToString:@"0"]) {
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"SessionId"];
                            
                            if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                                [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
                                [self.delegate authenticationResult:false fromFunction:self.functionType];
                            }
                        }else{
                            
                            [[NSUserDefaults standardUserDefaults]setObject:json[@"Response"][@"Result"][@"sessionID"] forKey:@"SessionId"];
                            if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
                                [self.delegate authenticationResult:true fromFunction:self.functionType];
                            }
                        }
                        
                    }
                    else{
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"SessionId"];
                        if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                            [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
                            [self.delegate authenticationResult:false fromFunction:self.functionType];
                        }
                    }

                    
                    
                }
                
                
                @catch (NSException *exception) {
                    
                    NSLog(@"%@", exception.reason);
                    
                    
                }
               
                
                
            }else{
                
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"SessionId"];
                
                if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                    [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
                    [self.delegate authenticationResult:false fromFunction:self.functionType];
                }
            }
            
        }else {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"SessionId"];
            if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
                [self.delegate authenticationResult:false fromFunction:self.functionType];
            }
        }
        
    }];
    
    [postDataTask resume];
}

/*
-(void)authenticateOperationWebservice {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy-MM-dd";
    
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    
    SAPexcursionSOAPSoapBinding* service = [[SAPexcursionSOAPSoapBinding alloc]initWithUrl:@"http://ws.esselworld.in/excursionWSV3/services/excursionSOAP"];
    
    SAPAuthenticationRealm* param0 = [[SAPAuthenticationRealm alloc] init];
    SAPAuthenticateOperationBody* param1 = [[SAPAuthenticateOperationBody alloc] init];
    param0.SourceID = @"ESSEL-PIPPL";
    param0.MessageID = @"AUTH";
    param0.MessageType = @"AUTHENTICATE";
    param0.TimeStamp = [formatter stringFromDate:date];
    
    param1.userName = @"ew-app-user";
    param1.password = @"ew-app-user";
    param1.CID = @"ESSEL-PIPPL";
    
    
    [service AuthenticateOperationPORTAsync:param0 Body:param1 __target:self __handler:@selector(handler:)];
}

-(void) handler:(id) obj
{
    if([obj isKindOfClass:[SAPSoapError class]])
    {
        
        SAPSoapError* fault=(SAPSoapError*)obj;
        NSLog(@"SAPSoapError :%@", fault);
        
        if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
            [self.delegate authenticationResult:false fromFunction:self.functionType];
        }
    }
    else if([obj isKindOfClass:[NSError class]])
    {
        
        NSError* fault=(NSError*)obj;
        NSLog(@"SoapErrorResponse :%@", fault);
        if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self.window.rootViewController presentViewController:alertController animated:NO completion:nil];
            [self.delegate authenticationResult:false fromFunction:self.functionType];
        }
    }
    else if([obj isKindOfClass:[SAPAuthenticateOperationResponse class]])
    {
        
        SAPAuthenticateOperationResponse* res=(SAPAuthenticateOperationResponse*)obj;
        if ([res.Body.sessionID isEqualToString:@"0"]) {
            
            [self callAuthenticationWebService];
        }else {
            
            NSLog(@"SoapSessionId :%@", res.Body.sessionID);
            [[NSUserDefaults standardUserDefaults]setObject:res.Body.sessionID forKey:@"SessionId"];
            
            if ([self.delegate respondsToSelector:@selector(authenticationResult:fromFunction:)]) {
                [self.delegate authenticationResult:true fromFunction:self.functionType];
            }
        }
    }
}
 */


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
