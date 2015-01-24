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
#import "SnoopedProduct.h"
@interface SnachProductDetails()




@end

@implementation SnachProductDetails
{
    NSInteger seconds;
    NSTimer *timer;
    SnoopedProduct *product;
}
@synthesize productName,productimage,brandimag,productPrice,productDescription,counter;

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
    [self initializeView];
    // Set the Label text with the selected recipe
   
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
    NSLog(@"%ld",(long)timer);
    seconds=5;
   [counter setTitle: [NSString stringWithFormat:@"%i",seconds] forState: UIControlStateNormal];
    
}
-(void)initializeView{
   
    product=[SnoopedProduct sharedInstance];
    productName.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
  
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:product.brandImageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        brandimag.image=[UIImage imageWithData:data];
        product.brandImageData=data;
    }];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:product.productImageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        productimage.image=[UIImage imageWithData:data];
        product.productImageData=data;
    }];

    [productPrice setTitle: product.productPrice forState: UIControlStateNormal];
    productDescription.text=product.productDescription;

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
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.productimage=nil;
    self.brandimag=nil;
    productPrice=nil;
    productName=nil;
    
    
    // Release any retained subviews of the main view.
}

@end
