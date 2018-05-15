//
//  BarcodeViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 15/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingHistoryViewController.h"

@interface BarcodeViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *indexOfData;
@property (strong, nonatomic) BookingHistoryViewController *bookingHistoryContext;

@end
