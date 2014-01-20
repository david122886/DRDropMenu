//
//  DRDroplistMenu3.m
//  DRDropListMenu
//
//  Created by david on 13-10-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRDroplistMenu3.h"
#import <QuartzCore/QuartzCore.h>
#define PADDING 10
#define MENUITEM_PADDING 5
#define MENUITEM_WIDTH 100
#define MENUITEM_HEIGHT  35
#define MENUITEM_LINE_WIDTH 1
#define DegreesToRadians(degrees) (degrees * M_PI / 180)
@protocol DRDroplistMenuItemDelegate;
@interface DRDroplistMenuItem : UIView
@property(nonatomic,strong) NSArray *itemTitles;
@property(nonatomic,assign) CGPoint touchPoint;
@property(nonatomic,weak) id<DRDroplistMenuItemDelegate> delegate;
@property(nonatomic,assign) int selectedIndex;


-(id)initWithFrame:(CGRect)frame withItemStrings:(NSArray*)items;
@end

@protocol DRDroplistMenuItemDelegate <NSObject>

-(void)didSelectedIndexs:(int)index;
//-(void)didCancelindex:(int)index;

@end

@interface DRDroplistMenu3 ()<DRDroplistMenuItemDelegate>
@property(nonatomic,assign) void (^selectedBlock)(int selectedIndex);
@property (nonatomic,strong) UIWindow *listWindow;
@property(nonatomic,strong) NSArray *itemTitles;
@property(nonatomic,strong) DRDroplistMenuItem *dropView;
@property(nonatomic,strong) UIView *touchView;

@end



@implementation DRDroplistMenu3
static DRDroplistMenu3 *defaultDropListMent = nil;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarDidChangeFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [defaultDropListMent.dropView setNeedsDisplay];
}

+(DRDroplistMenu3*)showDroplistMenuWithTouchView:(UIView*)touchView  withItemsTitleString:(NSArray*)itemsTitle selectedItemindex:(void(^)(int selectedIndex))selectedBlock{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultDropListMent = [[DRDroplistMenu3 alloc] init];
    });
    
    for (UIView *subview in defaultDropListMent.view.subviews) {
        [subview removeFromSuperview];
    }
    defaultDropListMent.selectedBlock = selectedBlock;
    defaultDropListMent.touchView = touchView;
    defaultDropListMent.view.backgroundColor = [UIColor clearColor];
    defaultDropListMent.listWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    defaultDropListMent.listWindow.windowLevel = UIWindowLevelAlert;
//    [defaultDropListMent.listWindow addSubview:defaultDropListMent.view];
    defaultDropListMent.listWindow.rootViewController = defaultDropListMent;
    defaultDropListMent.view.frame = [[UIScreen mainScreen] bounds];
    [defaultDropListMent.listWindow setHidden:NO];
    defaultDropListMent.itemTitles = itemsTitle;
    defaultDropListMent.dropView = [[DRDroplistMenuItem alloc] initWithFrame:[defaultDropListMent getPupouViewFrameWithTouchView:touchView] withItemStrings:itemsTitle];
    defaultDropListMent.dropView.delegate =defaultDropListMent;
    defaultDropListMent.dropView.backgroundColor = [UIColor clearColor];
    [defaultDropListMent.view addSubview:defaultDropListMent.dropView];
    
    defaultDropListMent.listWindow.backgroundColor = [UIColor clearColor];
    
    return defaultDropListMent;
}

#pragma mark DRDroplistMenuItemDelegate

-(void)didSelectedIndexs:(int)index{
    NSLog(@"selected index:%d",index);
    [self hiddleView];
    if (self.selectedBlock) {
        self.selectedBlock(index);
    }
}
#pragma mark --
-(CGRect)getPupouViewFrameWithTouchView:(UIView*)touchView{
    int itemCount = self.itemTitles == nil? 0:[self.itemTitles count];
    int menuItemWidth = MENUITEM_WIDTH +MENUITEM_PADDING*2;
    int menuItemHeight = (MENUITEM_PADDING*2 + MENUITEM_HEIGHT)*itemCount + MENUITEM_LINE_WIDTH*(itemCount-1);
//    int menuItemHeight = (MENUITEM_PADDING*2 + MENUITEM_HEIGHT)*3 + MENUITEM_LINE_WIDTH*(3-1);
    UIView *superView = [touchView superview];
    CGRect dropDrownViewRect = [superView convertRect:touchView.frame toView:nil];
    CGRect dropDrawRect = [self.listWindow convertRect:dropDrownViewRect toView:self.view];
    //    NSLog(@"drop frame:%@,window frame:%@,%@",NSStringFromCGRect(self.dropDownView.frame),NSStringFromCGRect(dropDrownViewRect),NSStringFromCGRect(dropDrawRect));
    CGRect itemViewRect;
    
    //设置y轴位置
    if (CGRectGetMaxY(dropDrawRect) + menuItemHeight > CGRectGetMaxY(self.view.frame)) {//如果底部放不下，判断底部空隙如果大于顶部，就压缩菜单，否则上道上面
        if (CGRectGetMinY(dropDrawRect)> CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(dropDrawRect)) {//放上面
            int startY =  CGRectGetMinY(dropDrawRect) > menuItemHeight?(CGRectGetMinY(dropDrawRect) - menuItemHeight):0;
            itemViewRect = CGRectMake(CGRectGetMidX(dropDrawRect) - menuItemWidth/2,startY ,menuItemWidth, CGRectGetMinY(dropDrawRect) - startY);
        }else{//压缩并放下面
            int height = CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(dropDrawRect);
            itemViewRect = CGRectMake(CGRectGetMidX(dropDrawRect) - menuItemWidth/2, CGRectGetMaxY(dropDrawRect), menuItemWidth, height);
        }
    }else{//放入底部
        itemViewRect = CGRectMake(CGRectGetMidX(dropDrawRect) - menuItemWidth/2, CGRectGetMaxY(dropDrawRect), menuItemWidth, menuItemHeight);
    }
    
    //设置x轴位置
    if (CGRectGetMidX(dropDrawRect) >= menuItemWidth/2 && CGRectGetMaxX(self.view.frame) - CGRectGetMidX(dropDrawRect) >= menuItemWidth/2){//居中
        
    }else
        if (CGRectGetMidX(dropDrawRect) >= self.view.center.x) {//向左偏
            itemViewRect.origin.x = CGRectGetMaxX(self.view.frame) - menuItemWidth - MENUITEM_PADDING;
        }else{//向右偏
            itemViewRect.origin.x = MENUITEM_PADDING;
        }
    return itemViewRect;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    
    switch (orientation) {
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-DegreesToRadians(90));
            
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(DegreesToRadians(90));
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(DegreesToRadians(180));
            
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(DegreesToRadians(0));
    }
}

- (void)statusBarDidChangeFrame:(NSNotification *)notification {
    
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    
//    [self.listWindow setTransform:[self transformForOrientation:orientation]];
//    CGRect rect = [[UIScreen mainScreen] bounds];
//    
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        self.listWindow.frame = rect;
////        self.view.frame = (CGRect){0,0,rect.size.height,rect.size.width};
//        
//    }else{
//        self.listWindow.frame = (CGRect){0,0,rect.size.height,rect.size.width};
////        self.view.frame = rect;
//    }
////    self.dropView.frame = [self getPupouViewFrameWithTouchView:self.touchView];
//    [self.dropView setNeedsDisplay];
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddleView];
}

-(void)hiddleView{
    self.touchView = nil;
    [self.dropView removeFromSuperview];
    [self.view removeFromSuperview];
    self.listWindow = nil;
    self.dropView = nil;
    self.itemTitles = nil;
}

@end


@implementation DRDroplistMenuItem

-(id)initWithFrame:(CGRect)frame withItemStrings:(NSArray*)items{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemTitles = items;
        self.touchPoint = CGPointZero;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
    CGPoint c = (CGPoint){CGRectGetMidX(rect),CGRectGetMidY(rect)} ;
    // Drawing code
    CGContextRef cx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(cx);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGFloat comps[] = {1.0,1.0,0.0,0.6,
        1.0,1.0,0.0,0.3,
        1.0,1.0,0.0,0.2};
    CGFloat locs[] = {0,0.4,1};//0表示中心点开始 渐变，1表示结束圆四周
    CGGradientRef g = CGGradientCreateWithColorComponents(space, comps, locs, 3);
    CGColorSpaceRelease(space);
    float radius = rect.size.width > rect.size.height ?rect.size.width:rect.size.height;
    CGContextDrawRadialGradient(cx, g, c, 0.0f, c,radius*2, 0);//渐变向四周
    //    CGContextDrawLinearGradient//表示线性渐变
    CGGradientRelease(g);
    CGContextRestoreGState(cx);
    
    for (int index = 0; index < [self.itemTitles count]; index++) {
        CGContextSaveGState(cx);
        NSString *str = [self.itemTitles objectAtIndex:index];
        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:25]];
        CGContextSetFillColorWithColor(cx, [UIColor blackColor].CGColor);
        CGContextSetStrokeColorWithColor(cx, [UIColor blackColor].CGColor);
        CGContextSetLineWidth(cx, 2);
        CGContextSelectFont(cx, "Helvetica", 25.0, kCGEncodingMacRoman);
//        [ str drawAtPoint:CGPointMake( MENUITEM_PADDING, (MENUITEM_PADDING*2+MENUITEM_HEIGHT+MENUITEM_LINE_WIDTH)*index+MENUITEM_HEIGHT/2-size.height/2+MENUITEM_PADDING) withFont:[UIFont systemFontOfSize:18]];
        
        CGRect drawRect = (CGRect){MENUITEM_PADDING+MENUITEM_WIDTH/2-size.width/2,(MENUITEM_PADDING*2+MENUITEM_HEIGHT+MENUITEM_LINE_WIDTH)*index+MENUITEM_HEIGHT/2-size.height/2+MENUITEM_PADDING,MENUITEM_WIDTH,MENUITEM_HEIGHT};
        [str drawInRect:drawRect withFont:[UIFont fontWithName:@"Helvetica" size:25]];
       
        if (index > 0) {
            CGContextBeginPath(cx);
            CGContextSetStrokeColorWithColor(cx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor);
            CGContextSetLineWidth(cx, MENUITEM_LINE_WIDTH);
            CGContextMoveToPoint(cx, 0, (MENUITEM_PADDING*2+MENUITEM_HEIGHT)*index);
            CGContextAddLineToPoint(cx, 200, (MENUITEM_PADDING*2+MENUITEM_HEIGHT)*index);
            CGContextStrokePath(cx);
//            CGContextClosePath(cx);
        }
        CGRect fillRect = (CGRect){0,(MENUITEM_PADDING*2+MENUITEM_HEIGHT)*index,MENUITEM_WIDTH+MENUITEM_PADDING*2,MENUITEM_HEIGHT+MENUITEM_PADDING*2};
        if (CGRectContainsPoint(CGRectOffset(fillRect, 0, MENUITEM_PADDING), self.touchPoint)) {
//            CGContextSetFillColorWithColor(cx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor);
            CGContextSetRGBFillColor(cx, 0, 0, 0, 0.6);
            CGContextFillRect(cx,fillRect);
            self.selectedIndex = index;
        }
        CGContextRestoreGState(cx);
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchPoint =  [[touches anyObject] locationInView:self];
    self.selectedIndex = -1;
    [self setNeedsDisplay];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchPoint = CGPointZero;
    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIndexs:)] && self.selectedIndex != -1) {
        [self.delegate didSelectedIndexs:self.selectedIndex];
    }
}
@end
