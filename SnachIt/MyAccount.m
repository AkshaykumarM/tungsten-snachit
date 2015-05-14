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
#import "UserProfile.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "T&CViewController.h"
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
    
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPhoto:)];
    //singleTap.numberOfTapsRequired = 2;
   // [self.defaultbackImg setUserInteractionEnabled:YES];
    //[self.defaultbackImg  addGestureRecognizer:singleTap];

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
    [super viewWillAppear:YES];
}
-(void)initialLize{
    
    [self.profilePic setImageWithURL:user.profilePicUrl placeholderImage:[UIImage imageNamed:DEFAULTPLACEHOLDER]];
   
    if(![user.fullName isKindOfClass:[NSNull class]])
        self.userNameLbl.text=[[NSString stringWithFormat:@"%@",user.fullName] uppercaseString];

    self.memberSinceLbl.text=[NSString stringWithFormat:@"%@%@",MEMBER_SINCE,[user.joiningDate substringFromIndex:[user.joiningDate length]-4]];
    self.userNameLbl.adjustsFontSizeToFitWidth=YES;
    self.userNameLbl.minimumScaleFactor=0.5;
    
    //setting background img
    //[self.defaultbackImg setImageWithURL:user.backgroundUrl placeholderImage:[UIImage imageNamed:DEFAULTBACKGROUNDIMG]];

    
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
    picker.view.tag=1;
           picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}
-(void) getProPic{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.view.tag=2;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if(picker.view.tag==1){
    //UIImage *sourceImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    //self.defaultbackImg.image = [self scaleAndRotateImage:sourceImage];
       
        
            //[self uploadImage:sourceImage ImageName:@"header" APIname:@"update-cover-pic/"];
            //[self.defaultbackImg setImage:sourceImage];
        
        
        

    [picker dismissViewControllerAnimated:YES completion:nil];
    }
    if(picker.view.tag==2){
        
        UIImage *sourceImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        
            [self uploadImage:sourceImage ImageName:@"avatar" APIname:@"update-profile-pic/"];
            [self.profilePic setImage:sourceImage];
        
       
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
   
 
    
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

-(void)uploadImage:(UIImage*)image ImageName:(NSString*)filename APIname:(NSString*)apiname
{
    dispatch_queue_t anotherThreadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    [SVProgressHUD showWithStatus:@"Uploading" maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(anotherThreadQueue, ^{
        //create request
        @try{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        //Set Params
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        
        //Create boundary, it can be anything
        NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        //Populate a dictionary with all the regular values you would like to send.
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setValue:user.userID forKey:@"customerId"];
        NSData *imageData = [self getCompressedImagetoOneMB:image];
        
        
        // add params (all params are strings)
        for (NSString *param in parameters) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        NSString *FileParamConstant = @"filename";
        
       
        //Assuming data is not nil we add this to the multipart form
        if (imageData)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@%@.jpg\"\r\n",FileParamConstant,filename,user.userID] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //Close off the request with the boundary
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the request
        [request setHTTPBody:body];
        
        // set URL
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ec2maschineIP,apiname]]];
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &error];
   
                                    if([[dict valueForKey:@"success"] isEqual:@"true"])
                                       {
                                           if([apiname isEqual:@"update-cover-pic/"])
                                               user.backgroundUrl=[dict valueForKey:@"headerImgURL"];
                                           else
                                           user.profilePicUrl=[dict valueForKey:@"ProfilePicUrl"];
                                           
                                           
                                       }
        }
        @catch(NSException *e){
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];;
            //if([apiname isEqual:@"update-cover-pic/"])
             //[self.defaultbackImg setImage:image];
            //else
            [self.profilePic setImage:image];
        });
        });
    
}
-(NSData *)getCompressedImagetoOneMB:(UIImage *)image{
    CGFloat compression = 0.5f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 250*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
        
    }

    return imageData;
}

- (IBAction)uploadMyProPic:(id)sender {
    [self getProPic];
    
    
}

@end
