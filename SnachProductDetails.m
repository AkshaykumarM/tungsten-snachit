//
//  SnachProductDetails.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnachProductDetails.h"
#import "SnachCheckDetails.h"
#import <QuartzCore/QuartzCore.h>

@interface SnachProductDetails()




@end

@implementation SnachProductDetails
{
    NSInteger seconds;
    NSTimer *timer;
}
@synthesize productName,prodName,productimage,prodImgName,brandimag,brandImgName,productPrice,prodPrice,productDescription,prodDesc,counter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set the Label text with the selected recipe
    productName.text = prodName;
    brandimag.image=[UIImage imageNamed:brandImgName];
    productimage.image=[UIImage imageNamed:prodImgName];
    [productPrice setTitle: prodPrice forState: UIControlStateNormal];
   
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
    NSLog(@"%ld",(long)timer);
    seconds=5;
   [counter setTitle: [NSString stringWithFormat:@"%i",seconds] forState: UIControlStateNormal];
    
}


- (void)subtractTime {
    // 1
    seconds--;
    [counter setTitle: [NSString stringWithFormat:@"%i",seconds] forState: UIControlStateNormal];

    // 2
    if (seconds == 0) {
        [timer invalidate];
        
        // new code is here!
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time is up!"
//                                                        message:[NSString stringWithFormat:@"You scored %i points", count]
//                                                       delegate:self
//                                              cancelButtonTitle:@"Play Again"
//                                              otherButtonTitles:nil];
//        
//        [alert show];
       // [self performSegueWithIdentifier:@"timeup" sender:self];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)snachit:(id)sender {
    NSLog(@"ShowView");
    [self performSegueWithIdentifier:@"snachit" sender:self];
//    _snachConfirm=[[[NSBundle mainBundle]loadNibNamed:@"Snatch" owner:self options:nil] objectAtIndex:0];
//   
//    _snachConfirm.frame=CGRectMake(0.0f,self.view.frame.size.height/2, _snachConfirm.frame.size.width, _snachConfirm.frame.size.height);
//    
//    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//       [_snachConfirm addGestureRecognizer:singleTap];
//       
//    [self.view addSubview:_snachConfirm];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"snachit"]) {
        
        SnachCheckDetails *destViewController = segue.destinationViewController;
        destViewController.prodName = prodName;
        destViewController.prodPrice =prodPrice;
        destViewController.prodImgName =prodImgName;
        destViewController.brandImgName = brandImgName;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    static NSString *identifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    return cell;
}

@end
