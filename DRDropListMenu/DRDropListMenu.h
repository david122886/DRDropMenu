//
//  DRDropListMenu.h
//  DRDropListMenu
//
//  Created by david on 13-9-23.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRDropListMenu : UIView

+(DRDropListMenu*)defaultDroplistMenuWithTouchView:(UIView*)touchView  withItemsTitleString:(NSArray*)itemsTitle selectedItemindex:(void(^)(int selectedIndex))selectedBlock;
@end
