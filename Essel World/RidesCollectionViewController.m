//
//  RidesCollectionViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 22/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "RidesCollectionViewController.h"
#import "Rides-OtherViewController.h"
#import "OtherAttractionCollectionViewCell.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RidesCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation RidesCollectionViewController

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
    
    
   
    OtherAttractionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ridesPrefix, [self.dataArray[indexPath.item][@"ride_image"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
    
    NSLog(@"%@",self.dataArray);
    cell.cellTitleLabel.text = self.dataArray[indexPath.item][@"ride_title"];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake(self.view.frame.size.width/2 - 1, self.view.frame.size.width/2);
    
    return size;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    
    OtherAttractionCollectionViewCell *cell = (OtherAttractionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    Rides_OtherViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Rides_OtherViewController"];
    destinationVC.banner = cell.cellImageView.image;
    destinationVC.dataDictionary = self.dataArray[indexPath.item];
    destinationVC.fromScreen = @"Rides";
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
