//
//  DRDroplistMenu3.h
//  DRDropListMenu
//
//  Created by david on 13-10-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRDroplistMenu3 : UIViewController
+(DRDroplistMenu3*)showDroplistMenuWithTouchView:(UIView*)touchView  withItemsTitleString:(NSArray*)itemsTitle selectedItemindex:(void(^)(int selectedIndex))selectedBlock;
@end
