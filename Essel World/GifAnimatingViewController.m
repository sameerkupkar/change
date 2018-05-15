//
//  GifAnimatingViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 04/02/17.
//  Copyright © 2017 Kwebmaker. All rights reserved.
//

#import "GifAnimatingViewController.h"
#import "UIImage+animatedGIF.h"
#import "DrawerViewController.h"
#import "LandingViewController.h"
#import <MMDrawerController.h>

@interface GifAnimatingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@end

@implementation GifAnimatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self performSelector:@selector(openLandingViewController) withObject:nil afterDelay:6.0f];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"splash_screen" withExtension:@"gif"];
    self.gifImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    UIImage *testImage = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    self.gifImageView.animationImages = testImage.images;
    self.gifImageView.animationDuration = testImage.duration;
    self.gifImageView.animationRepeatCount = 1;
    self.gifImageView.image = testImage.images.lastObject;
    [self.gifImageView startAnimating];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    
}

-(void)openLandingViewController {
    
    DrawerViewController *drawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DrawerViewController"];
    LandingViewController *landingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LandingViewController"];
    
    MMDrawerController *mmDrawerController = [[MMDrawerController alloc] initWithCenterViewController:landingViewController rightDrawerViewController:drawerViewController];
    
    [mmDrawerController setShowsShadow:NO];
    [mmDrawerController setRestorationIdentifier:@"MMDrawer"];
    [mmDrawerController setMaximumRightDrawerWidth:300.0];
    [mmDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [mmDrawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         UIViewController * sideDrawerViewController;
         if(drawerSide == MMDrawerSideLeft){
             sideDrawerViewController = drawerController.leftDrawerViewController;
         }
         else if(drawerSide == MMDrawerSideRight){
             sideDrawerViewController = drawerController.rightDrawerViewController;
         }
         [sideDrawerViewController.view setAlpha:percentVisible];
     }];
    mmDrawerController.view.backgroundColor = [UIColor colorWithRed:31.0/255.0
                                                              green:137.0/255.0
                                                               blue:182.0/255.0
                                                              alpha:1.0];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 800, 20)];
    topView.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                              green:156.0/255.0
                                               blue:51.0/255.0
                                              alpha:1.0];
    [mmDrawerController.view addSubview:topView];
    
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:mmDrawerController];
        navigationController.navigationBar.hidden = true;
        [navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    
    [self.view.window setTintColor:tintColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:navigationController animated:false completion:nil];
//        [self pushViewController:mmDrawerController animated:true];
    });
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
