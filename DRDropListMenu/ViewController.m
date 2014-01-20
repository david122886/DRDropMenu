//
//  ViewController.m
//  DRDropListMenu
//
//  Created by david on 13-9-23.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ViewController.h"
#import "KGModal.h"
#import "DRDroplistMenu3.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
//    UIView *subview = [[UIView alloc] initWithFrame:(CGRect){0,0,120,300}];
//    [[KGModal sharedInstance] showWithContentView:subview andAnimated:YES];

    
//    [self.navigationController.view addSubview:menu];
    self.view.backgroundColor = [UIColor blueColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"ViewController touchesBegan");
    NSLog(@"%@",[[UIApplication sharedApplication] windows]);
    ;
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    CGPoint point = [(UITouch*)[touches anyObject] locationInView:self.view];
    int width = 50;
    int height =50;
    UIView *subview = [[UIView alloc] initWithFrame:(CGRect){point.x - width/2,point.y - height/2,width,height}];
    [self.view addSubview:subview];
    subview.backgroundColor = [UIColor grayColor];
    [DRDroplistMenu3 showDroplistMenuWithTouchView:subview withItemsTitleString:@[@"mingtian",@"明天",@"今天",@"今天"] selectedItemindex:^(int selectedIndex) {
        NSLog(@"block:%d",selectedIndex);
    }];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"ViewController touchesEnded");
    [super touchesEnded:touches withEvent:event];
}

-(BOOL)shouldAutorotate{
    return NO;
}

@end
