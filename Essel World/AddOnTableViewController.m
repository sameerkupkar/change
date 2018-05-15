//
//  AddOnTableViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 13/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "AddOnTableViewController.h"
#import "AddOnTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"

@interface AddOnTableViewController ()<UITableViewDelegate, UITableViewDataSource, AddOnTableViewCellDelegate>
{
}
@end

@implementation AddOnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    for (int i = 0; i < [self.dataArray[indexPath.row][@"MiscellaneousCategoryInfo"] count]; i++) {
        if ([self.dataArray[indexPath.row][@"MiscellaneousCategoryInfo"][i][@"Key"] isEqualToString:@"EXCURSION_CAT_IMAGE_URL"]) {
            
            [cell.categoryImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"MiscellaneousCategoryInfo"][i][@"Value"]]];
        }
    }
    cell.titleLabel.text = self.dataArray[indexPath.row][@"CatagoryName"];
    cell.descriptionLabel.text = self.dataArray[indexPath.row][@"CatagoryDescription"];
    cell.priceLabel.text = [NSString stringWithFormat:@"₹ %@", self.dataArray[indexPath.row][@"ExcursionCatagoryPricing"][@"TotalGrossRateInSellingCurrency"]];
    
    
    if ([self.dataArray[indexPath.row][@"isSelected"] isEqualToString:@"true"]) {
        
        [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked-red"] forState:UIControlStateNormal];
    }else{
        
        [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked-red"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

#pragma mark - AddOnTableViewCellDelegate
-(void)increaseButtonClicked:(AddOnTableViewCell *)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    int maxCount = 1;
    
    for (int i = 0; i < [self.dataArray[indexPath.row][@"MiscellaneousCategoryInfo"] count]; i++) {
        if ([self.dataArray[indexPath.row][@"MiscellaneousCategoryInfo"][i][@"Key"] isEqualToString:@"MAX_ADDON_COUNT_ALLOWED"]) {
            
            maxCount = [self.dataArray[indexPath.row][@"MiscellaneousCategoryInfo"][i][@"Value"] intValue];
        }
    }
    
    int currentValue = sender.countLabel.text.intValue;
    
    if (currentValue < maxCount) {
        currentValue++;
        
        sender.countLabel.text = [NSString stringWithFormat:@"%i", currentValue];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.staticArray[indexPath.row]];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict[@"ExcursionVarriations"]];
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2[@"ExcursionVarriationPricing"]];
        NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithDictionary:dict[@"ExcursionCatagoryPricing"]];
        
        
        {
            double VarriationConvenienceFee = [dict2[@"VarriationConvenienceFee"] doubleValue];
            int VarriationConvenienceFeeFlat = [dict2[@"VarriationConvenienceFeeFlat"] intValue];
            VarriationConvenienceFee = VarriationConvenienceFee * currentValue;
            VarriationConvenienceFeeFlat = VarriationConvenienceFeeFlat * currentValue;
            
            [dict2 setObject:[NSString stringWithFormat:@"%i", currentValue] forKey:@"VarriationPaxCount"];
            NSLog(@"PaxCount: %i", currentValue);
            [dict2 setObject:[NSString stringWithFormat:@"%f", VarriationConvenienceFee] forKey:@"VarriationConvenienceFee"];
            [dict2 setObject:[NSString stringWithFormat:@"%i", VarriationConvenienceFeeFlat] forKey:@"VarriationConvenienceFeeFlat"];
        }
        {
            
            dict3 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict3 withCurrentValue:currentValue cell:sender]];
            
            dict4 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict4 withCurrentValue:currentValue cell:sender]];
            
        }
        
        [dict2 setObject:dict3 forKey:@"ExcursionVarriationPricing"];
        [dict setObject:dict2 forKey:@"ExcursionVarriations"];
        [dict setObject:dict4 forKey:@"ExcursionCatagoryPricing"];
        
//        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
        
        [self.delegate increaseClicked:self currentIndex:self.currentIndex onCellIndex:indexPath.row withCount:currentValue];
        
        
    }
    
    
}

-(void)decreaseButtonClicked:(AddOnTableViewCell *)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    int minCount = 1;
    
    int currentValue = sender.countLabel.text.intValue;
    
    if (currentValue > minCount) {
        currentValue--;
        
        sender.countLabel.text = [NSString stringWithFormat:@"%i", currentValue];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.staticArray[indexPath.row]];
        NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict[@"ExcursionVarriations"]];
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2[@"ExcursionVarriationPricing"]];
        NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithDictionary:dict[@"ExcursionCatagoryPricing"]];
        
        
        {
            double VarriationConvenienceFee = [dict2[@"VarriationConvenienceFee"] doubleValue];
            int VarriationConvenienceFeeFlat = [dict2[@"VarriationConvenienceFeeFlat"] intValue];
            VarriationConvenienceFee = VarriationConvenienceFee * currentValue;
            VarriationConvenienceFeeFlat = VarriationConvenienceFeeFlat * currentValue;
            
            [dict2 setObject:[NSString stringWithFormat:@"%i", currentValue] forKey:@"VarriationPaxCount"];
            [dict2 setObject:[NSString stringWithFormat:@"%f", VarriationConvenienceFee] forKey:@"VarriationConvenienceFee"];
            [dict2 setObject:[NSString stringWithFormat:@"%i", VarriationConvenienceFeeFlat] forKey:@"VarriationConvenienceFeeFlat"];
        }
        {
            
            dict3 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict3 withCurrentValue:currentValue cell:sender]];
            
            dict4 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict4 withCurrentValue:currentValue cell:sender]];
            
        }
        
        [dict2 setObject:dict3 forKey:@"ExcursionVarriationPricing"];
        [dict setObject:dict2 forKey:@"ExcursionVarriations"];
        [dict setObject:dict4 forKey:@"ExcursionCatagoryPricing"];
        
//        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
        
        [self.delegate decreaseClicked:self currentIndex:self.currentIndex onCellIndex:indexPath.row withCount:currentValue];
    }
}

-(void)checkBoxButtonClicked:(AddOnTableViewCell *)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSString *status;
    if ([sender.checkBoxButton.currentImage isEqual:[UIImage imageNamed:@"checked-red"]]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        [dict setObject:@"false" forKey:@"isSelected"];
        status = @"false";
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
        [sender.checkBoxButton setImage:[UIImage imageNamed:@"unchecked-red"] forState:UIControlStateNormal];
    }else {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        [dict setObject:@"true" forKey:@"isSelected"];
        status = @"true";
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dict];
        [sender.checkBoxButton setImage:[UIImage imageNamed:@"checked-red"] forState:UIControlStateNormal];
    }
    
    [self.delegate checkBoxClicked:self currentIndex:self.currentIndex onCellIndex:(NSInteger)indexPath.row isSelected:status];
}

-(NSMutableDictionary *)getCommonValuesDictionary:(NSMutableDictionary *)dict3 withCurrentValue:(int)currentValue cell:(AddOnTableViewCell *)sender {
    double PConvenienceFee = [dict3[@"PConvenienceFee"] doubleValue];
    double PServiceTax = [dict3[@"PServiceTax"] doubleValue];
    double TotalCommissionInSellingCurrency = [dict3[@"TotalCommissionInSellingCurrency"] doubleValue];
    double TotalDiscountInSellingCurrency = [dict3[@"TotalDiscountInSellingCurrency"] doubleValue];
    double TotalGrossRateInSellingCurrency = [dict3[@"TotalGrossRateInSellingCurrency"] doubleValue];
    NSLog(@"Gross Rate: %f", TotalGrossRateInSellingCurrency);
    double TotalTaxInSellingCurrency = [dict3[@"TotalTaxInSellingCurrency"] doubleValue];
    
    if (currentValue == 1) {
        
        sender.priceLabel.text = [NSString stringWithFormat:@"%@ %i", rupee, (int)TotalGrossRateInSellingCurrency];
    }else {
        
        sender.priceLabel.text = [NSString stringWithFormat:@"%@ %i x %i = %i", rupee, (int)TotalGrossRateInSellingCurrency, currentValue, (int)(TotalGrossRateInSellingCurrency * currentValue)];
    }
    
    PConvenienceFee = PConvenienceFee * currentValue;
    PServiceTax = PServiceTax * currentValue;
    TotalCommissionInSellingCurrency = TotalCommissionInSellingCurrency * currentValue;
    TotalDiscountInSellingCurrency = TotalDiscountInSellingCurrency * currentValue;
    TotalGrossRateInSellingCurrency = TotalGrossRateInSellingCurrency * currentValue;
    TotalTaxInSellingCurrency = TotalTaxInSellingCurrency * currentValue;
    
    
    NSLog(@"Gross Rate2: %f", TotalGrossRateInSellingCurrency);
    
    [dict3 setObject:[NSString stringWithFormat:@"%f", PConvenienceFee] forKey:@"PConvenienceFee"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", PServiceTax] forKey:@"PServiceTax"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalCommissionInSellingCurrency] forKey:@"TotalCommissionInSellingCurrency"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalDiscountInSellingCurrency] forKey:@"TotalDiscountInSellingCurrency"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalGrossRateInSellingCurrency] forKey:@"TotalGrossRateInSellingCurrency"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalTaxInSellingCurrency] forKey:@"TotalTaxInSellingCurrency"];
    
    return dict3;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
