//
//  SnatchHistory.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnatchHistory.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "SnachHistoryCell.h"

@interface SnatchHistory()
@property(nonatomic,strong) NSArray *snachhistoryInflightList;
@property(nonatomic,strong) NSArray *snachhistoryDeliveredList;

@end

@implementation SnatchHistory
{
    NSString *subCellId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Load the file content and read the data into arrays
}
-(void)viewWillAppear:(BOOL)animated{
    [self makeSnachHistoryRequest];
    subCellId=@"all";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (IBAction)backBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self.revealViewController pushFrontViewController:navController animated:NO];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;

        if([subCellId isEqual:@"inFlight"]){
            count=[self.snachhistoryInflightList count];
        }
        else if([subCellId isEqual:@"delivered"])
        {
            count=[self.snachhistoryDeliveredList count];
        }
        else if([subCellId isEqual:@"all"])
        {
            count=[self.snachhistoryInflightList count]+[self.snachhistoryDeliveredList count];
        }
    
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *productImageUrl;
        NSString *productname;
        NSString *orderedDate;
        NSString *deliveryDate;
        NSDictionary *snachhistory;
        NSString *statusImg;
        if([subCellId isEqual:@"inFlight"]){
            snachhistory=[self.snachhistoryInflightList objectAtIndex:indexPath.row];
            productImageUrl=[snachhistory valueForKey:@"productImage"];
            productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
            orderedDate=[snachhistory valueForKey:@"dateOrdered"];
            deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
            statusImg=@"inflightIcon.png";
        }
        else if([subCellId isEqual:@"delivered"]){
            snachhistory=[self.snachhistoryDeliveredList objectAtIndex:indexPath.row];
            productImageUrl=[snachhistory valueForKey:@"productImage"];
            productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
            orderedDate=[snachhistory valueForKey:@"dateOrdered"];
            deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
            statusImg=@"deliveredIcon.png";
        }
        else if([subCellId isEqual:@"all"]){
            if(indexPath.row <[self.snachhistoryInflightList count]){
                snachhistory=[self.snachhistoryInflightList objectAtIndex:indexPath.row];
                productImageUrl=[snachhistory valueForKey:@"productImage"];
                productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
                orderedDate=[snachhistory valueForKey:@"dateOrdered"];
                deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
                statusImg=@"inflightIcon.png";
            }
            else {
                snachhistory=[self.snachhistoryDeliveredList objectAtIndex:[self.snachhistoryInflightList count]-indexPath.row+1];
                productImageUrl=[snachhistory valueForKey:@"productImage"];
                productname=[NSString stringWithFormat:@"%@ %@",[snachhistory valueForKey:@"brandName"],[snachhistory valueForKey:@"productName"]];
                orderedDate=[snachhistory valueForKey:@"dateOrdered"];
                deliveryDate=[snachhistory valueForKey:@"deliveryDate"];
                statusImg=@"deliveredIcon.png";
            }
        }
    SnachHistoryCell *cell = (SnachHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:productImageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(!error)
            {
                cell.productImage.image= [UIImage imageWithData:data];
                
            }
        }];
        [cell.productImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [cell.productImage.layer setBorderWidth: 1.0];
        cell.productNameLbl.text = productname;
        cell.dateOrdered.text = orderedDate;
        cell.dateDelivered.text=deliveryDate;
        cell.statusFlag.image=[UIImage imageNamed:statusImg];
    
        return cell;
 
}
    
    
- (IBAction)snachHistorySegmentChanged:(id)sender {
    
    switch (self.snachHistorySegmentControl.selectedSegmentIndex)
    {
        case 0:
            subCellId=@"all";
            NSLog(@"%@",subCellId);
            [_tableView reloadData];
            
            break;
        case 1:
              subCellId=@"delivered";
            NSLog(@"%@",subCellId);
            [_tableView reloadData];
            
            break;
        case 2:
            subCellId=@"inFlight";
            NSLog(@"%@",subCellId);
            [_tableView reloadData];
            
            break;
    }

}
-(void)makeSnachHistoryRequest{
    NSData *jasonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.120/snachhistory.json"]];
    NSDictionary *temp;
    if (jasonData) {
        NSError *e = nil;
        temp = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &e];
        
        self.snachhistoryInflightList=[temp objectForKey:@"inflight"];
        self.snachhistoryDeliveredList=[temp objectForKey:@"delivered"];
        
        
    }
    
}

@end
