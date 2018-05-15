//
//  PaymentGatewayViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 07/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "PaymentGatewayViewController.h"
#import "CCTool.h"
#import "Constants.h"
#import <MBProgressHUD.h>
@interface PaymentGatewayViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PaymentGatewayViewController


- (IBAction)backButtonClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to cancel the transaction?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:NO completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://cpanel.esselworld.com/travel-agency/BookingPaymentLink?travelPlanID=%@", self.orderID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlAsString]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:urlAsString forHTTPHeaderField:@"Referer"];
    [request setHTTPMethod: @"POST"];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^
                   {
                       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       
                   });
    
    
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(),
                 ^
                 {
                  
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                     
                 });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [object method];
//    });
//
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *string = webView.request.URL.absoluteString;

    NSLog(@"TEst ****** %@",string);
    
    if ([string rangeOfString:@"status=Y"].location != NSNotFound) {
        
        
       
        
        NSString *transStatus = @"Transaction Successful";
       
        [self.delegate paymentStatus:transStatus sender:self];
        
    }else if ([string rangeOfString:@"status=N"].location != NSNotFound) {
        
      
        NSString *transStatus = @"Transaction Failed";
      
        [self.delegate paymentStatus:transStatus sender:self];
        
    }
    
    
    
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
