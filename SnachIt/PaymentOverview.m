//
//  PaymentOverview.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "PaymentOverview.h"
#import "PaymentOverviewCell.h"
#import "AddNewCardForm.h"
#import "SnachCheckDetails.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "global.h"
#import "RegexValidator.h"
#import "SnachItDB.h"
#import "SnachItPaymentInfo.h"
NSString *const STPSEAGUE=@"backtoSTP";
@interface PaymentOverview()

@end

@implementation PaymentOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
    NSUserDefaults *defaults;
    NSArray *snachItPaymentInfo;
    int i;
}
@synthesize brandImg,productImg,productPriceBtn,productDesc,productNameLbl,checkedIndexPath,lastchecked;

- (void)viewDidLoad
{
    [super viewDidLoad];

    defaults=[NSUserDefaults standardUserDefaults];
    screenName=@"po";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self loadData];
    i=0;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
    
}

-(void)initializeView{
     self.navigationController.navigationBar.topItem.title = @"payment";
    @try{
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@",product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    
     productDesc.attributedText=[[NSAttributedString alloc] initWithData:[product.productDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    }@catch(NSException *e){}
    //hiding the backbutton from top bar
    //[self.navigationController.topViewController.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    btn.imageEdgeInsets=UIEdgeInsetsMake(5,5,4,5);
    UIBarButtonItem *eng_btn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = eng_btn;
    
}

-(void)back:(id)sender{
    [self performSegueWithIdentifier:@"backtoSTP" sender:nil];
    
}
- (IBAction)addNewCardBtn:(id)sender{
    [self performSegueWithIdentifier:@"addNewCardSeague" sender:self];
    
}
//- (IBAction)doneBtn:(id)sender {
//    [self performSegueWithIdentifier:STPSEAGUE sender:self];
//    
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [snachItPaymentInfo count];
}
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.

    PaymentOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];

    SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
  
    // Set the loaded data to the appropriate cell labels.
    cell.cardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[info.cardname stringByReplacingOccurrencesOfString:@" " withString:@""].lowercaseString]];
    cell.cardNameLbl.text = [NSString stringWithFormat:@"%@", info.cardname];
    
    
    //displaying last three digit of card number
    NSString *tempNumber=info.cardnumber;
    cell.cvvLbl.text =[NSString stringWithFormat:@"**** - %@",[tempNumber substringFromIndex:[tempNumber length]-3]];
    
    
   
    int rowid=info.uniqueId;
    cell.tag=rowid;
    //for auto selection
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    RECENTLY_ADDED_PAYMENT_INFO_TRACKER=[[def valueForKey:DEFAULT_BILLING] intValue];
    
    if(rowid==RECENTLY_ADDED_PAYMENT_INFO_TRACKER ){
        @try{
            if(i==0){
        [tableView selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
        self.checkedIndexPath=indexPath;
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:info.cardname withPaymentCardNumber:info.cardnumber withpaymentCardExpDate:info.cardexpdate  withPaymentCardCvv:[NSString stringWithFormat:@"%d",info.cvv] withPaymentFullName:info.name withPaymentStreetName:info.street  withPaymentCity:info.city withPaymentState:info.state withPaymentZipCode:[NSString stringWithFormat:@"%d",info.zip] withPaymentPhoneNumber: info.phone];
                i++;
            }
        }
        @catch(NSException *e){
            
        }
        
    }else{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView=nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:self.checkedIndexPath animated:NO];
    UITableViewCell *tmp = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
    tmp.accessoryView=nil;
  
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryView=nil;
         userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:nil withPaymentCardNumber:nil withpaymentCardExpDate:nil withPaymentCardCvv:nil withPaymentFullName:nil withPaymentStreetName:nil withPaymentCity:nil withPaymentState:nil withPaymentZipCode:nil withPaymentPhoneNumber:nil];
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
          userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:nil withPaymentCardNumber:nil withpaymentCardExpDate:nil withPaymentCardCvv:nil withPaymentFullName:nil withPaymentStreetName:nil withPaymentCity:nil withPaymentState:nil withPaymentZipCode:nil withPaymentPhoneNumber:nil];
    }
    else
    {
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
       [cell.accessoryView setFrame:CGRectMake(0, 0, 50, 50)];
        checkedIndexPath=indexPath;
        SnachItPaymentInfo *info=[snachItPaymentInfo objectAtIndex:indexPath.row];
        // initializing address details
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:info.cardname withPaymentCardNumber:info.cardnumber withpaymentCardExpDate:info.cardexpdate withPaymentCardCvv:[NSString stringWithFormat:@"%d",info.cvv] withPaymentFullName: info.name withPaymentStreetName:info.street withPaymentCity:info.city withPaymentState:info.state withPaymentZipCode:[NSString stringWithFormat:@"%d",info.zip] withPaymentPhoneNumber:info.phone];

        RECENTLY_ADDED_PAYMENT_INFO_TRACKER=cell.tag;
    }

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (cell.isSelected) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]]; // No reason to create a new one every time, right?
        [cell.accessoryView setFrame:CGRectMake(0, 0, 50, 50)];
            }
    else {
        cell.accessoryView = nil;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
    self.productImg=nil;
    self.brandImg=nil;
    productPriceBtn=nil;
    productNameLbl=nil;
    
    // Release any retained subviews of the main view.
}


-(void)loadData{
    // Form the query.
    CURRENTDB=SnachItDBFile;
    snachItPaymentInfo = [[SnachItDB database] snachItPaymentInfo:USERID];
    
    // Reload the table view.
    [self.paymentTableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.productImg=nil;
    self.productDesc=nil;
    productDesc=nil;
    productNameLbl=nil;
    productDesc=nil;
    productImg=nil;
    brandImg=nil;
    self.productNameLbl=nil;
    self.productPriceBtn=nil;
    self.brandImg=nil;
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
}
@end
