//
//  EventsOffersPromotionsViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 15/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "EventsOffersPromotionsViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AddOnCollectionViewCell.h"
#import "EventsChildViewController.h"

@interface EventsOffersPromotionsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
@end

@implementation EventsOffersPromotionsViewController

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated: true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc]init];
    self.viewControllerArray = [[NSMutableArray alloc]init];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if ([self.from isEqualToString:@"Events"]) {
        self.titleLabel.text = @"Events";
    }else if ([self.from isEqualToString:@"Offers"]) {
        self.titleLabel.text = @"Promotions & Offers";
    }else {
        self.titleLabel.text = @"Groups & Schools";
    }
    
    [self callDataWebService];
}

-(void)callDataWebService {
    if ([Utilities isConnected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        [self dataWebservice];
    }else {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
    
}

-(void)dataWebservice {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSString *urlString;
    if ([self.from isEqualToString:@"Events"]) {
        
        urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, getEventsApi];
    }else if ([self.from isEqualToString:@"Offers"]) {
        
        urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, getOffersApi];
    }else {
        
        urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, getSchoolsApi];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                self.dataArray = [NSMutableArray arrayWithArray:json[@"Response"][@"Result"]];
                if (self.dataArray.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"No Events available!" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentViewController:alertController animated:NO completion:nil];
                    });
                }else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        for (int i = 0; i < self.dataArray.count; i++) {
                            
                            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
                            if (i == 0) {
                                
                                [dict setObject:@"true" forKey:@"isSelected"];
                            }else {
                                
                                [dict setObject:@"false" forKey:@"isSelected"];
                            }
                            
                            [self.dataArray replaceObjectAtIndex:i withObject:dict];
                            
                            
                            EventsChildViewController *eventsChildViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsChildViewController"];
                            eventsChildViewController.view.frame = self.mainView.bounds;
                            eventsChildViewController.dataDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
                            eventsChildViewController.from = self.from;
                            
                            [self.viewControllerArray addObject:eventsChildViewController];
                            
                        }
                        
                        
                        EventsChildViewController *eventsChildViewController = self.viewControllerArray[0];
                        [self addChildViewController:eventsChildViewController];
                        [self.mainView addSubview:eventsChildViewController.view];
                        [eventsChildViewController didMoveToParentViewController:self];
                        
                        [self.collectionView reloadData];
                        
                    });
                    
                    
                }
                
            }else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self callDataWebService];
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
        }
    }];
    [postDataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDelegate & Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddOnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.categoryLabel.text = self.dataArray[indexPath.item][@"title"];
    if ([self.dataArray[indexPath.item][@"isSelected"] isEqualToString:@"true"]) {
        
        [self setSelectedColorForLabel:cell.categoryLabel];
    }else {
        
        [self setUnselectedColorForLabel:cell.categoryLabel];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
        
        if (i == indexPath.item) {
            
            [dict setObject:@"true" forKey:@"isSelected"];
        }else {
            
            [dict setObject:@"false" forKey:@"isSelected"];
        }
        
        [self.dataArray replaceObjectAtIndex:i withObject:dict];
        
        EventsChildViewController *eventsChildViewController = self.viewControllerArray[i];
            if (i == indexPath.item){
            [self addChildViewController:eventsChildViewController];
            [self.mainView addSubview:eventsChildViewController.view];
            [eventsChildViewController didMoveToParentViewController:self];
        }else if ([eventsChildViewController isViewLoaded]) {
            [eventsChildViewController.view removeFromSuperview];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
