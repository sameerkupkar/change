//
//  GuideMapViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 04/02/17.
//  Copyright © 2017 Kwebmaker. All rights reserved.
//

#import "GuideMapViewController.h"

@interface GuideMapViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GuideMapViewController
- (IBAction)backButton:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:true];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    if ([self.from isEqualToString:@"EsselWorld"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:[UIImage imageNamed:@"EsselWorldGuideMap"]];
        });
    }else if ([self.from isEqualToString:@"WaterKingdom"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:[UIImage imageNamed:@"WaterKingdomGuideMap"]];
        });
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:[UIImage imageNamed:@"DownTownGuideMap"]];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = self.imageView.frame.size;
        
//                self.scrollView.scrollEnabled = NO;
        
        // For supporting zoom,
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 7.0;
    });
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.scrollView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return self.imageView;
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
