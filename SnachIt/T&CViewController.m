//
//  T&CViewController.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 5/12/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "T&CViewController.h"

@interface T_CViewController ()

@end

@implementation T_CViewController

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    
   
    CGRect frameimg = CGRectMake(0, 0, 20, 20);
    UIImageView *topCloseBtn = [[UIImageView alloc] initWithFrame:frameimg];
    UIButton *temp=[[UIButton alloc]initWithFrame:frameimg];
    //assigning the default background image
    [topCloseBtn setImage:[UIImage imageNamed:@"closeout_icon.png"]];
    topCloseBtn.clipsToBounds=YES;
    [temp setShowsTouchWhenHighlighted:YES];
    
    //setting up corner radious, border and border color width to make it circular
  
    [topCloseBtn setContentMode:UIViewContentModeScaleAspectFill];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    tapped.numberOfTapsRequired = 1;
    [topCloseBtn addGestureRecognizer:tapped];
    
    
    
    //assigning button to top bar iterm
    UIBarButtonItem *closebutton =[[UIBarButtonItem alloc] initWithCustomView:topCloseBtn];
    
    //adding bar item to left bar button item
    self.navigationItem.leftBarButtonItem=closebutton;
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
}
-(void)close{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
