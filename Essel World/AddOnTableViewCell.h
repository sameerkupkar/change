//
//  AddOnTableViewCell.h
//  Essel World
//
//  Created by Karan Ram Pal on 13/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddOnTableViewCell;

@protocol AddOnTableViewCellDelegate <NSObject>

-(void)increaseButtonClicked:(AddOnTableViewCell *)sender;
-(void)decreaseButtonClicked:(AddOnTableViewCell *)sender;
-(void)checkBoxButtonClicked:(AddOnTableViewCell *)sender;

@end

@interface AddOnTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@property (weak, nonatomic) id <AddOnTableViewCellDelegate> delegate;

@end
