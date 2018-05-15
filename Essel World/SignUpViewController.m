//
//  SignUpViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 08/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "SignUpViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Reachability.h"
#import "Utilities.h"
#import "Constants.h"

@interface SignUpViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@end

BOOL isValidEmailBool;

@implementation SignUpViewController

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.signUpButton.frame.origin.y + 70)];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.layer.masksToBounds = YES;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.mobileNumberTextField.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad {
    [self.view endEditing:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signUpButton.layer.cornerRadius = 10;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.mobileNumberTextField.delegate = self;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.signUpButton.frame.origin.y + 70)];
        });
    });
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 50) animated:true];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, textField.frame.origin.y + self.scrollView.frame.size.height - 50)];
    });
    return true;
    
}

-(void)isValidEmail
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    
    if (![emailTest evaluateWithObject:self.emailTextField.text] == YES)
    {
        isValidEmailBool = false;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter valid email id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        //[self presentViewController:alertController animated:NO completion:nil];
    }
    else{
        isValidEmailBool = true;
    }
   
}


-(void)resignKeyboard {
    [self.view endEditing:true];
}

- (IBAction)profileImageButtonClicked:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

- (IBAction)genderButtonClicked:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.genderButton setTitle:@"Male" forState:UIControlStateNormal];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.genderButton setTitle:@"Female" forState:UIControlStateNormal];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}


- (IBAction)signUpButtonClicked:(id)sender {
    
    [self isValidEmail];
    
    if ([self.fullNameTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your Full Name" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if ([self.emailTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your Email Id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if (![self.emailTextField.text containsString:@"@"] || ![self.emailTextField.text containsString:@"."]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid Email Id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if ([self.mobileNumberTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your Mobile Number" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if (self.mobileNumberTextField.text.length > 10 || self.mobileNumberTextField.text.length < 10) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid Mobile Number" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if ([self.passwordTextField.text isEqualToString:@""]) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your Password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if ([self.confirmTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please confirm your Password" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else if (![self.confirmTextField.text isEqualToString:self.passwordTextField.text]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password doesn't match" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
    else if(!isValidEmailBool)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter valid email id" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
    else
    
    {
        
        if ([Utilities isConnected]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view endEditing:true];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
            
            [self registerWebService];
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
            
        }
    }
}

-(void)registerWebService{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, signupApi]];
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
    
    NSArray * objects;
    
    if([self.genderButton.titleLabel.text isEqualToString:@"Select gender"])
    {
        objects=[[NSArray alloc]initWithObjects:self.fullNameTextField.text, self.emailTextField.text, self.mobileNumberTextField.text,@" ", self.passwordTextField.text, @"I", deviceToken, nil];
        
    }
    else
    {
        
         objects=[[NSArray alloc]initWithObjects:self.fullNameTextField.text, self.emailTextField.text, self.mobileNumberTextField.text, self.genderButton.titleLabel.text.lowercaseString, self.passwordTextField.text, @"I", deviceToken, nil];
    }
    NSArray * keys=[[NSArray alloc]initWithObjects:@"fullName", @"email", @"mobile", @"gender", @"password", @"deviceType", @"gcmRegid", nil];
   
    
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
                
                [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.text forKey:@"UserPassword"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"Response"][@"Result"][0] forKey:@"LoginData"];
                if (![self.profileImage.image isEqual:[UIImage imageNamed:@"profile"]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view endEditing:true];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Uploading Image";
                    });
                    
                    [self uploadimagewithRegId:json[@"Response"][@"Result"][0][@"regId"]];
                    
                }else{
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Verification email has been sent on your email id" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.navigationController popViewControllerAnimated:true];
                        });
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentViewController:alertController animated:NO completion:nil];
                    });
                }
               
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:json[@"Response"][@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:NO completion:nil];
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

-(void)uploadimagewithRegId:(NSString *)regId
{
    
    @try {
        
        NSString *fileName;
        fileName = [self dateAndTimeProfile];
        
       
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, uploadProfileApi]];
        NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:url];
        
        [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [urequest setHTTPShouldHandleCookies:NO];
        [urequest setTimeoutInterval:60];
        [urequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [urequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"regId\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[regId dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        UIImage*scaleimage=[self scaleImage:self.profileImage.image maxWidth:320 maxHeight:320];
        
        NSData *imageData = UIImageJPEGRepresentation(scaleimage,1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *contentDispositionString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_image\"; filename=\"%@\"\r\n", fileName];
            [body appendData:[contentDispositionString dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [urequest setHTTPBody:body];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            if (data != nil) {
                
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"%@", json);
                
                if ([json[@"Response"][@"status"] isEqualToString:@"true"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:json[@"Response"][@"Result"][0] forKey:@"LoginData"];
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Verification email has been sent on your email id" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                }else{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Verification email has been sent on your email id. Uploading profile image failed though you can verify your email id and login." preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    [self presentViewController:alertController animated:NO completion:nil];
                }
                
            }
            
        }];
        
        [postDataTask resume];
        
        
        
    }
    @catch (NSException *exception) {
        
        
    }
    
}

- (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}

-(NSString *)dateAndTimeProfile{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    NSLog(@"%@", dateString);
    
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HHmmss";
    
    NSString *timeString = [timeFormatter stringFromDate: localDate];
    NSLog(@"%@", timeString);
    return  [NSString stringWithFormat:@"IMG_%@_%@.jpg", dateString, timeString];
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self.profileImage setImage:image];
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:true completion:nil];
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
