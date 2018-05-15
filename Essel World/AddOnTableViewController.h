//
//  AddOnTableViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 13/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddOnTableViewController;

@protocol AddOnTableViewDelegate <NSObject>

-(void)increaseClicked:(AddOnTableViewController *)sender currentIndex:(NSString *)index onCellIndex:(NSInteger)cellIndex withCount:(int)currentValue;
-(void)decreaseClicked:(AddOnTableViewController *)sender currentIndex:(NSString *)index onCellIndex:(NSInteger)cellIndex withCount:(int)currentValue;
-(void)checkBoxClicked:(AddOnTableViewController *)sender currentIndex:(NSString *)index onCellIndex:(NSInteger)cellIndex isSelected:(NSString *)status;

@end

@interface AddOnTableViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) NSArray *staticArray;
@property (strong, nonatomic) NSMutableString* currentIndex;
@property (weak, nonatomic) id <AddOnTableViewDelegate> delegate;

@end
