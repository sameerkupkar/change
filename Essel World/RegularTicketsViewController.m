//
//  RegularTicketsViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 05/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "RegularTicketsViewController.h"
#import "RegularTicketsTableViewCell.h"
#import "ViewMoreVC.h"



@interface RegularTicketsViewController () <UITableViewDelegate, UITableViewDataSource, RegularTicketsCellDelegate>
{
    int totalAmount;
    BOOL isOtherCategory;
    ViewMoreVC *viewMore;
    UIView *newView;
    UIView *infoView;

}
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@end

@implementation RegularTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isOtherCategory = true;
    _viewMoreBtn.layer.borderWidth = 1.0f;
    _viewMoreBtn.layer.cornerRadius = 10.0f;
    self.mytext.layoutManager.allowsNonContiguousLayout = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dictData.allKeys.count > 0) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RegularTicketsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectButton.layer.cornerRadius = 7;
    
    dispatch_async(dispatch_get_main_queue(),
                   ^
                   {
                    [self.NAMELABELTEXT setText:[NSString stringWithFormat:@"%@",[self.dictData valueForKey:@"CategoryType"]]];
                    cell.NameLabel.text=[self.dictData valueForKey:@"CategoryType"];
                    });
  
    if ([self.from isEqualToString:@"DownTown"]) {
        NSDictionary *excursionVarriations = [NSDictionary dictionaryWithDictionary:self.dictData[@"ExcursionVarriations"]];
        totalAmount = 0;
        totalAmount = totalAmount + [excursionVarriations[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"] intValue];
        cell.adultCountLabel.text = excursionVarriations[@"VarriationPaxCount"];
        cell.adultPriceLabel.text = [NSString stringWithFormat:@"₹ %@", excursionVarriations[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"]];
        cell.childView.hidden = true;
        cell.srCitizenView.hidden = true;
        cell.srCitizenHeightConstraint.constant = 0;
        cell.childViewHeightConstraint.constant = 0;
    }else {
        NSArray *excursionVarriations;
        if([self.dictData[@"ExcursionVarriations"] isKindOfClass:[NSArray class]])
        {
            totalAmount = 0;
            excursionVarriations = [NSArray arrayWithArray:self.dictData[@"ExcursionVarriations"]];
            NSLog(@"%@",excursionVarriations);
            
            for (int i = 0; i < excursionVarriations.count; i++) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:excursionVarriations[i]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                    if ( i==0 && ![[dict valueForKey:@"VarriationPaxCount"]  isEqualToString:@"0"] ) {
                        
                        cell.adultView.hidden = false;
                            totalAmount = totalAmount + [dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"] intValue];
                            cell.adultCountLabel.text = dict[@"VarriationPaxCount"];
                            cell.adultPriceLabel.text = [NSString stringWithFormat:@"₹ %@", dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"]];
                        
                        cell.titleLabel1.text = [NSString stringWithFormat:@"%@", dict[@"VarriationName"]];
                        
                    } else  if (i==0 && [[dict valueForKey:@"VarriationPaxCount"]isEqualToString:@"0"] ) {
                        self.adultUnSelected = true;
                        cell.adultViewHeightConstraint.constant = 0;
                        cell.adultView.hidden = true;
                    }
                       
                    if (i==1 && ![[dict valueForKey:@"VarriationPaxCount"]isEqualToString:@"0"]) {
                        
                        cell.childView.hidden = false;
                            totalAmount = totalAmount + [dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"] intValue];
                            cell.childCountLabel.text = dict[@"VarriationPaxCount"];
                            cell.childPriceLabel.text = [NSString stringWithFormat:@"₹ %@", dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"]];
                         cell.titleLabel2.text = [NSString stringWithFormat:@"%@", dict[@"VarriationName"]];

                    } else  if (i==1 && [[dict valueForKey:@"VarriationPaxCount"]isEqualToString:@"0"]) {
                        self.childUnSelected = true;
                        cell.childViewHeightConstraint.constant = 0;
                        cell.childView.hidden = true;
                    }
                        
                 if ( i==2 && ![[dict valueForKey:@"VarriationPaxCount"]isEqualToString:@"0"]) {
                     cell.srCitizenView.hidden = false;
                            totalAmount = totalAmount + [dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"] intValue];
                     
                     cell.srCitizenCountLabel.text = dict[@"VarriationPaxCount"];
                            cell.srCitizenPriceLabel.text = [NSString stringWithFormat:@"₹ %@", dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"]];
                     
                      cell.titleLabel3.text = [NSString stringWithFormat:@"%@", dict[@"VarriationName"]];

                 } else if (i==2  && [[dict valueForKey:@"VarriationPaxCount"]isEqualToString:@"0"])  {
                     self.snrCitizenUnSelected = true;
                     cell.srCitizenHeightConstraint.constant = 0 ;
                     cell.srCitizenView.hidden = true;
                 }
                        
                if(![dict[@"VarriationName"] containsString:@"SR CITIZEN"] && ![dict[@"VarriationName"] containsString:@"SENIOR CITIZEN"] && ![dict[@"VarriationName"] containsString:@"CHILD"] && ![dict[@"VarriationName"] containsString:@"ADULT"])
                {
                    
                    NSLog(@"found %@",dict[@"VarriationName"]);
                    
                }
                        
                        
                        
            });
                
                
        }
            
            dispatch_async(dispatch_get_main_queue(), ^{
            cell.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %i", totalAmount];
            });
    }
        else
        {
          totalAmount = 0;
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.dictData[@"ExcursionVarriations"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            if(![dict[@"VarriationName"] isEqualToString:@"Sr Citizen"] || ![dict[@"VarriationName"] isEqualToString:@"Senior Citizen"] || ![dict[@"VarriationName"] isEqualToString:@"Child"] || ![dict[@"VarriationName"] isEqualToString:@"Adult"])
//            {
                cell.adultView.hidden = false;
                totalAmount = totalAmount + [dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"] intValue];
                cell.adultCountLabel.text = dict[@"VarriationPaxCount"];
                cell.adultPriceLabel.text = [NSString stringWithFormat:@"₹ %@", dict[@"ExcursionVarriationPricing"][@"TotalGrossRateInSellingCurrency"]];
                cell.passengerCategoryName.text = dict[@"VarriationName"];
            
            
             cell.titleLabel1.text = [NSString stringWithFormat:@"%@", dict[@"VarriationName"]];
            //}
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %i", totalAmount];
            });
        }
    }
    
    //cell.totalAmountLabel.text = [NSString stringWithFormat:@"₹ %i", totalAmount];
    //self.totalAmountLabel.text = cell.totalAmountLabel.text;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.from isEqualToString:@"DownTown"]) {
        return 80;
    }
    return 160;
}

-(void)selectButtonClicked:(RegularTicketsTableViewCell *)sender{
    //Not used
    
}

- (IBAction)proceedToAddonsClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(proceedToAddonsClickedWithCategoryData:sender:)]) {
        NSLog(@"%@", self.dictData);
        [self.delegate proceedToAddonsClickedWithCategoryData:self.dictData sender:self];
    }
}

- (IBAction)viewInfoButtonClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        infoView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        infoView.backgroundColor = [UIColor lightGrayColor];
        infoView.alpha = 1;
        newView = [[UIView alloc] initWithFrame:CGRectMake(20.0,10.0,300,250)];
        newView.backgroundColor=[UIColor whiteColor];
        newView.layer.cornerRadius = 10.0f;
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        scroll.pagingEnabled = YES;
        
        UITextView *mytext = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 260, 100)];
        newView.center = self.view.center;
        mytext.textColor = [UIColor blackColor];
        mytext.editable = NO;
        mytext.font = [UIFont systemFontOfSize:15];
        mytext.text = [NSString stringWithFormat:@"%@", [self.dictData valueForKey:@"CatagoryDescription"]];
        mytext.scrollEnabled=NO;
        [mytext sizeToFit];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(aMethod)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Okay" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:73/255 green:166/255 blue:232/255 alpha:1];
        button.frame = CGRectMake(50.0, 200.0, 200.0, 40.0);
        button.layer.cornerRadius = 5.0f;
        [newView addSubview:button];
        [newView addSubview:mytext];
        [infoView addSubview:newView];
        // [infoView addSubview:myScroll];
        [self.view addSubview:infoView];
    });
}

-(void)aMethod {
    dispatch_async(dispatch_get_main_queue(), ^{
        [infoView removeFromSuperview];
    });
}
@end
