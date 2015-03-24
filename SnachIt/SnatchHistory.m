//
//  SnatchHistory.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnatchHistory.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "SnachHistoryCell.h"
#import "global.h"
#import "UserProfile.h"
#import "SnachHistory.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SnatchHistory()
@property(nonatomic,strong) NSArray *snachhistoryInflightList;
@property(nonatomic,strong) NSArray *snachhistoryDeliveredList;

@end
UIRefreshControl *refreshControl;
@implementation SnatchHistory
{
    NSString *subCellId;
    UserProfile *user;
    NSMutableArray *myLetestALLSnachs;
    NSMutableArray *myLetestINFSnachs;
    NSMutableArray *myLetestDELSnachs;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Load the file content and read the data into arrays
    [self.backButton setTarget:self.revealViewController];
    [self.backButton setAction:@selector(revealToggle:)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    refreshControl= [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getMYLatestSnachs) forControlEvents:UIControlEventValueChanged];
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:refreshControl];
}
-(void)viewWillAppear:(BOOL)animated{
  
    subCellId=HISTORY_ALL;
    user=[UserProfile sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self getMYLatestSnachs];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;

        if([subCellId isEqual:HISTORY_INFLIGHT]){
            count=[myLetestINFSnachs count];
        }
        else if([subCellId isEqual:HISTORY_DELIVERED])
        {
            count=[myLetestDELSnachs count];
        }
        else if([subCellId isEqual:HISTORY_ALL])
        {
            count=[myLetestALLSnachs count];
        }
    // Display a message when the table is empty
    if(count<=0){
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No snachs history Available!";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else{
        self.tableView.backgroundView =nil;
        
    }
    return count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // Return the number of sections.
    if (myLetestALLSnachs) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    }
    else{
          self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
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
    SnachHistory *snachhistory;
    NSString *statusImg;
    
    if([subCellId isEqual:HISTORY_INFLIGHT]){
        snachhistory=[myLetestINFSnachs objectAtIndex:indexPath.row];
        
        productImageUrl=snachhistory.productImageUrl;
        productname=[NSString stringWithFormat:@"%@ %@",snachhistory.productBrandName,snachhistory.productName];
        orderedDate=snachhistory.productOrderedDate;
        statusImg=snachhistory.statusIcon;
        
    }
    else if([subCellId isEqual:HISTORY_DELIVERED]){
        snachhistory=[myLetestDELSnachs objectAtIndex:indexPath.row];
        
        productImageUrl=snachhistory.productImageUrl;
        productname=[NSString stringWithFormat:@"%@ %@",snachhistory.productBrandName,snachhistory.productName];
        orderedDate=snachhistory.productOrderedDate;
        deliveryDate=snachhistory.productDeliveryDate;
        statusImg=snachhistory.statusIcon;
        
    }
    else if([subCellId isEqual:HISTORY_ALL]){
        snachhistory=[myLetestALLSnachs objectAtIndex:indexPath.row];
        productImageUrl=snachhistory.productImageUrl;
        productname=[NSString stringWithFormat:@"%@ %@",snachhistory.productBrandName,snachhistory.productName];
        orderedDate=snachhistory.productOrderedDate;
        deliveryDate=snachhistory.productDeliveryDate;
        
        statusImg=snachhistory.statusIcon;
        
    }
    SnachHistoryCell *cell = (SnachHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    [cell.productImage setImageWithURL:[NSURL URLWithString:productImageUrl] placeholderImage:nil];
    [cell.productImage.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [cell.productImage.layer setBorderWidth: 1.0];
    cell.productNameLbl.text = productname;
    cell.dateOrdered.text = orderedDate;
    cell.dateDelivered.text=deliveryDate;
    if([statusImg isEqual:@"inflightIcon.png"]){
       cell.deliveryDateLbl.text=@"";
    }
    else
        cell.deliveryDateLbl.text=@"Delivery Date :";
    
    cell.statusFlag.image=[UIImage imageNamed:statusImg];
    return cell;



}


- (IBAction)snachHistorySegmentChanged:(id)sender {
    
    switch (self.snachHistorySegmentControl.selectedSegmentIndex)
    {
        case 0:
            subCellId=HISTORY_ALL;
            NSLog(@"%@",subCellId);
            [_tableView reloadData];
            
            break;
        case 1:
              subCellId=HISTORY_DELIVERED;
            NSLog(@"%@",subCellId);
            [_tableView reloadData];
            
            break;
        case 2:
            subCellId=HISTORY_INFLIGHT;
            NSLog(@"%@",subCellId);
            [_tableView reloadData];
            
            break;
    }

}

- (void)getMYLatestSnachs
{
    NSLog(@"Get my snachs");
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@get-user-snach-history/?customerId=%@",ec2maschineIP,user.userID]]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSDictionary *latestSnachs = [self makeHistoryRequest:data];
            myLetestALLSnachs = [NSMutableArray arrayWithCapacity:10];
            myLetestDELSnachs = [NSMutableArray arrayWithCapacity:10];
            myLetestINFSnachs = [NSMutableArray arrayWithCapacity:10];
            if (latestSnachs) {
                
                
                
                for (NSDictionary *tempDic in [latestSnachs objectForKey:@"data"]) {
                    SnachHistory *snachhistory = [[SnachHistory alloc] init];
                    snachhistory.productName=[tempDic objectForKey:HISTORY_PRODUCT_NAME];
                    snachhistory.productBrandName=[tempDic objectForKey:HISTORY_PRODUCT_BRAND_NAME];
                    snachhistory.productImageUrl=[tempDic objectForKey:HISTORY_PRODUCT_IMAGE];
                    snachhistory.productOrderedDate=[tempDic objectForKey:HISTORY_PRODUCT_ORDERDATE];
                    snachhistory.productDeliveryDate=[tempDic objectForKey:HISTORY_PRODUCT_DELIVERYDATE];
                    snachhistory.productstatus=[tempDic objectForKey:HISTORY_PRODUCT_STATUS];
                    if([[tempDic valueForKey:HISTORY_PRODUCT_STATUS] isEqual:HISTORY_INFLIGHT])
                    {snachhistory.statusIcon=@"inflightIcon.png"; [myLetestINFSnachs addObject:snachhistory];}
                    else if([[tempDic valueForKey:HISTORY_PRODUCT_STATUS] isEqual:HISTORY_DELIVERED])
                    {snachhistory.statusIcon=@"deliveredIcon.png";[myLetestDELSnachs addObject:snachhistory];}
                    
                    [myLetestALLSnachs addObject:snachhistory];
                }
            }
            // As this block of code is run in a background thread, we need to ensure the GUI
            // update is executed in the main thread
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}
- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}


-(NSDictionary*)makeHistoryRequest:(NSData *)response{
    NSError *error = nil;
    // NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
    //    NSLog(@"parsed data: %@",parsedData);
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    NSDictionary *latestFriendSnachs = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    return latestFriendSnachs;
}
@end
