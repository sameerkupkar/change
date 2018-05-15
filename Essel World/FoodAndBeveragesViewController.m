//
//  FoodAndBeveragesViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 22/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "FoodAndBeveragesViewController.h"
#import "Rides-OtherViewController.h"
#import "FoodAndBeveragesCollectionViewCell.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FoodAndBeveragesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation FoodAndBeveragesViewController

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate & Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodAndBeveragesCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", foodPrefix, self.dataArray[indexPath.item][@"logoImage"]]]];
    cell.cellTitleLabel.text = self.dataArray[indexPath.row][@"hotelName"];
    cell.cellImageView.layer.borderWidth = 0.5;
    cell.cellImageView.layer.borderColor = [UIColor colorWithRed:73.0/255.0
                                                          green:166.0/255.0
                                                           blue:232.0/255.0
                                                          alpha:1.0].CGColor;
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake(self.view.frame.size.width/2 - 2, 180);
    
    return size;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    
    FoodAndBeveragesCollectionViewCell *cell = (FoodAndBeveragesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    Rides_OtherViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Rides_OtherViewController"];
    destinationVC.banner = cell.cellImageView.image;
    destinationVC.dataDictionary = self.dataArray[indexPath.item];
    destinationVC.fromScreen = @"Food";
    [self.navigationController pushViewController:destinationVC animated:YES];
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
