//
//  LandingDetailViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 25/10/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "LandingDetailViewController.h"
#import "GuideMapViewController.h"
#import "SwipeView.h"
@import CoreLocation;
#import "BookingTicketsFirstViewController.h"
#import "EventsOffersPromotionsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OtherAttractionViewController.h"
#import "RidesViewController.h"
#import "Constants.h"
#import "FoodAndBeveragesViewController.h"
#import "ParkingTimingViewController.h"

@interface LandingDetailViewController ()<SwipeViewDelegate, SwipeViewDataSource, CLLocationManagerDelegate>
{
    int oldSwipeIndex, newSwipeIndex;
    BOOL pagingPointersEnabled;
    double latitude;
    double longitude;
}
@property (weak, nonatomic) IBOutlet UIView *pagingSuperView;
@property (weak, nonatomic) IBOutlet SwipeView *customPagingView;
@property (weak, nonatomic) IBOutlet UIImageView *slidesRidesImageView;
@property (weak, nonatomic) IBOutlet UILabel *slidesRidesLabel;
@property (strong, nonatomic) UIView *customPagerView;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSMutableArray *customPagingPointers;
@property (strong, nonatomic) NSMutableArray *bannerDataArray;
@property (strong, nonatomic) NSMutableArray *imagesDataArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSMutableArray *pagingPointers;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LandingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    latitude = 0;
    longitude = 0;
    oldSwipeIndex = 0;
    newSwipeIndex = 0;
    self.imagesDataArray = [NSMutableArray array];
    self.pagingPointers = [NSMutableArray array];
    self.bannerDataArray = [NSMutableArray arrayWithArray:self.dataDictionary[@"bannerImage"]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    if ([self.tapFrom isEqualToString:@"WaterKingdom"]) {
        
        self.slidesRidesLabel.text = @"Slides";
        self.slidesRidesImageView.image = [UIImage imageNamed:@"water_slides"];
    }else {
        
        self.slidesRidesLabel.text = @"Rides";
        self.slidesRidesImageView.image = [UIImage imageNamed:@"rides"];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    self.customPagingPointers = [NSMutableArray array];
    
    
    if (pagingPointersEnabled == false) {
        pagingPointersEnabled = true;
        [self setupPager];
        
        self.customPagingView.delegate = self;
        self.customPagingView.dataSource = self;
    }
    
}

-(void)setupPager {
    if (self.bannerDataArray.count > 1) {
        
        
        self.customPagerView = [[UIView alloc] init];
        
        int emptyCircleCount = 1;
        int emptyCircleX = 10;
        for (int i = 0; i < self.bannerDataArray.count; i++) {
            UIView *emptyCircleView = [[UIView alloc]initWithFrame:CGRectMake(emptyCircleX, 8, emptyCircleCount * 14, emptyCircleCount * 14)];
            emptyCircleView.layer.borderWidth = 1.5;
            emptyCircleView.layer.cornerRadius = 7;
            emptyCircleView.layer.borderColor = [UIColor blackColor].CGColor;
            emptyCircleView.layer.masksToBounds = true;
            emptyCircleX = emptyCircleX + 28;
            [self.pagingPointers addObject:emptyCircleView];
            [self.customPagerView addSubview:emptyCircleView];
            
            UIImage *imageFile = [UIImage imageNamed:@"Sample"];
            [self.imagesDataArray addObject:imageFile];
        }
        
        CGRect pagerViewFrame = self.pagingSuperView.bounds;
        pagerViewFrame.size.width = emptyCircleX - 2;
        pagerViewFrame.size.height = 30;
        pagerViewFrame.origin.x = (self.view.frame.size.width/2)-(pagerViewFrame.size.width/2);
        pagerViewFrame.origin.y = self.pagingSuperView.frame.size.height - 40;
        
        self.customPagerView.frame = pagerViewFrame;
        self.customPagerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.customPagerView.layer.cornerRadius = 15;
        [self.pagingSuperView addSubview:self.customPagerView];
        
        UIView *instancePointer = self.pagingPointers[0];
        instancePointer.backgroundColor = [UIColor blackColor];
        
        
    }else {
        
        UIImage *imageFile = [UIImage imageNamed:@"Sample"];
        [self.imagesDataArray addObject:imageFile];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
//    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [self.bannerDataArray count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    
//    newSwipeIndex = index;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.customPagingView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.clipsToBounds = true;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 1;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", bannerPrefix, self.bannerDataArray[index][@"image"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.imagesDataArray replaceObjectAtIndex:index withObject:image];
        
        }];
        [view addSubview:imageView];
    }
    else
    {
        //get a reference to the label in the recycled view
        imageView = (UIImageView *)[view viewWithTag:1];
    }
    
    
    
    imageView.image = self.imagesDataArray[index];
    
    return view;
}


- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    for (int i = 0; i < self.pagingPointers.count; i++) {
        
        if (i == self.customPagingView.currentItemIndex) {
            
            UIView *instancePointer = self.pagingPointers[i];
            instancePointer.backgroundColor = [UIColor blackColor];
        }else {
            
            UIView *instancePointer = self.pagingPointers[i];
            instancePointer.backgroundColor = [UIColor clearColor];
        }
    }
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.customPagingView.bounds.size;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"otherAttractionSegue"]) {
        
        OtherAttractionViewController *destinationVC = [segue destinationViewController];
        destinationVC.dataArray = self.dataDictionary[@"other_attraction"];
    }else if ([segue.identifier isEqualToString:@"ridesSegue"]) {
        
        RidesViewController *destinationVC = [segue destinationViewController];
        destinationVC.dataDictionary = self.dataDictionary[@"rides"];
    }else if ([segue.identifier isEqualToString:@"foodAndBeveragesSegue"]) {
        
        FoodAndBeveragesViewController *destinationVC = [segue destinationViewController];
        destinationVC.dataArray = self.dataDictionary[@"food"];
    }else if ([segue.identifier isEqualToString:@"parkingTimingSegue"]) {
        
        ParkingTimingViewController *destinationVC = [segue destinationViewController];
        destinationVC.dataArray = self.dataDictionary[@"parkingTime"];
    }else if ([segue.identifier isEqualToString:@"offersSegue"]) {
        
        EventsOffersPromotionsViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = @"Offers";
    }else if ([segue.identifier isEqualToString:@"bookTicketsSegue"]) {
        
        BookingTicketsFirstViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = self.tapFrom;
    }else if ([segue.identifier isEqualToString:@"guideMapView"]) {
        
        GuideMapViewController *destinationVC = [segue destinationViewController];
        destinationVC.from = self.tapFrom;
    }
}

- (IBAction)bookTicketsButtonClicked:(id)sender {
    
    [self checkAndPushBookingOrLogin:@"bookTicketsSegue"];
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


- (IBAction)locationButtonClicked:(id)sender {
    
    if (latitude == 0 || latitude == 0.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Couldn't get your location to direct you" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:alertController animated:NO completion:nil];
        });
    }else if ([self.tapFrom isEqualToString:@"EsselWorld"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.google.com/?saddr=%f,%f&daddr=%@,%@", latitude, longitude, essellat, essellon]]];
        
    }else if ([self.tapFrom isEqualToString:@"WaterKingdom"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.google.com/?saddr=%f,%f&daddr=%@,%@", latitude, longitude, wklat, wklon]]];
        
    }else if ([self.tapFrom isEqualToString:@"DownTown"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.google.com/?saddr=%f,%f&daddr=%@,%@", latitude, longitude, downlat, downlon]]];
        
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateToLocation");
    CLLocation *currentLocation = [locations lastObject];
    
    
    latitude = currentLocation.coordinate.latitude;
    longitude = currentLocation.coordinate.longitude;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self.locationManager stopUpdatingLocation];
    });
   
}

- (IBAction)offersButtonClicked:(id)sender {
}

@end
