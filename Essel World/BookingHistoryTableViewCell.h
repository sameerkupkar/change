//
//  BookingHistoryTableViewCell.h
//  Essel World
//
//  Created by Karan Ram Pal on 14/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingID;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBooking;
@property (weak, nonatomic) IBOutlet UILabel *dateOfVisit;
@property (weak, nonatomic) IBOutlet UILabel *typeOfTicket;
@end
