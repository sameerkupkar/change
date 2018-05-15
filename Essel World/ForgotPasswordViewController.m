//
//  ForgotPasswordViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 19/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ForgotPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailOrMobileNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end
BOOL isValidEmailid;
@implementation ForgotPasswordViewController

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailOrMobileNumberTextField.delegate = self;
    
    self.submitButton.layer.cornerRadius = 8;
    self.submitButton.layer.masksToBounds = true;
    
    self.emailOrMobileNumberTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonClicked:(id)sender {
    [self isValidEmail];
    if ([self.emailOrMobileNumberTextField.text isEqualToString:@""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter your mobile number or email id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    } else if (!isValidEmailid)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter valid email id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
    else {
        [self callForgotPasswordWebService];
        
    }
}
-(void)isValidEmail
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    
    if (![emailTest evaluateWithObject:self.emailOrMobileNumberTextField.text] == YES)
    {
        isValidEmailid = false;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter valid email id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        //[self presentViewController:alertController animated:NO completion:nil];
    }
    else{
        isValidEmailid = true;
    }
    
}

-(void)callForgotPasswordWebService {
    if ([Utilities isConnected]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
        });
        
        [self forgotPasswordWebservice];
    }else {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
    
}

-(void)forgotPasswordWebservice {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, forgotPasswordApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"email", nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: self.emailOrMobileNumberTextField.text, nil];
    
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
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please check your email id. An email will be sent to you to reset password" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:json[@"Response"][@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alertController animated:NO completion:nil];
                });

            }
            
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
