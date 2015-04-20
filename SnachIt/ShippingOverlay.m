//
//  ShippingOverlay.m
//  SnachIt
//
//  Created by Akshay Maldhure on 1/22/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "ShippingOverlay.h"
#import "shippingOverlayCell.h"
#import "OrderTotalOverview.h"
#import "SnoopedProduct.h"
#import "Order.h"
#import "global.h"
NSString *const BACKTOORDEROVERVIEW=@"backToOrderOverview";
@interface ShippingOverlay()
@property (nonatomic,strong) NSArray *cellId;

@end

@implementation ShippingOverlay{
    SnoopedProduct *product;
    Order *order;
}
@synthesize productImg,brandImg,productDesc,productNameLbl,productPriceBtn,cellId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    screenName=@"sol";
    cellId = [NSArray arrayWithObjects: @"shippingCell",@"estDeliveryCell",@"speedCell", @"priceCell",nil];
    
    order=[Order sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initializeView];
    [super viewDidAppear:YES];
}
-(void)initializeView{
     self.navigationController.navigationBar.topItem.title = @"snach details";
    @try{
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@",product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
     productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];

        [productDesc loadHTMLString:[NSString stringWithFormat:@"<html>\n""<head>\n""<style type=\"text/css\">\n"" body{ font-size:%@;font-family:'Open Sans';}\n""</style>\n""</head>\n""<body>%@</body>\n""</html>",[NSNumber numberWithInt:14],product.productDescription ] baseURL:nil];
   
    //hiding the backbutton from top bar
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
        
    UIBarButtonItem *nav_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    self.navigationItem.leftBarButtonItem = nav_btn;
     }@catch(NSException *e){}
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect: self.subview.bounds];
    self.subview.layer.masksToBounds = NO;
    self.subview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);  /*Change value of X n Y as per your need of shadow to appear to like right bottom or left bottom or so on*/
    self.subview.layer.shadowOpacity = 0.8f;
    self.subview.layer.shadowRadius=2.5f;
    self.subview.layer.shadowPath = shadowPath.CGPath;
}
-(void)back:(id)sender{
    [self performSegueWithIdentifier:BACKTOORDEROVERVIEW sender:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *simpleTableIdentifier = [self.cellId objectAtIndex:indexPath.row];
    
    shippingOverlayCell *cell = (shippingOverlayCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    @try{
    cell.estDeliveryLbl.text =order.deliveryDate;
    cell.speedLbl.text=[NSString stringWithFormat:@"%@ day delivery",order.speed];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"USD"];
    if(![order.shippingCost floatValue]<=0.0f){
        cell.priceLbl.text=[NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[order.shippingCost doubleValue]]]];
    }else
        cell.priceLbl.text=[NSString stringWithFormat:@"%@",order.freeshipping];
    }@catch(NSException *e){}
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //hiding the last cell separator
    if (cell && indexPath.row == 3 && indexPath.section == 0) {
        
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.0f);
    }
}

//- (IBAction)doneBtn:(id)sender {
//    [self performSegueWithIdentifier:BACKTOORDEROVERVIEW sender:self];
//}


- (void)viewDidUnload
{
    [super viewDidUnload];
   
    self.productImg=nil;
    self.brandImg=nil;
    productPriceBtn=nil;
    productNameLbl=nil;
    // Release any retained subviews of the main view.
}

-(void)viewDidDisappear:(BOOL)animated{
    self.productImg=nil;
    self.productDesc=nil;
    productDesc=nil;
    productNameLbl=nil;
    productPriceBtn=nil;
    productImg=nil;
    brandImg=nil;
    self.productNameLbl=nil;
    self.productPriceBtn=nil;
    self.brandImg=nil;
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    for(UIView *subview in [self.tableView subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
}
@end
