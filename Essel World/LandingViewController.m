//
//  ViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 25/10/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.

#import "LandingViewController.h"
#import "EventsOffersPromotionsViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Constants.h"
#import "Utilities.h"
#import "Utilities.h"
#import "LandingDetailViewController.h"
#import "BookingTicketsFirstViewController.h"

@interface LandingViewController ()

@property(strong, nonatomic) NSMutableDictionary *esselWorldData;
@end

@implementation LandingViewController

- (IBAction)comingSoonButtonClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Coming soon..." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.esselWorldData.allKeys.count == 0) {
        
        if ([Utilities isConnected]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view endEditing:true];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
            
            
            [self getEsselWorldRecords];
            
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:NO completion:nil];
            
        }
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    
}

-(void)getEsselWorldRecords{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, esselWorldDataApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    

    

   
    
    
//    [Utilities checkInternetAndCallWebserviceWithUrl:url andParameters:jsondic callself:session callBack:^(NSData *data, BOOL connected)
//
//
//     {
//
//
//
//         if (connected) {
//
//             dispatch_async(dispatch_get_main_queue(),
//                            ^
//                            {
//                                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//                            });
//
//
//
//             if (data != nil) {
//
//
//
//
//                                 NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//                                 NSLog(@"%@", json);
//
//                                 if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
//
//                                     self.esselWorldData = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"]];
//
//                                 }
//
//                                 else{
//                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:json[@"Response"][@"Message"] preferredStyle:UIAlertControllerStyleAlert];
//                                     [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
//
//                                     [self presentViewController:alertController animated:NO completion:nil];
//                                 }
//
//
//
//
//             }
//             else
//             {
//
//                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Unable to process your request. Please try again" preferredStyle:UIAlertControllerStyleAlert];
//
//                 [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
//
//                 [self presentViewController:alertController animated:NO completion:nil];
//             }
//         }
//     }];
    
    
    NSLog(@"TEST URL %@",url);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{

            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });

        if( error )
        {
            NSLog(@"Test %@", [error localizedDescription]);
        }
        else {


            if (data != nil) {

                NSLog(@"test %@", data);
                
                NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                NSLog(@"test %@", json[@"Response"][@"status"]);

                if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                    

                    self.esselWorldData = [NSMutableDictionary dictionaryWithDictionary:json[@"Response"][@"Result"]];
                    
                    

                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:json[@"Response"][@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];

                    [self presentViewController:alertController animated:NO completion:nil];
                }

            }
        }


    }];

    [postDataTask resume];
    
    
    
    
    
    
    
    
}




- (IBAction)drawerButtonClicked:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"esselWorldTapSegue"]) {
        
        [self showLandingDetailViewControllerFrom:@"EsselWorld" dictString:@"esselworld" ofSegue:segue];
    }else if ([segue.identifier isEqualToString:@"waterKingdomTapSegue"]) {
        
        [self showLandingDetailViewControllerFrom:@"WaterKingdom" dictString:@"water_kingdom" ofSegue:segue];
    }else if ([segue.identifier isEqualToString:@"downTownTapSegue"]) {
        
        [self showLandingDetailViewControllerFrom:@"DownTown" dictString:@"downtown" ofSegue:segue];
    }else if ([segue.identifier isEqualToString:@"esselBook"]) {
        
        BookingTicketsFirstViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = @"EsselWorld";
    }else if ([segue.identifier isEqualToString:@"waterBook"]) {
        
        BookingTicketsFirstViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = @"WaterKingdom";
    }else if ([segue.identifier isEqualToString:@"downBook"]) {
        
        BookingTicketsFirstViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = @"DownTown";
    }else if ([segue.identifier isEqualToString:@"offersSegue"]) {
        
        EventsOffersPromotionsViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = @"Offers";
    }
}

-(void)showLandingDetailViewControllerFrom:(NSString *)from dictString:(NSString *)key ofSegue:(UIStoryboardSegue *)segue {
    
    LandingDetailViewController *destinationVC = [segue destinationViewController];
    destinationVC.dataDictionary = [NSMutableDictionary dictionaryWithDictionary:self.esselWorldData[key]];
    destinationVC.tapFrom = from;
}

- (IBAction)bookTicketsClicked:(UIButton *)sender {
    
    if (sender.tag == 1) {
        
        [self checkAndPushBookingOrLogin:@"esselBook"];
    }else if (sender.tag == 2) {
        
        [self checkAndPushBookingOrLogin:@"waterBook"];
    }else if (sender.tag == 3) {
        
        [self checkAndPushBookingOrLogin:@"downBook"];
    }
    
}

- (IBAction)viewOffersClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"offersSegue" sender:self];
}


-(void)checkAndPushBookingOrLogin:(NSString *)bookingIdentifier {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] isEqualToString:@"true"]) {
            
            [self performSegueWithIdentifier:bookingIdentifier sender:self];
        }else {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }else {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
