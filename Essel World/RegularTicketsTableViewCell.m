//
//  RegularTicketsTableViewCell.m
//  Essel World
//
//  Created by Karan Ram Pal on 05/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "RegularTicketsTableViewCell.h"

@implementation RegularTicketsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectButtonClicked:)]) {
        [self.delegate selectButtonClicked:self];
    }
}

@end
