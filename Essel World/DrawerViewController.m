//
//  DrawerViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 09/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "DrawerViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "EventsOffersPromotionsViewController.h"

@interface DrawerViewController ()

@property (weak, nonatomic) IBOutlet UIView *bookingHistoryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookingHistoryHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *myProfileView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myProfileHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *logOutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logOutViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@end

@implementation DrawerViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    self.navigationController.navigationBar.hidden = true;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 20)];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"]) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"] isEqualToString:@"true"]) {
            
            [self setupLoginLogout:true];
        }else {
            
            [self setupLoginLogout:false];
        }
    }else {
        
        [self setupLoginLogout:false];
    }
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
//    self.viewTopConstraint.constant = 0;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    
}

-(void)setupLoginLogout:(BOOL)isLogin {
    
    if (isLogin) {
        
        self.logOutViewHeightConstraint.constant = 40;
        self.logOutView.hidden = false;
        self.myProfileHeightConstraint.constant = 40;
        self.myProfileView.hidden = false;
        self.bookingHistoryView.hidden = false;
        self.bookingHistoryHeightConstraint.constant = 40;
        
        self.signUpViewHeightConstraint.constant = 0;
        self.signUpView.hidden = true;
        self.loginViewHeightConstraint.constant = 0;
        self.loginView.hidden = true;
    }else {
        
        self.logOutViewHeightConstraint.constant = 0;
        self.logOutView.hidden = true;
        self.myProfileHeightConstraint.constant = 0;
        self.myProfileView.hidden = true;
        self.bookingHistoryView.hidden = true;
        self.bookingHistoryHeightConstraint.constant = 0;
        
        self.signUpViewHeightConstraint.constant = 40;
        self.signUpView.hidden = false;
        self.loginViewHeightConstraint.constant = 40;
        self.loginView.hidden = false;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonClicked:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)toggleDrawer {
    
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:NO completion:nil];
}

- (IBAction)bookingHistory:(id)sender {
    
    [self toggleDrawer];
}

- (IBAction)loginButtonClicked:(id)sender {
    
    [self toggleDrawer];
}
- (IBAction)signUpButtonClicked:(id)sender {
    
    [self toggleDrawer];
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [self toggleDrawer];
}

- (IBAction)myProfileButtonClicked:(id)sender {
    
    [self toggleDrawer];
}

- (IBAction)logOutButtonClicked:(id)sender {
    
    [self toggleDrawer];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setObject:@"false" forKey:@"LoginStatus"];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:NO completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"eventsSegue"]) {
        EventsOffersPromotionsViewController *destinationVc = [segue destinationViewController];
        destinationVc.from = @"Events";
    }else if ([segue.identifier isEqualToString:@"offersSegue"]) {
        EventsOffersPromotionsViewController *destinationVc = [segue destinationViewController];
        destinationVc.from = @"Offers";
    }if ([segue.identifier isEqualToString:@"schoolsSegue"]) {
        EventsOffersPromotionsViewController *destinationVc = [segue destinationViewController];
        destinationVc.from = @"Schools";
    }
    
}


@end
