//
//  PaymentGatewayViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 07/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentGatewayViewController;

@protocol PaymentGatewayDelegate <NSObject>

-(void)paymentStatus:(NSString *)status sender:(PaymentGatewayViewController *)sender;

@end

@interface PaymentGatewayViewController : UIViewController

@property (strong, nonatomic) NSString *orderID;
@property (weak, nonatomic) id <PaymentGatewayDelegate> delegate;
@end
