//
//  EntryRatesTableViewCell.h
//  Essel World
//
//  Created by Karan Ram Pal on 07/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryRatesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *srCitizenPriceLabel;

@end
