//
//  AddOnViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 12/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "AddOnViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "AddOnCollectionViewCell.h"
#import "AddOnTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BookingDetailsViewController.h"


@interface AddOnViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddOnTableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* addOnsArray;
@property (strong, nonatomic) NSArray* staticArray;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@end

@implementation AddOnViewController

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addOnsArray = [[NSMutableArray alloc] init];
    self.viewControllerArray = [[NSMutableArray alloc]init];
    [self callAddOnWebService];
}

-(void)callAddOnWebService {
    if ([Utilities isConnected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        [self addOnWebservice];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

-(void)addOnWebservice {
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, addOnApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionId"];
    
    
    NSMutableDictionary * jsondic=[NSMutableDictionary dictionaryWithDictionary:self.searchDictionary];
    [jsondic setObject:self.sourceRefId forKey:@"Source_ref"];
    [jsondic setObject:self.selectedCategory[@"CategoryUID"] forKey:@"CategoryUID"];
    [jsondic setObject:sessionId forKey:@"SessionID"];
    
    NSLog(@"PostAddOn: %@", jsondic);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (data != nil) {
            
            [self sortArrayWithData:data];
        }
        
    }];
    
    [postDataTask resume];
}

-(void)sortArrayWithData:(NSData *)data {
    
    NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"AddOn: %@", json);
    
    if ([json[@"Response"][@"Result"][@"StatusText"]  isEqualToString:@"SUCCESS"]) {
        NSArray *excursionCatagoryArray;
        if ([json[@"Response"][@"Result"][@"ExcursionCatagory"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *excursionCategoryDict = [NSDictionary dictionaryWithDictionary:json[@"Response"][@"Result"][@"ExcursionCatagory"]];
            excursionCatagoryArray = [NSArray arrayWithObject:excursionCategoryDict];
            
        }else {
            
            excursionCatagoryArray = [NSArray arrayWithArray:json[@"Response"][@"Result"][@"ExcursionCatagory"]];
        }
        
        
        NSLog(@"%@",excursionCatagoryArray);
        
        
        for (int i = 0; i < excursionCatagoryArray.count; i++) {
            
            if (self.addOnsArray.count == 0) {
                BOOL countAllowed = false;
                NSMutableDictionary *currentData = [[NSMutableDictionary alloc] init];
                for (int j = 0; j < [excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"]count]; j++) {
                    if ([excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Key"] isEqualToString:@"MAX_ADDON_COUNT_ALLOWED"]) {
                        
                        if ([excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Value"] isEqualToString:@"0"]) {
                            
                            countAllowed = false;
                        }else {
                            countAllowed = true;
                        }
                    }
                    if ([excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Key"] isEqualToString:@"CATEGORY_GROUP_NAME"]) {
                        
                        [currentData setObject:excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Value"] forKey:@"CategoryName"];
                        
                        NSMutableDictionary *isSelectedDict = [NSMutableDictionary dictionaryWithDictionary:excursionCatagoryArray[i]];
                        [isSelectedDict setObject:@"false" forKey:@"isSelected"];
                        
                        NSMutableArray *tempArray = [NSMutableArray arrayWithObject:isSelectedDict];
                        [currentData setObject:tempArray forKey:@"Data"];
                        [currentData setObject:@"true" forKey:@"isSelected"];
                        
                    }
                    
                    if (currentData.allKeys.count > 0 && countAllowed) {
                        [self.addOnsArray addObject:currentData];
                    }
                    
                }
                
            }else {
                
                NSMutableDictionary *currentData = [[NSMutableDictionary alloc] init];
                
                for (int j = 0; j < [excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"] count]; j++) {
                    
                    if ([excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Key"] isEqualToString:@"CATEGORY_GROUP_NAME"]) {
                        
                        BOOL replaced = false;
                        BOOL countAllowed = false;
                        
                        if ([excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Key"] isEqualToString:@"MAX_ADDON_COUNT_ALLOWED"]) {
                            
                            if ([excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Value"] isEqualToString:@"0"]) {
                                
                                countAllowed = false;
                            }else {
                                countAllowed = true;
                            }
                        }
                        
                        for (int k = 0; k < self.addOnsArray.count; k++) {
                            
                            if ([self.addOnsArray[k][@"CategoryName"] isEqualToString:excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Value"]]) {
                                
                                replaced = true;
                                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.addOnsArray[k][@"Data"]];
                                
                                
                                NSMutableDictionary *isSelectedDict = [NSMutableDictionary dictionaryWithDictionary:excursionCatagoryArray[i]];
                                [isSelectedDict setObject:@"false" forKey:@"isSelected"];
                                
                                [tempArray addObject:isSelectedDict];
                                
                                NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:self.addOnsArray[k]];
                                
                                [tempDict setObject:tempArray forKey:@"Data"];
//                                [currentData setObject:@"false" forKey:@"isSelected"];
                                [self.addOnsArray replaceObjectAtIndex:k withObject:tempDict];
                                
                            }
                        }
                        
                        if (replaced == false) {
                            
                            [currentData setObject:excursionCatagoryArray[i][@"MiscellaneousCategoryInfo"][j][@"Value"] forKey:@"CategoryName"];
                            
                            
                            NSMutableDictionary *isSelectedDict = [NSMutableDictionary dictionaryWithDictionary:excursionCatagoryArray[i]];
                            [isSelectedDict setObject:@"false" forKey:@"isSelected"];
                            
                            NSMutableArray *tempArray = [NSMutableArray arrayWithObject:isSelectedDict];
                            [currentData setObject:tempArray forKey:@"Data"];
                            
                            [currentData setObject:@"false" forKey:@"isSelected"];
                            [self.addOnsArray addObject:currentData];
                            
                        }
                    }
                }
            }
        }
        
        
        NSLog(@"%@", self.addOnsArray);
        self.staticArray = [NSArray arrayWithArray:self.addOnsArray];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.collectionView reloadData];
            
            if (self.addOnsArray.count > 0) {
                
                for (int i = 0; i < self.addOnsArray.count; i++) {
                    AddOnTableViewController *addOnTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddOnTableViewController"];
                    addOnTableViewController.view.frame = self.mainView.bounds;
                    addOnTableViewController.dataArray = self.addOnsArray[i][@"Data"];
                    addOnTableViewController.staticArray = self.staticArray[i][@"Data"];
                    addOnTableViewController.currentIndex = [NSMutableString stringWithFormat:@"%i", i];
                    addOnTableViewController.delegate = self;
                    
                    [self.viewControllerArray addObject:addOnTableViewController];
                }
                AddOnTableViewController *addOnTableViewController = self.viewControllerArray[0];
                [self addChildViewController:addOnTableViewController];
                [self.mainView addSubview:addOnTableViewController.view];
                //            regularTicketsVC.delegate = self;
                [addOnTableViewController didMoveToParentViewController:self];
            }
        });
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertController * alert=[UIAlertController
                                       
                                       alertControllerWithTitle:@"" message:@"No Add Ons Available For This Ticket."preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Proceed"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                              [self proceedToPayment];
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Back"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                             [self.navigationController popViewControllerAnimated:true];
                                           
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];        });
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate & Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.addOnsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddOnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.categoryLabel.text = self.addOnsArray[indexPath.item][@"CategoryName"];
    if ([self.addOnsArray[indexPath.item][@"isSelected"] isEqualToString:@"true"]) {
        
        [self setSelectedColorForLabel:cell.categoryLabel];
    }else {
        
        [self setUnselectedColorForLabel:cell.categoryLabel];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    
    
    for (int i = 0; i < self.addOnsArray.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.addOnsArray[i]];
        
        if (i == indexPath.item) {
            
            [dict setObject:@"true" forKey:@"isSelected"];
        }else {
            
            [dict setObject:@"false" forKey:@"isSelected"];
        }
        
        [self.addOnsArray replaceObjectAtIndex:i withObject:dict];
        
        
        AddOnTableViewController *addOnTableViewController = self.viewControllerArray[i];
        
        
        if (i == indexPath.item){
            
            [self addChildViewController:addOnTableViewController];
            [self.mainView addSubview:addOnTableViewController.view];
            [addOnTableViewController didMoveToParentViewController:self];
        }else if ([addOnTableViewController isViewLoaded]) {
            
            [addOnTableViewController.view removeFromSuperview];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
    });
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width / 3, 49);
}


#pragma mark - Helper Methods
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

#pragma mark - AddOnTableViewDelegate
-(void)increaseClicked:(AddOnTableViewController *)sender currentIndex:(NSString *)index onCellIndex:(NSInteger)cellIndex withCount:(int)currentValue {
    NSMutableDictionary *categoryDict = [NSMutableDictionary dictionaryWithDictionary:self.staticArray[index.integerValue]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:categoryDict[@"Data"]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[cellIndex]];
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
        
        dict3 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict3 withCurrentValue:currentValue]];
        
        dict4 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict4 withCurrentValue:currentValue]];
        
    }
    
    [dict2 setObject:dict3 forKey:@"ExcursionVarriationPricing"];
    [dict setObject:dict2 forKey:@"ExcursionVarriations"];
    [dict setObject:dict4 forKey:@"ExcursionCatagoryPricing"];
    
    [array replaceObjectAtIndex:cellIndex withObject:dict];
    
    [categoryDict setObject:array forKey:@"Data"];
    [self.addOnsArray replaceObjectAtIndex:index.integerValue withObject:categoryDict];
    
}

-(void)decreaseClicked:(AddOnTableViewController *)sender currentIndex:(NSString *)index onCellIndex:(NSInteger)cellIndex withCount:(int)currentValue {
    NSMutableDictionary *categoryDict = [NSMutableDictionary dictionaryWithDictionary:self.staticArray[index.integerValue]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:categoryDict[@"Data"]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[cellIndex]];
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
        
        dict3 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict3 withCurrentValue:currentValue]];
        
        dict4 = [NSMutableDictionary dictionaryWithDictionary:[self getCommonValuesDictionary:dict4 withCurrentValue:currentValue]];
        
    }
    
    [dict2 setObject:dict3 forKey:@"ExcursionVarriationPricing"];
    [dict setObject:dict2 forKey:@"ExcursionVarriations"];
    [dict setObject:dict4 forKey:@"ExcursionCatagoryPricing"];
    
    [array replaceObjectAtIndex:cellIndex withObject:dict];
    
    [categoryDict setObject:array forKey:@"Data"];
    [self.addOnsArray replaceObjectAtIndex:index.integerValue withObject:categoryDict];
}

-(void)checkBoxClicked:(AddOnTableViewController *)sender currentIndex:(NSString *)index onCellIndex:(NSInteger)cellIndex isSelected:(NSString *)status {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.addOnsArray[index.integerValue]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:dict[@"Data"]];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:array[cellIndex]];
    
    [dict2 setObject:status forKey:@"isSelected"];
    [array replaceObjectAtIndex:cellIndex withObject:dict2];
    [dict setObject:array forKey:@"Data"];
    [self.addOnsArray replaceObjectAtIndex:index.integerValue withObject:dict];
    
}

-(NSMutableDictionary *)getCommonValuesDictionary:(NSMutableDictionary *)dict3 withCurrentValue:(int)currentValue {
    double PConvenienceFee = [dict3[@"PConvenienceFee"] doubleValue];
    double PServiceTax = [dict3[@"PServiceTax"] doubleValue];
    double TotalCommissionInSellingCurrency = [dict3[@"TotalCommissionInSellingCurrency"] doubleValue];
    double TotalDiscountInSellingCurrency = [dict3[@"TotalDiscountInSellingCurrency"] doubleValue];
    double TotalGrossRateInSellingCurrency = [dict3[@"TotalGrossRateInSellingCurrency"] doubleValue];
    double TotalTaxInSellingCurrency = [dict3[@"TotalTaxInSellingCurrency"] doubleValue];
    
    PConvenienceFee = PConvenienceFee * currentValue;
    PServiceTax = PServiceTax * currentValue;
    TotalCommissionInSellingCurrency = TotalCommissionInSellingCurrency * currentValue;
    TotalDiscountInSellingCurrency = TotalDiscountInSellingCurrency * currentValue;
    TotalGrossRateInSellingCurrency = TotalGrossRateInSellingCurrency * currentValue;
    TotalTaxInSellingCurrency = TotalTaxInSellingCurrency * currentValue;
    
    
    [dict3 setObject:[NSString stringWithFormat:@"%f", PConvenienceFee] forKey:@"PConvenienceFee"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", PServiceTax] forKey:@"PServiceTax"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalCommissionInSellingCurrency] forKey:@"TotalCommissionInSellingCurrency"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalDiscountInSellingCurrency] forKey:@"TotalDiscountInSellingCurrency"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalGrossRateInSellingCurrency] forKey:@"TotalGrossRateInSellingCurrency"];
    [dict3 setObject:[NSString stringWithFormat:@"%f", TotalTaxInSellingCurrency] forKey:@"TotalTaxInSellingCurrency"];
    
    return dict3;
}

- (IBAction)proceedToPayClicked:(id)sender {
        [self proceedToPayment];
  }

-(void) proceedToPayment {
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.addOnsArray.count; i++) {
        for (int j = 0; j < [self.addOnsArray[i][@"Data"] count]; j++) {
            if ([self.addOnsArray[i][@"Data"][j][@"isSelected"] isEqualToString:@"true"]) {
                [selectedArray addObject:self.addOnsArray[i][@"Data"][j]];
            }
        }
    }
    NSLog(@"%lu",(unsigned long)selectedArray.count);
    NSLog(@"%@", selectedArray);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BookingDetailsViewController *bookingDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingDetailsViewController"];
        bookingDetailsViewController.searchDict = self.searchDictionary;
        bookingDetailsViewController.dataDict = self.selectedCategory;
        bookingDetailsViewController.from = self.categoryName;
        bookingDetailsViewController.selectedAddons = selectedArray;
        bookingDetailsViewController.ticketType = self.ticketType;
        bookingDetailsViewController.countArray = [NSString stringWithFormat:@"%i", (int)self.addOnsArray.count];
        bookingDetailsViewController.totalPax = self.totalPax;
        
        if ([selectedArray count] == 0)
        {
            
        }
        
        [self.navigationController pushViewController:bookingDetailsViewController animated:true];
    });

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
