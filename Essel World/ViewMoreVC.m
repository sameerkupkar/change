//
//  ViewMoreVC.m
//  Essel World
//
//  Created by Lovina on 19/04/17.
//  Copyright © 2017 Kwebmaker. All rights reserved.
//

#import "ViewMoreVC.h"
#import "RegularTicketsViewController.h"
#import "BookingTicketsFirstViewController.h"

@interface ViewMoreVC ()

@end

@implementation ViewMoreVC
- (IBAction)okayButtonTapped:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[BookingTicketsFirstViewController class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:controller
                                                      animated:YES];
            });
            break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
