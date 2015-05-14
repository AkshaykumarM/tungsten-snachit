//
//  AftershipTracker.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 4/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "AftershipTracker.h"
#import "Checkpoints.h"
#import <Aftership.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "global.h"
@implementation AftershipTracker
{
    NSMutableArray *trackings;
    NSString *slug;
    NSString *tracking_number;
    NSString *tag;
    NSString *expected_delivery;
    NSDateFormatter *formatter;
    NSDateFormatter *dformat;
    
}



-(void)viewDidLoad{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"closeout_icon.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *nav_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = nav_btn;
    formatter = [[NSDateFormatter alloc] init];
    [super viewDidLoad];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self getTrackings];
    self.navigationController.navigationBar.topItem.title=self.trackingNo;
    [super viewDidAppear:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [trackings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AftershipCell *cell = (AftershipCell *)[tableView dequeueReusableCellWithIdentifier:@"aftershipStatusCell"];
    if (cell == nil) {
        cell=(AftershipCell *)[tableView dequeueReusableCellWithIdentifier:@"aftershipCell" forIndexPath:indexPath];
        
    }
    @try{
        Checkpoints *check=[trackings objectAtIndex:indexPath.row];
        
        [formatter setDateFormat:@"MMM dd',' yyyy"];
        dformat = [[NSDateFormatter alloc]init];
        [dformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        cell.checkPointDate.text=[formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"hh:mm a"];
        cell.checkPointTime.text = [formatter stringFromDate:[dformat dateFromString:check.checkpoint_time]];
        cell.messageLbl.text = [check.message capitalizedString];
        [cell.tagImgView setImage:[UIImage imageNamed:[self getIconForStatus:[self getStatusNoForStatus:check.tag]]]];
        [cell.tagImgView setBackgroundColor:[UIColor whiteColor]];
        
        if([check.state isKindOfClass:[NSNull class]]|| check.state==nil)
            check.state=@"";
        if([check.city isKindOfClass:[NSNull class]]|| check.city==nil)
            check.city=@"";
        if([check.zip isKindOfClass:[NSNull class]]|| check.zip==nil)
            check.zip=@"";
        if([check.city isEqual:@""]&&[check.state isEqual:@""]&&[check.zip isEqual:@""])
            cell.cityStateZip.text=@"";
        else if(![check.city isEqual:@""]&&[check.state isEqual:@""]&&[check.zip isEqual:@""])
            cell.cityStateZip.text=check.city;
        else
            cell.cityStateZip.text=[NSString stringWithFormat:@"%@, %@ %@",check.city,check.state,check.zip];
        
    }
    @catch(NSException *e){}
    return cell;
}
-(NSString*)getIconForStatus:(int)statusNo{
    NSString *imgName;
    switch (statusNo) {
        case 1:
            imgName=@"shipped_icon.png";
            break;
        case 2:
            imgName=@"inflight_icon.png";
            break;
        case 3:
            imgName=@"outfordelivery_icon.png";
            break;
        case 4:
            imgName=@"failedattempt_icon.png";
            break;
        case 5:
            imgName=@"delivered_icon.png";
            break;
        case 6:
            imgName=@"exception_icon.png";
            break;
        case 7:
            imgName=nil;
            break;
        case 8:
            imgName=nil;
            break;
        default:
            imgName=nil;
            break;
    }
    return imgName;
}

-(int)getStatusNoForStatus:(NSString*)status{
    if([status isEqual:@"InfoReceived"])
    {
        return 1;
    }
    else if([status isEqual:@"InTransit"])
    {
        return 2;
    }
    else if([status isEqual:@"OutForDelivery"])
    {
        return 3;
    }
    else if([status isEqual:@"FailedAttempt"])
    {
        return 4;
    }
    else if([status isEqual:@"Delivered"])
    {
        return 5;
    }
    else if([status isEqual:@"Exception"])
    {
        return 6;
    }
    else if([status isEqual:@"Expired"])
    {
        return 7;
    }
    else if([status isEqual:@"Pending"])
    {
        return 8;
    }
    else
    {
        return 0;
    }
}

//this function will return all snached snachs
- (void)getTrackings
{
    AftershipClient *client = [AftershipClient clientWithApiKey:@"0db6d59d-c97c-4334-9aa8-e4c8ebe4e8e2"];
    AftershipGetTrackingRequest *aftershipGetTrackingRequest =
    [AftershipGetTrackingRequest requestWithTrackingNumber:self.trackingNo
                                                      slug:self.slugname.lowercaseString
                                           completionBlock:^(AftershipGetTrackingRequest *request,
                                                             AftershipTracking *tracking,
                                                             NSError *error) {
                                               
                                               if (!error) {
                                                   
                                                   tag=tracking.tag;
                                                   slug=tracking.slug;
                                                   tracking_number=tracking.trackingNumber;
                                                   expected_delivery=tracking.expectedDeliveryDate;
                                                   trackings = [NSMutableArray arrayWithCapacity:10];
                                                   
                                                   for (int i=0;i<[tracking.checkpoints count];i++) {
                                                       Checkpoints *checkpoints = [[Checkpoints alloc] init];
                                                       checkpoints.slug=[tracking.checkpoints[i] valueForKey:@"slug"];
                                                       checkpoints.city=[tracking.checkpoints[i] valueForKey:@"city"];
                                                       checkpoints.created_at=[tracking.checkpoints[i] valueForKey:@"createTime"];
                                                       checkpoints.country_name=[tracking.checkpoints[i] valueForKey:@"countryName"];
                                                       checkpoints.message=[tracking.checkpoints[i] valueForKey:@"message"];
                                                       checkpoints.country_iso3=[tracking.checkpoints[i] valueForKey:@"countryCode"];
                                                       checkpoints.tag=[tracking.checkpoints[i] valueForKey:@"tag"];
                                                       checkpoints.checkpoint_time=[tracking.checkpoints[i] valueForKey:@"checkpointTime"];
                                                       checkpoints.state=[tracking.checkpoints[i] valueForKey:@"state"];
                                                       checkpoints.zip=[tracking.checkpoints[i] valueForKey:@"zip"];
                                                       [trackings addObject:checkpoints];
                                                   }
                                                   // As this block of code is run in a background thread, we need to ensure the GUI
                                                   // update is executed in the main thread
                                                   [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                               }
                                               if(error){
                                                   
                                                   [global showAllertMsg:@"Error" Message:error.domain.description];
                                               }
                                           }];
    [client executeRequest:aftershipGetTrackingRequest];
    
}
- (void)reloadData
{
    NSArray* reversedArray = [[trackings reverseObjectEnumerator] allObjects];
    trackings=[reversedArray mutableCopy];
    [self.tableView reloadData];
    self.statusLBL.text=tag.uppercaseString;
    if([expected_delivery isKindOfClass:[NSNull class]]||expected_delivery==nil)
        expected_delivery=@"NA";
    self.deliverBy.text=[NSString stringWithFormat:@"SCHEDULED: %@",expected_delivery];
    [self.slugIMGV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-52-1-195-249.compute-1.amazonaws.com/media/media/slugs/%@.jpg",slug]] placeholderImage:nil];
}
-(NSDictionary*)makeRequest:(NSData *)response{
    NSError *error = nil;
    
    if (error != nil) {
        NSLog(@"Error: %@", error.description);
        return nil;
    }
    
    NSDictionary *latestFriendSnachs = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &error];
    
    
    return [latestFriendSnachs objectForKey:@"data"];
}

@end
