//
//  GCHelper.h
//  Color Game
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface GCHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

@property (assign, readonly) BOOL gameCenterAvailable;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
+ (void) reportScore: (Float64) score forIdentifier: (NSString*) identifier;

@end
