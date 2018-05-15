//
//  Rides-OtherViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 22/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "Rides-OtherViewController.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "SwipeView.h"


@interface Rides_OtherViewController ()<SwipeViewDelegate, SwipeViewDataSource>
{
    int oldSwipeIndex, newSwipeIndex;
    BOOL pagingPointersEnabled;
    int likeStatus;
}

@property (weak, nonatomic) IBOutlet UIView *pagingSuperView;
@property (weak, nonatomic) IBOutlet SwipeView *customPagingView;

@property (weak, nonatomic) IBOutlet UILabel *titleOfPage;
//@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleBannerLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *backgroundYoutubeView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dislikeCountLabel;
@property (weak, nonatomic) IBOutlet UIView *likeDislikeView;
@property (strong, nonatomic) UIView *customPagerView;

@property (strong, nonatomic) NSMutableArray *bannerDataArray;
@property (strong, nonatomic) NSMutableArray *imagesDataArray;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSMutableArray *customPagingPointers;
@property (strong, nonatomic) IBOutletCollection(UIView) NSMutableArray *pagingPointers;
@end

@implementation Rides_OtherViewController

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    oldSwipeIndex = 0;
    newSwipeIndex = 0;
    self.imagesDataArray = [NSMutableArray array];
    self.pagingPointers = [NSMutableArray array];
    if ([self.fromScreen isEqualToString:@"Rides"]) {
        
        self.bannerDataArray = [NSMutableArray arrayWithArray:self.dataDictionary[@"RideImages"]];
    }else if ([self.fromScreen isEqualToString:@"Other"]) {
        
        self.bannerDataArray = [NSMutableArray arrayWithArray:self.dataDictionary[@"otherImages"]];
    }else {
        
        self.bannerDataArray = [NSMutableArray arrayWithArray:self.dataDictionary[@"FoodImages"]];
    }
    
    likeStatus = 2;
    if ([self.fromScreen isEqualToString:@"Rides"]) {
        
//        self.bannerImage.image = self.banner;
        self.titleOfPage.text = self.dataDictionary[@"ride_title"];
        self.titleBannerLabel.text = self.dataDictionary[@"ride_title"];
        self.backgroundYoutubeView.layer.cornerRadius = 3;
        self.backgroundYoutubeView.layer.masksToBounds = true;
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [self.dataDictionary[@"ride_desc"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        
        self.descriptionTextView.attributedText = attributedString;
    }else {
        
//        self.bannerImage.image = self.banner;
        
        if ([self.fromScreen isEqualToString:@"Food"]) {
            
            self.titleOfPage.text = self.dataDictionary[@"hotelName"];
            self.titleBannerLabel.text = self.dataDictionary[@"hotelName"];
        }else{
            
            self.titleOfPage.text = self.dataDictionary[@"title"];
            self.titleBannerLabel.text = self.dataDictionary[@"title"];
        }
        self.backgroundYoutubeView.layer.cornerRadius = 3;
        self.backgroundYoutubeView.layer.masksToBounds = true;
        
        
//        UIFont *font = [UIFont fontWithName:@"Oswald-Regular" size:14.0];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [self.dataDictionary[@"description"] dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        
        self.descriptionTextView.attributedText = attributedString;
        
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginStatus"] isEqualToString:@"true"]) {
            
            self.likeDislikeView.hidden = false;
            
            self.likeCountLabel.text = self.dataDictionary[@"likeCount"];
            self.dislikeCountLabel.text = self.dataDictionary[@"disLikeCount"];
            
            [self callGetLikesWebservice];
            
        }else {
            
            self.likeDislikeView.hidden = true;
        }
    }else {
        
        self.likeDislikeView.hidden = true;
    }
    
}

-(void)callGetLikesWebservice {
    if ([Utilities isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:true];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        [self getLikesWebservice];
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
}

-(void)getLikesWebservice {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, getLikesApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *type;
    NSString *strId;
    
    if ([self.fromScreen isEqualToString:@"Rides"]) {
        
        type = @"ride";
        strId = self.dataDictionary[@"rideId"];
    }else if ([self.fromScreen isEqualToString:@"Other"]) {
        
        type = @"other";
        strId = self.dataDictionary[@"id"];
    }else if ([self.fromScreen isEqualToString:@"Food"]) {
        
        type = @"food";
        strId = self.dataDictionary[@"foodId"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"regId", @"strId", @"type",nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: [dict valueForKey:@"regId"], strId, type, nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                
                if ([json[@"Response"][@"Result"][0][@"status"] isEqualToString:@"0"]) {
                    likeStatus = 0;
                }else {
                    likeStatus = 1;
                }
                
                [self getLikesCountWebservice:strId
                                         type:type];
                
            }else {
                
                likeStatus = 2;
                
                [self getLikesCountWebservice:strId
                                         type:type];
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

-(void)getLikesCountWebservice:(NSString *)strId type:(NSString *)type {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, getLikesCount]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"strId", @"type",nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: strId, type, nil];
    
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.likeCountLabel.text = json[@"Response"][@"Result"][@"likecount"];
                    self.dislikeCountLabel.text = json[@"Response"][@"Result"][@"dislikecount"];
                });
                
            }else {
                
                
                
            }
            
        }
        
    }];
    
    [postDataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)watchVideoButton:(id)sender {
    
    if (![self.dataDictionary[@"video"] isEqualToString:@""]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dataDictionary[@"video"]]];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Video not available!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

- (IBAction)likeButtonClicked:(id)sender {
    if (likeStatus == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"This post has been already liked by you." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else {
        [self callLikeDislikeWebservice:@"1"];
    }
}

- (IBAction)dislikeButtonClicked:(id)sender {
    if (likeStatus == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"This post has been already disliked by you." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
    }else {
        [self callLikeDislikeWebservice:@"0"];
    }
}

-(void)callLikeDislikeWebservice:(NSString *)status {
    
    if ([Utilities isConnected]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:true];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        [self likeDislikeWebservice:status];
    }else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet!" message:@"It seems you're not connected to the internet!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:NO completion:nil];
        
    }
}

-(void)likeDislikeWebservice:(NSString *)status {
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, hitLikeApi]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *type;
    NSString *strId;
    
    if ([self.fromScreen isEqualToString:@"Rides"]) {
        
        type = @"ride";
        strId = self.dataDictionary[@"rideId"];
    }else if ([self.fromScreen isEqualToString:@"Other"]) {
        
        type = @"other";
        strId = self.dataDictionary[@"id"];
    }else if ([self.fromScreen isEqualToString:@"Food"]) {
        
        type = @"food";
        strId = self.dataDictionary[@"foodId"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginData"]];
    
    NSArray * keys=[[NSArray alloc]initWithObjects: @"regId", @"strId", @"type", @"isLike",nil];
    NSArray * objects=[[NSArray alloc]initWithObjects: [dict valueForKey:@"regId"], strId, type, status, nil];
    
    NSDictionary * jsondic=[NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsondic options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", json);
            
            if ([json[@"Response"][@"status"]  isEqualToString:@"true"]) {
                
                likeStatus = status.intValue;
                
                
                [self getLikesCountWebservice:strId
                                         type:type];
                
            }else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong! Please try again" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:NO completion:nil];
            }
            
        }
        
    }];
    
    [postDataTask resume];
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
    NSString *prefixUrl;
    NSString *keyName;
    if ([self.fromScreen isEqualToString:@"Rides"]) {
        prefixUrl = ridesPrefix;
        keyName = @"image";
    }else if ([self.fromScreen isEqualToString:@"Other"]) {
        prefixUrl = otherAttractionPrefix;
        keyName = @"image";
    }else if ([self.fromScreen isEqualToString:@"Food"]) {
        prefixUrl = foodPrefix;
        keyName = @"image";
    }
    
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefixUrl, [self.bannerDataArray[index][@"image"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                
                [self.imagesDataArray replaceObjectAtIndex:index withObject:image];
            }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
