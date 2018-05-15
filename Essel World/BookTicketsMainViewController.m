//
//  BookTicketsMainViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 05/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "BookTicketsMainViewController.h"
#import "RegularTicketsViewController.h"
#import "BookingDetailsViewController.h"
#import "AddOnViewController.h"

@interface BookTicketsMainViewController ()<RegularTicketsDelegate>
{
    int currentPageIndex;
    RegularTicketsViewController *regularTicketsVC;
    RegularTicketsViewController *combinedTicketsVC;
   
    RegularTicketsViewController *annualPassesVC;
   
     int cellCount;
    int oldIndex;
}

@property (strong, nonatomic)  RegularTicketsViewController *dynamicTicketsVC;
@property (weak, nonatomic) IBOutlet UICollectionView *ticketTypeCell;
@property(strong,nonatomic) NSMutableArray *ticketTypeArray;
@property(strong,nonatomic) NSMutableArray *ticketTypeDataArray;
@property(strong,nonatomic) NSMutableArray *viewDataArray;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *regularTicketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *combinedTicketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualPassportLabel;
@property (weak, nonatomic) IBOutlet UIView *combinedView;
@property (weak, nonatomic) IBOutlet UIView *annualView;
@property (weak, nonatomic) IBOutlet UIView *regularView;
@end

@implementation BookTicketsMainViewController

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ticketTypeCell.dataSource=self;
    self.ticketTypeCell.delegate=self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    cellCount=0;
    self.ticketTypeArray=[[NSMutableArray alloc]init];
    self.ticketTypeDataArray=[[NSMutableArray alloc]init];
    self.ticketTypeDataArray = [NSMutableArray arrayWithArray:self.dataDictionary[@"ExcursionCatagory"]];
    
    for (int i = 0; i < [self.ticketTypeDataArray count]; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.ticketTypeDataArray[i]];
    
        [dict setObject:self.ticketTypeDataArray[i][@"CategoryType"] forKey:@"NCategoryType"];
        if (i == 0) {
            [dict setObject:@"true" forKey:@"isSelected"];
        }else {
            [dict setObject:@"false" forKey:@"isSelected"];
        }
        [self.ticketTypeDataArray replaceObjectAtIndex:i withObject:dict];
    }
    dispatch_async(dispatch_get_main_queue(),^
                   {
                 [self.ticketTypeCell reloadData];
                   });

    NSMutableDictionary *regularCatagory = [NSMutableDictionary dictionary];
    regularCatagory = [NSMutableDictionary dictionaryWithDictionary:self.dataDictionary[@"ExcursionCatagory"][0]];
    if (regularCatagory.allKeys.count > 0) {
       
        regularTicketsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularTicketsViewController"];
        regularTicketsVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.mainView.frame.size.height);
        regularTicketsVC.dictData = regularCatagory.mutableCopy;
        if ([regularCatagory[@"ExcursionVarriations"] count] ==0) {
            regularTicketsVC.tableView.hidden = true;
            regularTicketsVC.headerView.hidden = true;
        }
        [self addChildViewController:regularTicketsVC];
        [self.mainView addSubview:regularTicketsVC.view];
        regularTicketsVC.delegate = self;
        [regularTicketsVC didMoveToParentViewController:self];
    }
///trial Code
    self.viewDataArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[self.ticketTypeDataArray count];i++)
    {
        
        NSMutableDictionary *regularCatagory = [NSMutableDictionary dictionary];
        regularCatagory = [NSMutableDictionary dictionaryWithDictionary:self.dataDictionary[@"ExcursionCatagory"][i]];
        
        if (regularCatagory.allKeys.count > 0) {
        
            regularTicketsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegularTicketsViewController"];
            regularTicketsVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.mainView.frame.size.height);
            regularTicketsVC.delegate = self;
            regularTicketsVC.dictData = regularCatagory.mutableCopy;
            
            [self addChildViewController:regularTicketsVC];
            if ([regularCatagory[@"ExcursionVarriations"] count] ==0) {
                regularTicketsVC.tableView.hidden = true;
                regularTicketsVC.headerView.hidden = true;
            }
            
            if(i==0)
            {
               [self.mainView addSubview:regularTicketsVC.view];
            self.dynamicTicketsVC=regularTicketsVC;
            }
            [self.viewDataArray addObject:regularTicketsVC];
        }
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.ticketTypeDataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *label=(UILabel*)[cell viewWithTag:100];
    
    label.text=self.ticketTypeDataArray[indexPath.item][@"NCategoryType"];
    
    if (self.ticketTypeDataArray[indexPath.item][@"isSelected"]) {
        
        if ([self.ticketTypeDataArray[indexPath.item][@"isSelected"] isEqualToString:@"true"]) {
            
            label.backgroundColor = [UIColor colorWithRed:73.0/255.0
                                                    green:166.0/255.0
                                                     blue:232.0/255.0
                                                    alpha:1.0];
            
            label.textColor=[UIColor whiteColor];
            
        }else {
            
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:73.0/255.0
                                                    green:166.0/255.0
                                                     blue:232.0/255.0
                                                    alpha:1.0];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      NSLog(@"cellIndex:%ld",indexPath.item);
    
    cellCount=(int)indexPath.item;
    
    for (int i = 0; i < self.ticketTypeDataArray.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.ticketTypeDataArray[i]];
        if (i == (int)indexPath.item) {
            
            [dict setObject:@"true" forKey:@"isSelected"];
        }else {
            
            [dict setObject:@"false" forKey:@"isSelected"];
        }
        
        [self.ticketTypeDataArray replaceObjectAtIndex:i withObject:dict];
        
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ticketTypeCell reloadData];
    });
    
    if (oldIndex != (int)indexPath.item) {
        
        if (oldIndex < (int)indexPath.item) {
            
            oldIndex = (int)indexPath.item;
            CGRect newFrame = self.dynamicTicketsVC.view.frame;
            newFrame.origin.x = self.dynamicTicketsVC.view.frame.size.width;
            
            
            CGRect oldFrame = self.dynamicTicketsVC.view.frame;
            oldFrame.origin.x = -self.dynamicTicketsVC.view.frame.size.width;
            
            RegularTicketsViewController *vc = (RegularTicketsViewController *)self.viewDataArray[indexPath.item];
            
             vc.delegate = self;
            vc.view.frame = newFrame;
           
            [self.mainView addSubview:vc.view];
            
            newFrame.origin.x = 0;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.dynamicTicketsVC.view.frame = oldFrame;
                vc.view.frame = newFrame;
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [self.dynamicTicketsVC.view removeFromSuperview];
                    self.dynamicTicketsVC = vc;
                    
                }
            }];
            
        }else {
            
            oldIndex = (int)indexPath.item;
            CGRect newFrame = self.dynamicTicketsVC.view.frame;
            newFrame.origin.x = -self.dynamicTicketsVC.view.frame.size.width;
            
            
            CGRect oldFrame = self.dynamicTicketsVC.view.frame;
            oldFrame.origin.x = self.dynamicTicketsVC.view.frame.size.width;
            
            RegularTicketsViewController *vc = (RegularTicketsViewController *)self.viewDataArray[indexPath.item];
             vc.delegate = self;
            vc.view.frame = newFrame;
            [self.mainView addSubview:vc.view];
            
            newFrame.origin.x = 0;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.dynamicTicketsVC.view.frame = oldFrame;
                vc.view.frame = newFrame;
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [self.dynamicTicketsVC.view removeFromSuperview];
                    self.dynamicTicketsVC = vc;
                    
                }
            }];
            
        }
    }
    [self.view layoutIfNeeded];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUnselectedColorForLabel:(UILabel *)label {
    
    label.textColor = [UIColor colorWithRed:73.0/255.0
                                      green:166.0/255.0
                                       blue:232.0/255.0
                                      alpha:1.0];
    label.backgroundColor = [UIColor whiteColor];
    
}

-(void)setSelectedColorForLabel:(UILabel *)label {
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:73.0/255.0
                                            green:166.0/255.0
                                             blue:232.0/255.0
                                            alpha:1.0];
}

-(void)proceedToAddonsClickedWithCategoryData:(NSDictionary *)dictData sender:(RegularTicketsViewController *)sender{
    
    AddOnViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddOnViewController"];
    destinationVC.searchDictionary = [NSMutableDictionary dictionaryWithDictionary:self.searchDictionary];
    destinationVC.selectedCategory = [NSMutableDictionary dictionaryWithDictionary:dictData];
    destinationVC.categoryName = self.from;
    destinationVC.sourceRefId = dictData[@"Source_ref_ID"];
    
    if ([sender isEqual:regularTicketsVC]) {
        
        destinationVC.ticketType = self.regularTicketsLabel.text;
        
    }else if ([sender isEqual:combinedTicketsVC]) {
        
        destinationVC.ticketType = self.combinedTicketsLabel.text;
        
    }else if ([sender isEqual:annualPassesVC]) {
        
        destinationVC.ticketType = self.annualPassportLabel.text;
        
    }

    NSString *totalPax;
    if ([dictData[@"ExcursionVarriations"] isKindOfClass:[NSArray class]]) {
        
        int totalCount = 0;
        for (int i = 0; i < [dictData[@"ExcursionVarriations"] count]; i++) {
            totalCount = totalCount + [dictData[@"ExcursionVarriations"][i][@"VarriationPaxCount"] intValue];
        }
        totalPax = [NSString stringWithFormat:@"%i", totalCount];
    }else{
        
        int totalCount = [dictData[@"ExcursionVarriations"][@"VarriationPaxCount"] intValue];
        totalPax = [NSString stringWithFormat:@"%i", totalCount];
    }
    
    destinationVC.totalPax = totalPax;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:destinationVC animated:true];
    });
    
}

- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

@end
