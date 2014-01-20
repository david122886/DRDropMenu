//
//  ViewController2.m
//  DRDropListMenu
//
//  Created by david on 13-9-26.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController.h"
@interface ViewController2 ()

@end

@implementation ViewController2

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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ViewController *v =[story instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:v animated:NO completion:nil];
//    [self.navigationController pushViewController:v animated:NO];
    
}
@end
