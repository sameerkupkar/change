//
//  BookingDetailsViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 06/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *ticketType;
@property (strong, nonatomic) NSMutableDictionary *searchDict;
@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (strong, nonatomic) NSMutableArray *selectedAddons;
@property (strong, nonatomic) NSMutableString *ticketsOf;
@property (strong, nonatomic) NSString *countArray;
    @property (strong, nonatomic) NSString *totalPax;
@end
