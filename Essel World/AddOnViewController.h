//
//  AddOnViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 12/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOnViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSString *ticketType;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSMutableDictionary *searchDictionary;
@property (strong, nonatomic) NSMutableDictionary *selectedCategory;
@property (strong, nonatomic) NSString *sourceRefId;
@property (strong, nonatomic) NSString *totalPax;

@end
