//
//  AppDelegate.h
//  Essel World
//
//  Created by Karan Ram Pal on 25/10/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthenticationDelegate <NSObject>

-(void)authenticationResult:(BOOL) success fromFunction:(NSString *)functionType;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) id <AuthenticationDelegate> delegate;
@property (strong, nonatomic) NSString *functionType;

-(void)callAuthenticationWebService;

@end

