//
//  BookingHistoryViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 14/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "BookingHistoryViewController.h"
#import "BookingHistoryTableViewCell.h"
#import "Constants.h"
#import "Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BarcodeViewController.h"

@interface BookingHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BookingHistoryViewController

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self callBookingHistoryWebservice];
}

-(void)callBookingHistoryWebservice {
    if ([Utilities isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:true];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        [self bookingHistoryWebservice];
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
}

-(void)bookingHistoryWebservice {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, bookingHistoryApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *loginData = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"regId", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: loginData[@"regId"], nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                
                self.dataArray = [NSMutableArray arrayWithArray:json[@"Response"][@"Result"]];
                
                if (self.dataArray.count == 0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You haven't booked any tickets yet!" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:NO completion:nil];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView reloadData];
                    });
                }
                
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self callBookingHistoryWebservice];
                }]];
                [self presentViewController:alertController animated:NO completion:nil];
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookingHistoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
        cell.titleLabel.text = @"EsselWorld";
    }else if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"2"]) {
        cell.titleLabel.text = @"Water Kingdom";
    }else {
        cell.titleLabel.text = @"DownTown";
    }
    
    
    NSString *ticketType = [self.dataArray[indexPath.row][@"ticket_type"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    cell.typeOfTicket.text = ticketType;
    cell.bookingID.text = self.dataArray[indexPath.row][@"ConfirmationId"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *createdDate = [dateFormatter dateFromString:self.dataArray[indexPath.row][@"createdDate"]];
    NSDate *bookingDate = [dateFormatter dateFromString:self.dataArray[indexPath.row][@"booked_ticket"]];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    cell.dateOfVisit.text = [dateFormatter stringFromDate:bookingDate];
    cell.dateOfBooking.text = [dateFormatter stringFromDate:createdDate];
    cell.cellView.layer.masksToBounds = NO;
    cell.cellView.layer.shadowOffset = CGSizeMake(-3, 5);
    cell.cellView.layer.shadowRadius = 5;
    cell.cellView.layer.shadowOpacity = 0.5;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    BarcodeViewController *barcodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BarcodeViewController"];
    barcodeViewController.dataDict = self.dataArray[indexPath.row];
    barcodeViewController.from = @"Booking History";
    barcodeViewController.bookingHistoryContext = self;
    barcodeViewController.indexOfData = [NSString stringWithFormat:@"%i", (int)indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController pushViewController:barcodeViewController animated:true];
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
