//
//  BarcodeViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 15/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "BarcodeViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"


@interface BarcodeViewController ()<AuthenticationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBookingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfVisitLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfTicketLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBookingButton;
@end

@implementation BarcodeViewController

- (IBAction)backButton:(id)sender {
    if ([self.from isEqualToString:@"Booking History"]) {
        
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.from isEqualToString:@"Booking History"]) {
        self.noteLabel.hidden = true;
    }
    
    if ([self.dataDict[@"type"] isEqualToString:@"1"]) {
        self.titleLabel.text = @"EsselWorld";
    }else if ([self.dataDict[@"type"] isEqualToString:@"2"]) {
        self.titleLabel.text = @"Water Kingdom";
    }else {
        self.titleLabel.text = @"DownTown";
    }
    
    
    NSString *ticketType = [self.dataDict[@"ticket_type"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    self.typeOfTicketLabel.text = ticketType;
    self.bookingIdLabel.text = self.dataDict[@"ConfirmationId"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *createdDate = [dateFormatter dateFromString:self.dataDict[@"createdDate"]];
    NSDate *bookingDate = [dateFormatter dateFromString:self.dataDict[@"booked_ticket"]];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    self.dateOfVisitLabel.text = [dateFormatter stringFromDate:bookingDate];
    self.dateOfBookingLabel.text = [dateFormatter stringFromDate:createdDate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.barCodeImageView.image = [UIImage imageWithCIImage:[self generateBarcode:self.bookingIdLabel.text]];
    });
    
    NSString *ticketDateString = self.dataDict[@"booked_ticket"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [formatter dateFromString:ticketDateString];
    
    if ([self.dataDict[@"isCancel"] isEqualToString:@"1"] || [date timeIntervalSinceNow] < 0.0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.cancelBookingButton.hidden = true;
        });
    }
    
}

-(CIImage*)generateBarcode:(NSString*)dataString{
    
    CIFilter *barCodeFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *barCodeData = [dataString dataUsingEncoding:NSASCIIStringEncoding];
    [barCodeFilter setValue:barCodeData forKey:@"inputMessage"];
    [barCodeFilter setValue:[NSNumber numberWithFloat:0] forKey:@"inputQuietSpace"];
    
    CIImage *barCodeImage = barCodeFilter.outputImage;
    return barCodeImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBooking:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure, you want to cancel the transaction?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self callCancelBookingWebservice];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:NO completion:nil];
}

-(void)callCancelBookingWebservice {
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"SessionId"] isEqualToString:@"0"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        appDelegate.delegate = self;
        appDelegate.functionType = @"BookTicketsProceed";
        [appDelegate callAuthenticationWebService];
    }else {
        
        if ([Utilities isConnected]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view endEditing:true];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
            
            [self cancelBookingWebservice];
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
            
        }
    }
    
}

-(void)authenticationResult:(BOOL)success fromFunction:(NSString *)functionType{
    
//    [MBProgressHUD hideHUDForView:self.view animated:true];
    if (success) {
        
        
        [self cancelBookingWebservice];
    }
}

-(void)cancelBookingWebservice {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, cancelOperationApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"SessionID", @"ConfirmationID", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: [[NSUserDefaults standardUserDefaults]objectForKey:@"SessionId"], self.bookingIdLabel.text,nil];
    
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSLog(@"Cancel Operation Request: %@", jsondic);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"Cancel Operation Response: %@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"success"]) {
                
                if ([json[@"Response"][@"Result"][@"StatusText"] isEqualToString:@"FAILURE"]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again later" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentViewController:alertController animated:NO completion:nil];
                    });
                }else {
                    
                    [self cancelBookingFromKweb];
                    
                }
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

-(void)cancelBookingFromKweb {
    NSError *error;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:cancelBookingKweb];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSArray * objects=[[NSArray alloc]initWithObjects: self.dataDict[@"regId"], self.dataDict[@"ConfirmationId"] , nil];
    NSArray * keys=[[NSArray alloc]initWithObjects:@"regId", @"ticket",nil];
    
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cancelBookingButton.hidden = true;
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.bookingHistoryContext.dataArray[self.indexOfData.intValue]];
                    
                    [dict setObject:@"1" forKey:@"isCancel"];
                    
                    [self.bookingHistoryContext.dataArray replaceObjectAtIndex:self.indexOfData.intValue withObject:dict];
                });
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Booking cancelled successfully" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
            
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again later" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:alertController animated:NO completion:nil];
            });
        }
        
    }];
    
    [postDataTask resume];
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
