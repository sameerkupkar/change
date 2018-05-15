//
//  ParkingTimingViewController.m
//  Essel World
//
//  Created by Karan Ram Pal on 22/11/16.
//  Copyright © 2016 Kwebmaker. All rights reserved.
//

#import "ParkingTimingViewController.h"
#import "ParkingTimingTableViewCell.h"

@interface ParkingTimingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ParkingTimingViewController

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

#pragma mark - UITableViewDelegate & Datasourca
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkingTimingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.dateLabel.text = self.dataArray[indexPath.row][@"parkDate"];
    cell.timeLabel.text = self.dataArray[indexPath.row][@"parkTime"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
