//
//  RegularTicketsViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 05/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegularTicketsViewController;

@protocol RegularTicketsDelegate <NSObject>

-(void)proceedToAddonsClickedWithCategoryData:(NSDictionary *)dictData sender:(RegularTicketsViewController *)sender;

@end

@interface RegularTicketsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NAMELABELTEXT;
@property (weak, nonatomic) IBOutlet UIButton *viewMoreBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;
 @property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *noDataAvailable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *from;
@property (strong,nonatomic)UITextView *mytext;
@property (strong, nonatomic) NSMutableDictionary *dictData;
@property (weak, nonatomic) IBOutlet UILabel *NAMELABEL;
@property (weak, nonatomic) id <RegularTicketsDelegate> delegate;
@property bool adultUnSelected;
@property bool childUnSelected;
@property bool snrCitizenUnSelected;
@property (weak, nonatomic) IBOutlet UILabel *passengerCategory;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@end
