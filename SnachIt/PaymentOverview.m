//
//  PaymentOverview.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/22/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "PaymentOverview.h"
#import "PaymentOverviewCell.h"
#import "AddNewCardForm.h"
#import "SnachCheckDetails.h"
#import "SnoopedProduct.h"
#import "SnoopingUserDetails.h"
#import "DBManager.h"
#import "global.h"
#import "RegexValidator.h"
NSString *const STPSEAGUE=@"backtoSTP";
@interface PaymentOverview()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPaymentInfo;
@end

@implementation PaymentOverview{
    SnoopedProduct *product;
    SnoopingUserDetails *userDetails;
    NSUserDefaults *defaults;
}
@synthesize brandImg,productImg,productPriceBtn,productDesc,productNameLbl,checkedIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"snachit.sql"];
    // Set the Label text with the selected recipe
    [self loadData];
    defaults=[NSUserDefaults standardUserDefaults];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [self refreshView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self initializeView];
    
}
-(void)refreshView{
    
    [self viewDidLoad];
    [self viewWillAppear:NO]; // If viewWillAppear also contains code
    
}
-(void)initializeView{
     self.navigationController.navigationBar.topItem.title = @"payment";
    product=[SnoopedProduct sharedInstance];
    productNameLbl.text = [NSString stringWithFormat:@"%@ %@",product.brandName,product.productName ];
    brandImg.image=[UIImage imageWithData:product.brandImageData];
    productImg.image=[UIImage imageWithData:product.productImageData];
    [productPriceBtn setTitle: product.productPrice forState: UIControlStateNormal];
    productDesc.text=product.productDescription;
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
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)addNewCardBtn:(id)sender{
    [self performSegueWithIdentifier:@"addNewCardSeague" sender:self];
    
}
- (IBAction)doneBtn:(id)sender {
    [self performSegueWithIdentifier:STPSEAGUE sender:self];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPaymentInfo.count;
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
   
    NSInteger indexOfCardName = [self.dbManager.arrColumnNames indexOfObject:@"cardName"];
    NSInteger indexOfCVV = [self.dbManager.arrColumnNames indexOfObject:@"cvv"];
  
    // Set the loaded data to the appropriate cell labels.
    cell.cardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCardName]].lowercaseString];
    cell.cardNameLbl.text = [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCardName]];
    
    
    cell.cvvLbl.text = 
    [NSString stringWithFormat:@"%@", [[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCVV]];
   
    int rowid=[[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    //for auto selection
    if(rowid==RECENTLY_ADDED_PAYMENT_INFO_TRACKER ||rowid==[[defaults valueForKey:DEFAULT_BILLING] intValue]){
          cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
       
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:1] withPaymentCardNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:2] withpaymentCardExpDate:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:3] withPaymentCardCvv:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:4] withPaymentFullName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:5] withPaymentStreetName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:6] withPaymentCity:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:7] withPaymentState:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:8] withPaymentZipCode:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:9] withPaymentPhoneNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:10]];
    }else{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView=nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tmp = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
    tmp.accessoryView=nil;
    self.checkedIndexPath=nil;
    if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView
                                        cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryView=nil;
        
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
        
    }
    else
    {
       
       

        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_mark.png"]];
        self.checkedIndexPath = indexPath;
        
        userDetails=[[SnoopingUserDetails sharedInstance] initWithPaymentCardName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:1] withPaymentCardNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:2] withpaymentCardExpDate:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:3] withPaymentCardCvv:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:4] withPaymentFullName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:5] withPaymentStreetName:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:6] withPaymentCity:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:7] withPaymentState:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:8] withPaymentZipCode:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:9] withPaymentPhoneNumber:[[self.arrPaymentInfo objectAtIndex:indexPath.row] objectAtIndex:10]];

        
    }

    // initializing address details
    

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
    NSString *query = @"select * from payment";
    
    // Get the results.
    if (self.arrPaymentInfo != nil) {
        self.arrPaymentInfo = nil;
    }
    self.arrPaymentInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.paymentTableView reloadData];
}

@end
