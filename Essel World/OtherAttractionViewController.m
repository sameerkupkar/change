//
//  OtherAttractionViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 21/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "OtherAttractionViewController.h"
#import "OtherAttractionCollectionViewCell.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Rides-OtherViewController.h"

@interface OtherAttractionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation OtherAttractionViewController

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
    });
    
}

#pragma mark - UICollectionViewDelegate & Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OtherAttractionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", otherAttractionPrefix, self.dataArray[indexPath.item][@"image"]]]];
    
    cell.cellTitleLabel.text = self.dataArray[indexPath.item][@"title"];
    
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
    destinationVC.fromScreen = @"Other";
    [self.navigationController pushViewController:destinationVC animated:YES];
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
