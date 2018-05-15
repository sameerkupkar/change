//
//  MyProfileViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 22/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MyProfileViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isEditing;
    BOOL imageChanged;
}
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@end

@implementation MyProfileViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isEditing = false;
    self.profileImageView.layer.cornerRadius = 50;
    self.profileImageView.layer.masksToBounds = true;
    self.profileImageView.layer.borderWidth = 0.5;
    self.profileImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSDictionary *profileData = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSLog(@"%@",profileData);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![profileData[@"profile"] isEqualToString:@""]) {
            
            [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", profilePrefix, profileData[@"profile"]]]];
        }
    });
    
    self.nameTextField.text = profileData[@"fullName"];
    self.emailTextField.text = profileData[@"email"];
    
    if ([profileData[@"gender"] isEqualToString:@"Male"]) {
        
        [self.genderButton setTitle:@"Male" forState:UIControlStateNormal];
    }else {
        
        [self.genderButton setTitle:@"Female" forState:UIControlStateNormal];
    }
    
    self.mobileNumberTextField.text = profileData[@"mobile"];
    
    
    
}


- (IBAction)profileButtonClicked:(id)sender {
    if (isEditing) {
        
        
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
}

- (IBAction)editButtonClicked:(id)sender {
    isEditing = true;
    
    if (isEditing) {
        self.profileImageButton.userInteractionEnabled = true;
        self.genderButton.userInteractionEnabled = true;
        self.nameTextField.enabled = true;
        self.mobileNumberTextField.enabled = true;
        [self.nameTextField becomeFirstResponder];
        self.submitButton.hidden = false;
    }else {
        
//        self.profileImageButton.userInteractionEnabled = false;
//        self.genderButton.userInteractionEnabled = false;
//        self.nameTextField.enabled = false;
//        self.emailTextField.enabled = false;
//        self.mobileNumberTextField.enabled = false;
    }
    
}

- (IBAction)genderButtonClicked:(id)sender {
    if (isEditing) {
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        
        
        
        
        UIImage*scaleimage=[self scaleImage:self.profileImageView.image maxWidth:320 maxHeight:320];
        
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
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Profile updated successfully" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentViewController:alertController animated:NO completion:nil];
                    });
                }else{
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Uploading Profile image failed!" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentViewController:alertController animated:NO completion:nil];
                    });
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
    imageChanged = true;
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
//    [self.profileImageButton setImage:image forState:UIControlStateNormal];
    self.profileImageView.image = image;
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitButtonClicked:(id)sender {
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter your Full Name" preferredStyle:UIAlertControllerStyleAlert];
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
    }else {
        
        [self callEditProfileWebservice];
    }
}

-(void)callEditProfileWebservice {
    if ([Utilities isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:true];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        [self editWebservice];
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
}

-(void)editWebservice {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, editProfileApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *loginData = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"regId", @"fullName", @"mobile", @"gender",nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: loginData[@"regId"], self.nameTextField.text, self.mobileNumberTextField.text,self.genderButton.titleLabel.text,nil];
    
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
                
                if (imageChanged) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view endEditing:true];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].label.text = @"Uploading Image";
                    });
                    
                    [self uploadimagewithRegId:loginData[@"regId"]];
                    
                
                    
                    
                    
                }else {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:json[@"Response"][@"Result"][0] forKey:@"LoginData"];

                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Profile updated successfully" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:true];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self presentViewController:alertController animated:NO completion:nil];
                    });
                }
                
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:true];
                }]];
                
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
