//
//  LoginViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 08/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "LoginViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Reachability.h"
#import "Utilities.h"
#import "Constants.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    self.loginButton.layer.cornerRadius = 10;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction)loginButtonClicked:(id)sender {
    if ([self.usernameTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter Email or Mobile No." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if ([self.passwordTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else {
        
        if ([Utilities isConnected]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view endEditing:true];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
            
            [self loginWebService];
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
            
        }
    }
}

-(void)loginWebService {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, loginApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *deviceToken;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]){
        deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    }else {
        deviceToken = @"";
    }
    
    
    NSArray * objects=[[NSArray alloc]initWithObjects:@"username", @"password", @"deviceType", @"gcmRegid", nil];
    NSArray * keys=[[NSArray alloc]initWithObjects: self.usernameTextField.text, self.passwordTextField.text, @"I", deviceToken, nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:keys forKeys:objects];
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
                
                [[NSUserDefaults standardUserDefaults] setObject:json[@"Response"][@"Result"][0] forKey:@"LoginData"];
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"LoginStatus"];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Login Successful!" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [self.navigationController popViewControllerAnimated:true];
                    });
                }]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
                
            }else {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:json[@"Response"][@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                });
            }
            
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong. Try Again!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view endEditing:true];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                });
                
                [self loginWebService];
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:alertController animated:NO completion:nil];
            });
        }
        
    }];
    
    [postDataTask resume];
}

-(void)resignKeyboard {
    [self.view endEditing:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
