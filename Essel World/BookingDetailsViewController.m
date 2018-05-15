//
//  BookingDetailsViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 06/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "BookingDetailsViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PaymentGatewayViewController.h"
#import "BookTicketsMainViewController.h"

@interface BookingDetailsViewController ()<UITextFieldDelegate, PaymentGatewayDelegate>
{
    NSMutableString *dateOfBirth;
    NSMutableString *confirmationIdString;
}
@property (weak, nonatomic) IBOutlet UIView *proceedToPayButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateOfBirthButton;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1TextField;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipPinCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *promoCodeTextField;
@end

@implementation BookingDetailsViewController

- (IBAction)backButtonClicked:(id)sender {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[BookTicketsMainViewController class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:controller
                                                      animated:YES];                
            });
            break;
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.scrollView setContentOffset:CGPointMake(0, textField.tag - 50) animated:true];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, textField.tag + self.view.frame.size.height - 50)];
    });
    return true;
}

-(void)resignKeyboard {
    [self.view endEditing:true];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dateOfBirth = [NSMutableString string];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserPaxDetails"]) {
        
        NSDictionary *userPaxDetails = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPaxDetails"]];
        self.firstNameTextField.text = userPaxDetails[@"LeadPax_First_Name"];
        self.middleNameTextField.text = userPaxDetails[@"LeadPax_Middle_Name"];
        self.lastNameTextField.text = userPaxDetails[@"LeadPax_Last_Name"];
        [self.dateOfBirthButton setTitle:userPaxDetails[@"DateOfBirth"] forState:UIControlStateNormal];
        dateOfBirth = [NSMutableString stringWithString:userPaxDetails[@"DateOfBirth"]];
        [self.dateOfBirthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.addressLine1TextField.text = userPaxDetails[@"Address1"];
        self.addressLine2TextField.text = userPaxDetails[@"Address2"];
        self.cityTextField.text = userPaxDetails[@"City"];
        self.stateTextField.text = userPaxDetails[@"State"];
        self.countryTextField.text = userPaxDetails[@"Country"];
        self.zipPinCodeTextField.text = userPaxDetails[@"Zip"];
    }
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.proceedToPayButton.frame.origin.y + 80)];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)proceedToPayButtonClicked:(id)sender {
    
    if ([self.firstNameTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"First Name"];
    }else if ([self.middleNameTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"Middle Name"];
    }else if ([self.lastNameTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"Last Name"];
    }else if ([dateOfBirth isEqualToString:@""]) {
        
        [self showErrorAlert:@"Date of Birth"];
    }else if ([self.addressLine1TextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"Address Line 1"];
    }else if ([self.addressLine2TextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"Address Line 2"];
    }else if ([self.cityTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"City"];
    }else if ([self.stateTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"State"];
    }else if ([self.countryTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"Country"];
    }else if ([self.countryTextField.text isEqualToString:@""]) {
        
        [self showErrorAlert:@"Zip or Pin Code"];
    }else {
        [self callReserveBookingOperationWebService];
    }
}


-(void)callReserveBookingOperationWebService {
    if ([Utilities isConnected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        
        [self reserveBookingOperationWebservice];
    }else {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
    
}

-(void)reserveBookingOperationWebservice {
    
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, reserveBookingOperation]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:80.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSMutableDictionary *paxDetails = [[NSMutableDictionary alloc] init];
    [paxDetails setObject:self.firstNameTextField.text forKey:@"LeadPax_First_Name"];
    [paxDetails setObject:self.middleNameTextField.text forKey:@"LeadPax_Middle_Name"];
    [paxDetails setObject:self.lastNameTextField.text forKey:@"LeadPax_Last_Name"];
    [paxDetails setObject:dateOfBirth forKey:@"DateOfBirth"];
    [paxDetails setObject:self.addressLine1TextField.text forKey:@"Address1"];
    [paxDetails setObject:self.addressLine2TextField.text forKey:@"Address2"];
    [paxDetails setObject:self.cityTextField.text forKey:@"City"];
    [paxDetails setObject:self.stateTextField.text forKey:@"State"];
    [paxDetails setObject:self.countryTextField.text forKey:@"Country"];
    [paxDetails setObject:self.zipPinCodeTextField.text forKey:@"Zip"];
    [paxDetails setObject:[dict valueForKey:@"mobile"] forKey:@"MobileNumber"];
    [paxDetails setObject:[dict valueForKey:@"email"] forKey:@"EmailId"];
    NSMutableArray *editedAddons = [[NSMutableArray alloc] init];
    NSMutableDictionary *editedAddOnDict = [[NSMutableDictionary alloc] init];
    if (self.selectedAddons.count == 0) {
        
        [paxDetails setObject:@"N" forKey:@"AddonsIncluded"];
    }else {
        
        [paxDetails setObject:@"Y" forKey:@"AddonsIncluded"];
        if ([self.countArray isEqualToString:@"1"] && self.selectedAddons.count == 1) {
            
            [editedAddOnDict setObject:self.selectedAddons[0] forKey:@"SelectedAddonCatagory"];
        }else {
            
            for (int i = 0; i < self.selectedAddons.count; i++) {
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc]init];
                [newDict setObject:self.searchDict forKey:@"QueryExcursionItem"];
                [newDict setObject:self.selectedAddons[i] forKey:@"SelectedAddonCatagory"];
                [editedAddons addObject:newDict];
            }
        }
        
    }
    
    [paxDetails setObject:@"" forKey:@"PromotionCode"];
    
    [[NSUserDefaults standardUserDefaults]setObject:paxDetails forKey:@"UserPaxDetails"];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionId"];
    
    NSDictionary *excursionSelection = [NSDictionary dictionaryWithObjectsAndKeys:self.dataDict, @"ExcursionCatagory", nil];
    
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"QueryExcursionItem", @"ExcursionPaxDetails", @"ExcursionSelection", @"SessionID", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: self.searchDict, paxDetails, excursionSelection, sessionId,nil];
    
    NSMutableDictionary * jsondic=[NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    if (editedAddons.count != 0) {
        
        [jsondic setObject:editedAddons forKey:@"AddonCatagorySelection"];
    }else if (editedAddOnDict.allKeys.count != 0) {
        [jsondic setObject:editedAddOnDict forKey:@"AddonCatagorySelection"];
    }
    
    NSLog(@"PostReserveData: %@", jsondic);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Json: %@", json);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if ([json[@"Response"][@"Result"][@"StatusText"]  isEqualToString:@"SUCCESS"]) {
                
//                [self getRSAKeyWebservice:json[@"Response"][@"Result"][@"ExcursionBookingResponse"][@"ConfirmationID"] withAmount:json[@"Response"][@"Result"][@"ExcursionBookingResponse"][@"UpdatedExcursionPricing"][@"TotalGrossRateInSellingCurrency"]];
                
                confirmationIdString = json[@"Response"][@"Result"][@"ExcursionBookingResponse"][@"ConfirmationID"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    PaymentGatewayViewController *paymentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentGatewayViewController"];
                    paymentVC.orderID = json[@"Response"][@"Result"][@"ExcursionBookingResponse"][@"ConfirmationID"];
//                    paymentVC.amount = amount;
//                    paymentVC.rsaKey = rsaKey;
                    paymentVC.delegate = self;
                    [self.navigationController pushViewController:paymentVC animated:true];
                });
                
                
            }else {
                NSString *jsonString=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 NSLog(@"Json: %@", jsonString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message: json[@"Response"][@"Result"][@"Error"][@"ErrorText"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
        }
    }];
    
    [postDataTask resume];
}

-(void)getRSAKeyWebservice:(NSString *)confirmationID withAmount:(NSString *)amount {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSString *orderId = confirmationID;
    confirmationIdString = [NSMutableString stringWithString:confirmationID];
    NSString *rsaKeyDataStr = [NSString stringWithFormat:@"access_code=%@&order_id=%@",accessCode,orderId];
    NSData *requestData = [NSData dataWithBytes: [rsaKeyDataStr UTF8String] length: [rsaKeyDataStr length]];
    NSMutableURLRequest *rsaRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: getRSAKey]];
    [rsaRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [rsaRequest setHTTPMethod: @"POST"];
    [rsaRequest setHTTPBody: requestData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:rsaRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (data != nil) {
            
            NSString *rsaKey = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            rsaKey = [rsaKey stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            rsaKey = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----\n",rsaKey];
            NSLog(@"%@",rsaKey);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                PaymentGatewayViewController *paymentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentGatewayViewController"];
                paymentVC.orderID = orderId;
//                paymentVC.amount = amount;
//                paymentVC.rsaKey = rsaKey;
                paymentVC.delegate = self;
                [self.navigationController pushViewController:paymentVC animated:true];
            });
            
            
        }
        
    }];
    
    [postDataTask resume];
}

-(void)showErrorAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Please enter %@", message] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:NO completion:nil];
}

-(void)paymentStatus:(NSString *)status sender:(PaymentGatewayViewController *)sender {
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        
        if ([status isEqualToString:@"Transaction Cancelled"]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your transaction was cancelled!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
        }else if ([status isEqualToString:@"Transaction Successful"]) {
            
            [self callBookingOperationWebService];
        }else if ([status isEqualToString:@"Transaction Failed"]) {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your transaction was failed!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
        }
    }];
    
    [sender.navigationController popViewControllerAnimated:true];
    
    [CATransaction commit];
    
    
}

-(void)callBookingOperationWebService {
    if ([Utilities isConnected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        
        
//        [self bookingOperationWebservice];
        [self updateBooking];
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
    
}

-(void)bookingOperationWebservice {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, bookingOperationApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionId"];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"SessionID", @"ConfirmationID", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: sessionId, confirmationIdString, nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"Result"][@"StatusText"]  isEqualToString:@"SUCCESS"]) {
                
                [self updateBooking];
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

-(void)updateBooking {
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, userBookingApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *type;
    if ([self.from isEqualToString:@"EsselWorld"]) {
        type = @"1";
    }else if ([self.from isEqualToString:@"WaterKingdom"]) {
        type = @"2";
    }else {
        type = @"3";
    }
    NSString *ticketType = [self.ticketType stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"ConfirmationID", @"regId", @"type", @"ticketType", @"bookingDate", @"totalPax", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: confirmationIdString, [dict valueForKey:@"regId"], type, ticketType, self.searchDict[@"DateOFVisit"], self.totalPax, nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your transaction was successful. You can access the ticket in your Booking History" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popToRootViewControllerAnimated:true];
                        
                    });
                    
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

- (IBAction)dateButtonClicked:(id)sender {
    
    [self.view endEditing:true];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSDate *date = picker.date;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"dd/MM/yyyy";
            dateOfBirth = [NSMutableString stringWithString:[dateFormatter stringFromDate:date]];
            
            [self.dateOfBirthButton setTitle:dateOfBirth forState:UIControlStateNormal];
            [self.dateOfBirthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        }];
        action;
    })];
    UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    popoverController.sourceView = sender;
    popoverController.sourceRect = [sender bounds];
    [self presentViewController:alertController  animated:YES completion:nil];
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
