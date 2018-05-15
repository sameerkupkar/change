//
//  BookTicketsMainViewController.h
//  Essel World
//
//  Created by Karan Ram Pal on 05/12/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTicketsMainViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (strong, nonatomic) NSMutableDictionary *searchDictionary;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *sourceRefId;
@end
