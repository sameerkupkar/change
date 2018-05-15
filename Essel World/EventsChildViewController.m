//
//  EventsChildViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 15/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "EventsChildViewController.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EventsChildViewController ()

@property (weak, nonatomic) IBOutlet UILabel *OfferTitle;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@end

@implementation EventsChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    if (![self.dataDict[@"image"] isEqualToString:@""]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventPrefix, self.dataDict[@"image"]]]];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.hidden = true;
            self.imageViewHeightConstraint.constant = 0;
        });
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [self.dataDict[@"description"] dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.textView.attributedText = attributedString;
    self.OfferTitle.text = self.dataDict[@"title"];
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
