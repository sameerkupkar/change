//
//  BookingTicketsFirstViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 17/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "BookingTicketsFirstViewController.h"
#import "RegularTicketsViewController.h"
#import <THDatePickerViewController.h>
#import "AppDelegate.h"
#import "SAPexcursionSOAPSoapBinding.h"
#import "SAPSoapError.h"
#import "Constants.h"
#import "Utilities.h"
#import "SAPQueryExcursionOperation.h"
#import "SAPQueryExcursionOperationBody.h"
#import "SAPExcursionOperationResponseBody.h"
#import "SAPSearchOperationResponse.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SAPExcursionOperationResponse.h"
#import "SAPExcursionOperationResponse.h"
#import "SAPArrayOfExcursionCatagoryDetails.h"
#import "BookTicketsMainViewController.h"

@interface BookingTicketsFirstViewController ()<THDatePickerDelegate, AuthenticationDelegate>
{
    int adultCount, childCount, srCitizenCount, collegeStudentCount;
    NSString *serviceType;
}
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UIView *srCitizenView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *calendarLayerView;
@property (weak, nonatomic) IBOutlet UILabel *adultCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *childCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *srCitizenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeStudentCountLabel;
@property (strong, nonatomic) THDatePickerViewController *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSMutableDictionary *dictData;
@property (strong, nonatomic) NSMutableDictionary *searchData;
@property (strong, nonatomic) RegularTicketsViewController *regularTicketVc;

@end

@implementation BookingTicketsFirstViewController

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dictData = [[NSMutableDictionary alloc]init];
    self.searchData = [[NSMutableDictionary alloc]init];
    adultCount = 0;
    childCount = 0;
    srCitizenCount = 0;
    collegeStudentCount = 0;
    self.calendarLayerView.layer.borderWidth = 0.5;
    self.calendarLayerView.layer.borderColor = [UIColor colorWithRed:31.0/255.0
                                                               green:137.0/255.0
                                                                blue:182.0/255.0
                                                               alpha:1.0].CGColor;
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = nextDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableHistorySelection:YES];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        if(tmp % 5 == 0)
            return YES;
        return NO;
    }];
    
//    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd/MM/yy";
    self.dateLabel.text = [formatter stringFromDate:nextDate];
    
    if ([self.from isEqualToString:@"EsselWorld"]) {
        serviceType = @"0";
        self.titleLabel.text = self.from;
    }else if ([self.from isEqualToString:@"WaterKingdom"]) {
        serviceType = @"1";
        self.titleLabel.text = @"Water Kingdom";
    }else {
        serviceType = @"2";
        self.titleLabel.text = self.from;
        self.childView.hidden = true;
        self.srCitizenView.hidden = true;
    }
}

- (IBAction)increaseButton:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        adultCount++;
        self.adultCountLabel.text = [NSString stringWithFormat:@"%i", adultCount];
    }if (sender.tag == 2) {
        
        childCount++;
        self.childCountLabel.text = [NSString stringWithFormat:@"%i", childCount];
    }if (sender.tag == 3) {
        
        srCitizenCount++;
        self.srCitizenCountLabel.text = [NSString stringWithFormat:@"%i", srCitizenCount];
    }if (sender.tag == 4) {
        
        collegeStudentCount++;
        self.collegeStudentCountLabel.text = [NSString stringWithFormat:@"%i", collegeStudentCount];
    }
}

- (IBAction)decreaseButton:(UIButton *)sender {
    if (sender.tag == 1) {
        
        if ([self checkCountAndShowAlert:adultCount]) {
            
            adultCount--;
            self.adultCountLabel.text = [NSString stringWithFormat:@"%i", adultCount];
        }
    }if (sender.tag == 2) {
        
        if ([self checkCountAndShowAlert:childCount]) {
            
            childCount--;
            self.childCountLabel.text = [NSString stringWithFormat:@"%i", childCount];
        }
    }if (sender.tag == 3) {
        
        if ([self checkCountAndShowAlert:srCitizenCount]) {
            
            srCitizenCount--;
            self.srCitizenCountLabel.text = [NSString stringWithFormat:@"%i", srCitizenCount];
        }
    }if (sender.tag == 4) {
        
        if ([self checkCountAndShowAlert:collegeStudentCount]) {
            
            collegeStudentCount--;
            self.collegeStudentCountLabel.text = [NSString stringWithFormat:@"%i", collegeStudentCount];
        }
    }
}

-(BOOL)checkCountAndShowAlert:(int)count {
    if (count != 0) {
        
        return true;
    }
    return false;
}

- (IBAction)calendarClicked:(id)sender {
    
    
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.3),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
    
}

-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker{
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd/MM/yy";
    self.dateLabel.text = [formatter stringFromDate:date];
    [self dismissSemiModalView];
}


-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker{
    
    [self dismissSemiModalView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)authenticationResult:(BOOL)success fromFunction:(NSString *)functionType{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:true];
    });
    
    if (success) {
        
        
        [self callSearchOperationWebService];
    }
}

- (IBAction)bookTicketsProceedClicked:(id)sender {
    
 
    if (adultCount != 0 || childCount != 0 || srCitizenCount != 0) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"SessionId"] isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
            });
            AppDelegate *appDelegate = [[AppDelegate alloc] init];
            appDelegate.delegate = self;
            appDelegate.functionType = @"BookTicketsProceed";
            [appDelegate callAuthenticationWebService];
        }else {
            [self callSearchOperationWebService];
        }
        
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please select atleast one passenger" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
    
}

-(void)callSearchOperationWebService {
    if ([Utilities isConnected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        
        [self searchOperationWebservice];
    }else {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
    
}

-(void)searchOperationWebservice {
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, searchOperationApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionId"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd/MM/yy";
    NSDate *dateOfVisit = [dateFormatter dateFromString:self.dateLabel.text];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateOfVisitString = [NSString stringWithFormat:@"%@T00:00:00", [dateFormatter stringFromDate:dateOfVisit]];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"Adults", @"Children", @"Infant", @"Senior", @"DateOFVisit", @"ServiceType", @"SessionID", @"TimeStamp", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: self.adultCountLabel.text, self.childCountLabel.text, self.collegeStudentCountLabel.text, self.srCitizenCountLabel.text, dateOfVisitString, serviceType, sessionId, @"",nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    self.searchData = [NSMutableDictionary dictionaryWithDictionary:jsondic];
    
    NSLog(@"Search Request: %@", jsondic);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"Search Response: %@", json);
            
            if ([json[@"Response"][@"Result"][@"StatusText"]  isEqualToString:@"SUCCESS"]) {
                
                self.dictData = json[@"Response"][@"Result"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    BookTicketsMainViewController *bookTicketsMainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookTicketsMainViewController"];
                    bookTicketsMainViewController.searchDictionary = self.searchData;
                    bookTicketsMainViewController.dataDictionary = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"]];
                    bookTicketsMainViewController.from = self.from;
                    [self.navigationController pushViewController:bookTicketsMainViewController animated:true];
                });
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry! No tickets available." preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:NO completion:nil];
            }
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry! No tickets available." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
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
