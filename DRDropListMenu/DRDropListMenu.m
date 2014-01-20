//
//  DRDropListMenu.m
//  DRDropListMenu
//
//  Created by david on 13-9-23.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRDropListMenu.h"
#import <QuartzCore/QuartzCore.h>
#define PADDING 10
#define MENUITEM_PADDING 5
#define MENUITEM_WIDTH 100
#define MENUITEM_HEIGHT  40
#define MENUITEM_LINE_WIDTH 2  
@interface DRDropListMenuItem: UIView
@property (nonatomic,assign) UIEdgeInsets contentInsets;
@end

@implementation DRDropListMenuItem

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    }
    return self;
}
-(void)drawRect:(CGRect)rect{

}

@end

@interface DRDropListMenu()
@property(nonatomic,strong) UIWindow *window;
@property(nonatomic,strong) DRDropListMenuItem *menuItem;
@property(nonatomic,strong) UIView *dropDownView;
@property(nonatomic,strong) NSArray *itemTitles;
@end



@implementation DRDropListMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initWithTouchView:(UIView*)_touchView{
    if (!_touchView) {
        return;
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:self];
    [self.window setHidden:NO];
    self.window.windowLevel = UIWindowLevelAlert;
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor yellowColor];
    [self.window setBackgroundColor:[UIColor clearColor]];
    self.alpha = 0.5;
    self.menuItem = [[DRDropListMenuItem alloc] initWithFrame:CGRectZero];
    [self addSubview:self.menuItem];
    [self initMenuItemViewFrame];
    [self appearMenuAnimation];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self initMenuItemViewFrame];
}

-(void)initMenuItemViewFrame{
    int itemCount = self.itemTitles == nil? 0:[self.itemTitles count];
    int menuItemWidth = MENUITEM_WIDTH +MENUITEM_PADDING*2;
//    int menuItemHeight = (MENUITEM_PADDING*2 + MENUITEM_HEIGHT)*itemCount + MENUITEM_LINE_WIDTH*(itemCount-1);
    int menuItemHeight = (MENUITEM_PADDING*2 + MENUITEM_HEIGHT)*3 + MENUITEM_LINE_WIDTH*(3-1);
    UIView *dropSuper = [self.dropDownView superview];
    CGRect dropDrownViewRect = [dropSuper convertRect:self.dropDownView.frame toView:nil];
    CGRect dropDrawRect = [self.window convertRect:dropDrownViewRect toView:self];
//    NSLog(@"drop frame:%@,window frame:%@,%@",NSStringFromCGRect(self.dropDownView.frame),NSStringFromCGRect(dropDrownViewRect),NSStringFromCGRect(dropDrawRect));
    CGRect itemViewRect;
    
    //设置y轴位置
    if (CGRectGetMaxY(dropDrawRect) + menuItemHeight > CGRectGetMaxY(self.frame)) {//如果底部放不下，判断底部空隙如果大于顶部，就压缩菜单，否则上道上面
        if (CGRectGetMinY(dropDrawRect)> CGRectGetMaxY(self.frame) - CGRectGetMaxY(dropDrawRect)) {//放上面
            int startY =  CGRectGetMinY(dropDrawRect) > menuItemHeight?(CGRectGetMinY(dropDrawRect) - menuItemHeight):0;
            itemViewRect = CGRectMake(CGRectGetMidX(dropDrawRect) - menuItemWidth/2,startY ,menuItemWidth, CGRectGetMinY(dropDrawRect) - startY);
        }else{//压缩并放下面
            int height = CGRectGetMaxY(self.frame) - CGRectGetMaxY(dropDrawRect);
            itemViewRect = CGRectMake(CGRectGetMidX(dropDrawRect) - menuItemWidth/2, CGRectGetMaxY(dropDrawRect), menuItemWidth, height);
        }
    }else{//放入底部
        itemViewRect = CGRectMake(CGRectGetMidX(dropDrawRect) - menuItemWidth/2, CGRectGetMaxY(dropDrawRect), menuItemWidth, menuItemHeight);
    }
    
    //设置x轴位置
    if (CGRectGetMidX(dropDrawRect) >= menuItemWidth/2 && CGRectGetMaxX(self.frame) - CGRectGetMidX(dropDrawRect) >= menuItemWidth/2){//居中
        
    }else
    if (CGRectGetMidX(dropDrawRect) >= self.center.x) {//向左偏
        itemViewRect.origin.x = CGRectGetMaxX(self.frame) - menuItemWidth - MENUITEM_PADDING;
    }else{//向右偏
        itemViewRect.origin.x = MENUITEM_PADDING;
    }
    
    self.menuItem.frame = itemViewRect;
}

-(void)appearMenuAnimation{
    CGRect menuRect = self.menuItem.frame;
    self.menuItem.frame = (CGRect){menuRect.origin.x,menuRect.origin.y,menuRect.size.width,0};
    [UIView animateWithDuration:0.5 animations:^{
        self.menuItem.frame = (CGRect){menuRect.origin.x,menuRect.origin.y,menuRect.size.width,menuRect.size.height};
    } completion:^(BOOL finished) {
        self.menuItem.frame = menuRect;
    }];
}

-(void)hiddleMenuAnimation{
    CGRect menuRect = self.menuItem.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.menuItem.frame = (CGRect){menuRect.origin.x,menuRect.origin.y,menuRect.size.width,0};
    } completion:^(BOOL finished) {
        if (finished) {
            for (UIView *subView in self.subviews) {
                [subView removeFromSuperview];
            }
            [self removeFromSuperview];
            [self.window removeFromSuperview];
            self.menuItem = nil;
            self.window = nil;
            self.itemTitles = nil;
            self.dropDownView = nil;
        }
        
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    // 创建Quartz上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSaveGState(context);
//    // 创建色彩空间对象
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    
//    // 创建起点颜色
//    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.0f, 1.0f, 1.0f, 0.2f});
//    
//    CGColorRef middleColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.0f, 1.0f, 1.0f, 0.8f});
//    // 创建终点颜色
//    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.0f, 1.0f, 1.0f, 0.1f});
//    
//    // 创建颜色数组
//    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor,middleColor, endColor}, 3, nil);
//    
//    // 创建渐变对象
//    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
//        0.0f,       // 对应起点颜色位置
//        0.5,
//        1.0f        // 对应终点颜色位置
//    });
//    
//    // 释放颜色数组
//    CFRelease(colorArray);
//    
//    // 释放起点和终点颜色
//    CGColorRelease(beginColor);
//    CGColorRelease(endColor);
//    CGColorRelease(middleColor);
//    
//    // 释放色彩空间
//    CGColorSpaceRelease(colorSpaceRef);
//    
//    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(rect.size.width/2, 0.0f), CGPointMake(rect.size.width/2, rect.size.height), 0);
//    
//    // 释放渐变对象
//    CGGradientRelease(gradientRef);
//    
//    CGContextRestoreGState(context);
//    
//    CGContextSaveGState(context);
//    CGRect viewBounds = self.bounds;
//    CGContextTranslateCTM(context, 0, viewBounds.size.height);
//    CGContextScaleCTM(context, 1, -1);
//    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
//    char str[] = "ni hao,this is t ";
//    CGContextSetLineWidth(context, 2);
//    CGContextSetRGBFillColor(context, 0, 0, 1, 1);
//    CGContextSelectFont(context, "Helvetica", 25.0, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFillClip);
//    float length = [[[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding] sizeWithFont:[UIFont systemFontOfSize:25.0]].width;
//    CGContextShowTextAtPoint(context, rect.size.width/2 - length/2, rect.size.height/2, str,sizeof(str)-1);
//    CGContextRestoreGState(context);
//    
//    CGContextSaveGState(context);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
////    CGContextSetShadowWithColor(context, (CGSize){5,10}, 10, [UIColor redColor].CGColor);
//    CGContextSetShadow(context, (CGSize){5,10}, 5);
//    CGContextTranslateCTM(context, 100, 100);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:(CGRect){10,10,80,60} cornerRadius:5];
//    [path moveToPoint:(CGPoint){0,0}];
//    [path addLineToPoint:(CGPoint){30,10}];
//    [path addLineToPoint:(CGPoint){30,20}];
//    [path addLineToPoint:(CGPoint){10,20}];
//    [path addLineToPoint:(CGPoint){0,0}];
////    [path containsPoint:<#(CGPoint)#>]//判断点是否在画区域内
//    [path closePath];
//    [path fill];
//    [path addClip];
//    CGContextAddPath(context, path.CGPath);
//    CGContextClip(context);
//    
//    CGContextRestoreGState(context);
//
//}

//- (void)drawRect:(CGRect)rect
//{
//
//}


+(DRDropListMenu*)defaultDroplistMenuWithTouchView:(UIView*)touchView
                              withItemsTitleString:(NSArray*)itemsTitle
                                 selectedItemindex:(void(^)(int selectedIndex))selectedBlock{
    static DRDropListMenu *sharelistMenu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharelistMenu = [[self alloc] init];
    });
    sharelistMenu.itemTitles = itemsTitle;
    sharelistMenu.dropDownView = touchView;
    [sharelistMenu initWithTouchView:touchView];
    return sharelistMenu;
}
-(UIImage*)menuItemImageWithRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    CGContextRef cx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(cx);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10];
    CGContextAddPath(cx, path.CGPath);
    CGContextClip(cx);
    CGFloat comps[] = {1.0,1.0,0.2,0.8,
        1.0,1.0,0.2,0.5,
        1.0,1.0,0.2,0.8};
    CGFloat locs[] = {0,0.6,1};//0表示中心点开始 渐变，1表示结束圆四周
    CGGradientRef g = CGGradientCreateWithColorComponents(space, comps, locs, 3);
    CGColorSpaceRelease(space);
    //    CGContextDrawRadialGradient(cx, g, c, 0.0f, c,radius*2, 0);//渐变向四周
    CGContextDrawLinearGradient(cx, g, (CGPoint){rect.size.width/2,0},(CGPoint){rect.size.width/2,rect.size.height}, 0);//表示线性渐变
    CGGradientRelease(g);
    
    CGContextSetShadow(cx, (CGSize){5,5}, 5);
    CGContextRestoreGState(cx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*)backgroundImageWithRect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
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
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"DRDropListMenu");
    [self hiddleMenuAnimation];
}


@end

