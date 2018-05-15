//
//  RidesViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 22/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "RidesViewController.h"
#import "RidesCollectionViewController.h"

@interface RidesViewController ()
{
    int currentPageIndex;
    RidesCollectionViewController *adultCollectionViewController;
    RidesCollectionViewController *familyCollectionViewController;
    RidesCollectionViewController *kidsCollectionViewController;
    
}
@property (weak, nonatomic) IBOutlet UILabel *adultRidesLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyRidesLabel;
@property (weak, nonatomic) IBOutlet UILabel *kidHappyRidesLabel;
@property (weak, nonatomic) IBOutlet UIView *collectionSuperView;
@end

@implementation RidesViewController

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (adultCollectionViewController == nil) {
        currentPageIndex = 0;
        adultCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RidesCollectionViewController"];
        adultCollectionViewController.view.frame = CGRectMake(0, 0, self.collectionSuperView.frame.size.width, self.collectionSuperView.frame.size.height);
        adultCollectionViewController.dataArray = self.dataDictionary[@"Adults"];
        [self addChildViewController:adultCollectionViewController];
        [self.collectionSuperView addSubview:adultCollectionViewController.view];
        [adultCollectionViewController didMoveToParentViewController:self];
        
        familyCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RidesCollectionViewController"];
        familyCollectionViewController.view.frame = CGRectMake(self.collectionSuperView.frame.size.width, 0, self.collectionSuperView.frame.size.width, self.collectionSuperView.frame.size.height);
        familyCollectionViewController.dataArray = self.dataDictionary[@"Family"];
        [self addChildViewController:familyCollectionViewController];
        [self.collectionSuperView addSubview:familyCollectionViewController.view];
        [familyCollectionViewController didMoveToParentViewController:self];
        
        kidsCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RidesCollectionViewController"];
        kidsCollectionViewController.view.frame = CGRectMake(self.collectionSuperView.frame.size.width * 2, 0, self.collectionSuperView.frame.size.width, self.collectionSuperView.frame.size.height);
        kidsCollectionViewController.dataArray = self.dataDictionary[@"Kids"];
        [self addChildViewController:kidsCollectionViewController];
        [self.collectionSuperView addSubview:kidsCollectionViewController.view];
        [kidsCollectionViewController didMoveToParentViewController:self];
        
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer2];
}

-(void)handleSwipeFromRight:(UISwipeGestureRecognizer *)recognizer{
    
    if (currentPageIndex == 1) {
        
        currentPageIndex = 0;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(familyCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(kidsCollectionViewController.view.frame.size.width * 2, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.kidHappyRidesLabel];
        [self setUnselectedColorForLabel:self.familyRidesLabel];
        [self setSelectedColorForLabel:self.adultRidesLabel];
    }else if (currentPageIndex == 2) {
        
        
        currentPageIndex = 1;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(-adultCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(kidsCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.adultRidesLabel];
        [self setUnselectedColorForLabel:self.kidHappyRidesLabel];
        [self setSelectedColorForLabel:self.familyRidesLabel];
    }

}

-(void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)recognizer{
    if (currentPageIndex == 0) {
        
        currentPageIndex = 1;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(-adultCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(kidsCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.adultRidesLabel];
        [self setUnselectedColorForLabel:self.kidHappyRidesLabel];
        [self setSelectedColorForLabel:self.familyRidesLabel];
        
    }else if (currentPageIndex == 1){
        
        currentPageIndex = 2;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(-adultCollectionViewController.view.frame.size.width * 2, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(-familyCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.adultRidesLabel];
        [self setUnselectedColorForLabel:self.familyRidesLabel];
        [self setSelectedColorForLabel:self.kidHappyRidesLabel];
        
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)adultRidesButtonClicked:(id)sender {
    if (currentPageIndex != 0) {
        
        
        currentPageIndex = 0;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(familyCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(kidsCollectionViewController.view.frame.size.width * 2, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.kidHappyRidesLabel];
        [self setUnselectedColorForLabel:self.familyRidesLabel];
        [self setSelectedColorForLabel:self.adultRidesLabel];
    }
}

- (IBAction)FamilyRidesButtonClicked:(id)sender {
    if (currentPageIndex != 1) {
        
        
        currentPageIndex = 1;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(-adultCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(kidsCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.adultRidesLabel];
        [self setUnselectedColorForLabel:self.kidHappyRidesLabel];
        [self setSelectedColorForLabel:self.familyRidesLabel];
    }
}

- (IBAction)kidRidesButtonClicked:(id)sender {
    if (currentPageIndex != 2) {
        
        
        currentPageIndex = 2;
        [UIView animateWithDuration:0.5 animations:^{
            adultCollectionViewController.view.frame = CGRectMake(-adultCollectionViewController.view.frame.size.width * 2, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            familyCollectionViewController.view.frame = CGRectMake(-familyCollectionViewController.view.frame.size.width, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
            kidsCollectionViewController.view.frame = CGRectMake(0, 0, adultCollectionViewController.view.frame.size.width, adultCollectionViewController.view.frame.size.height);
        }];
        
        [self setUnselectedColorForLabel:self.adultRidesLabel];
        [self setUnselectedColorForLabel:self.familyRidesLabel];
        [self setSelectedColorForLabel:self.kidHappyRidesLabel];
        
    }
}

-(void)setUnselectedColorForLabel:(UILabel *)label {
    
    label.textColor = [UIColor colorWithRed:73.0/255.0
                                                     green:166.0/255.0
                                                      blue:232.0/255.0
                                                     alpha:1.0];
    label.backgroundColor = [UIColor whiteColor];
    
}

-(void)setSelectedColorForLabel:(UILabel *)label {
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:73.0/255.0
                                            green:166.0/255.0
                                             blue:232.0/255.0
                                            alpha:1.0];
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
