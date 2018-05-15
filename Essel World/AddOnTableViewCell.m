//
//  AddOnTableViewCell.m
//  Essel World
//
//  Created by Karan Ram Pal on 13/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "AddOnTableViewCell.h"

@implementation AddOnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)increaseButtonClicked:(id)sender {
    
    [self.delegate increaseButtonClicked:self];
}

- (IBAction)decreaseButtonClicked:(id)sender {
    
    [self.delegate decreaseButtonClicked:self];
    
}

- (IBAction)checkboxClicked:(id)sender {
    
    [self.delegate checkBoxButtonClicked:self];
    
}

@end
