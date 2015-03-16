//
//  AppShare.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/31/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;
@class ProfileTabView;

@interface AppShare : UIViewController
{
    ProfileTabView* profileTabView;
}



@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)fbBtn:(id)sender;
- (IBAction)twBtn:(id)sender;
- (IBAction)linkedInBtn:(id)sender;
-(void) removeLinkedInview;
- (IBAction)gPBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sharingURL;
- (IBAction)backBtn:(id)sender;

@end
