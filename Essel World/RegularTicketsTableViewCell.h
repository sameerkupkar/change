//
//  RegularTicketsTableViewCell.h
//  Essel World
//
//  Created by Karan Ram Pal on 05/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegularTicketsTableViewCell;
@protocol RegularTicketsCellDelegate <NSObject>

-(void)selectButtonClicked:(RegularTicketsTableViewCell *)sender;

@end

@interface RegularTicketsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *srCitizenView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *srCitizenHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *adultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adultViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *adultCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *childCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *srCitizenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *srCitizenPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UILabel *passengerCategoryName;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) id <RegularTicketsCellDelegate> delegate;

@end
