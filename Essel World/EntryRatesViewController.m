//
//  EntryRatesViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 07/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "EntryRatesViewController.h"
#import "EntryRatesTableViewCell.h"
#import "Utilities.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface EntryRatesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@end

@implementation EntryRatesViewController

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.categoriesArray = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self callEntryRatesWebservice];
}

-(void)callEntryRatesWebservice {
    
    if ([Utilities isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:true];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        [self entryRatesWebservice];
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
}

-(void)entryRatesWebservice {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, getEntryRatesApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                
                if (json[@"Response"][@"Result"][@"esselworld"]) {
                    
                    if ([json[@"Response"][@"Result"][@"esselworld"] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"][@"esselworld"]];
                        [dict setObject:@"EsselWorld" forKey:@"title"];
                        [self.categoriesArray addObject:dict];
                    }
                } if (json[@"Response"][@"Result"][@"waterkingdom"]) {
                    
                    if ([json[@"Response"][@"Result"][@"waterkingdom"] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"][@"waterkingdom"]];
                        [dict setObject:@"Water Kingdom" forKey:@"title"];
                        [self.categoriesArray addObject:dict];
                    }
                } if (json[@"Response"][@"Result"][@"downtown"]) {
                    
                    if ([json[@"Response"][@"Result"][@"downtown"] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"][@"downtown"]];
                        [dict setObject:@"DownTown" forKey:@"title"];
                        [self.categoriesArray addObject:dict];
                    }
                } if (json[@"Response"][@"Result"][@"combine"]) {
                    
                    if ([json[@"Response"][@"Result"][@"combine"] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"][@"combine"]];
                        [dict setObject:@"Combined Ticket (Water Kingdom + Essel World)" forKey:@"title"];
                        [self.categoriesArray addObject:dict];
                    }
                }
                if (json[@"Response"][@"Result"][@"passport"]) {
                    
                    if ([json[@"Response"][@"Result"][@"combine"] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"][@"passport"]];
                        [dict setObject:@"Annual Passport" forKey:@"title"];
                        [self.categoriesArray addObject:dict];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoriesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryRatesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.categoriesArray[indexPath.row][@"title"];
    
    if (self.categoriesArray[indexPath.row][@"1"]) {
        
        cell.adultPriceLabel.text = self.categoriesArray[indexPath.row][@"1"];
    }else {
        
        cell.adultPriceLabel.text = @"";
    }
    
    if (self.categoriesArray[indexPath.row][@"2"]) {
        
        cell.childPriceLabel.text = self.categoriesArray[indexPath.row][@"2"];
    }else {
        
        cell.childPriceLabel.text = @"";
    }
    
    if (self.categoriesArray[indexPath.row][@"3"]) {
        
        cell.srCitizenPriceLabel.text = self.categoriesArray[indexPath.row][@"3"];
    }else {
        
        cell.srCitizenPriceLabel.text = @"N/A";
    }
    
    return cell;
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
