//
//  MenuLauncherViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 09/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "MenuLauncherViewController.h"
#import <MMDrawerController.h>
#import "LandingViewController.h"
#import "DrawerViewController.h"

@interface MenuLauncherViewController ()

@end

@implementation MenuLauncherViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
//    
//    DrawerViewController *drawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawerViewController"];
//    LandingViewController *landingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
//    
//    MMDrawerController *mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:landingViewController leftDrawerViewController:drawerViewController];
//    
//    [mmDrawerController setShowsShadow:NO];
//    [mmDrawerController setRestorationIdentifier:@"MMDrawer"];
//    [mmDrawerController setMaximumRightDrawerWidth:200.0];
//    [mmDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [mmDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    [self.navigationController pushViewController:mmDrawerController animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.window.rootViewController = mmDrawerController;
    
    
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
