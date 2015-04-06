//
//  MyAccount.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/11/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "MyAccount.h"
#import "MyAccountOptions.h"
#import "SWRevealViewController.h"
#import "global.h"
#import "AFNetworking.h"
#import "UserProfile.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyAccount ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) NSArray *options,*icons;

@property (nonatomic, strong) NSArray *menuItems;
@end


@implementation MyAccount

{
    UserProfile *user;
    int  selectFlag;
}
@synthesize options ,icons,menuItems,userNameLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewLookAndFeel];
    
    
    selectFlag= 0;
    options = [NSArray arrayWithObjects:@"Snach Feed",@"My Profile", @"Account Settings",@"Billing Information",@"Shipping Information",@"Snach History", nil];
    icons= [NSArray arrayWithObjects:@"snach_feed_icon.png",@"myprofile.png",@"setting.png",@"billing.png",@"shpping_cart.png",@"snach_tag.png",nil];
    menuItems = [NSArray arrayWithObjects: @"snachfeed",@"myaccount", @"accountsetting", @"billing", @"shipping", @"snatchhistory",nil];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPhoto:)];
    singleTap.numberOfTapsRequired = 2;
    [self.defaultbackImg setUserInteractionEnabled:YES];
    [self.defaultbackImg  addGestureRecognizer:singleTap];
    }

-(void)setViewLookAndFeel{

    self.profilePic.layer.cornerRadius= RADIOUS;
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = BORDERWIDTH;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initialLize];
}

-(void)viewWillAppear:(BOOL)animated{
    user=[UserProfile sharedInstance];
}
-(void)initialLize{
    
    [self.profilePic setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:@"userIcon.png"]];
   
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.userNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];

    self.memberSinceLbl.text=[NSString stringWithFormat:@"Member since %@",[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    self.userNameLbl.adjustsFontSizeToFitWidth=YES;
    self.userNameLbl.minimumScaleFactor=0.5;
    
    //setting background img
    self.defaultbackImg.image=[UIImage imageNamed:@"defbackimg.png"];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:DEFAULT_BACK_IMG])
        self.defaultbackImg.image=[UIImage imageWithData:[defaults valueForKey:DEFAULT_BACK_IMG]];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [options count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *simpleTableIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    
    MyAccountOptions *cell=(MyAccountOptions *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
   
    
    cell.option.text = [options objectAtIndex:indexPath.row];
    cell.icon.image = [UIImage imageNamed:[icons objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
        
    selectFlag= 1;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    selectFlag=0;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
           picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *sourceImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
 

    self.defaultbackImg.image = [self scaleAndRotateImage:sourceImage];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:UIImagePNGRepresentation([self scaleAndRotateImage:sourceImage]) forKey:DEFAULT_BACK_IMG];
    [picker dismissViewControllerAnimated:YES completion:nil];
   
 
    
}
- (UIImage*)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = self.view.frame.size.width; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
    return imageCopy;
}


@end
