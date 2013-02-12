//
//  MDAppDelegate.h
//  MoeDict
//
//  Created by jamie on 2/12/13.
//  Copyright (c) 2013 jamie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDViewController;

@interface MDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MDViewController *viewController;

@end
