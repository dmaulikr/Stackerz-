//
//  GCHelper.m
//  Color Game
//  This is our Game Center helper class that holds all the methods we need to integrate game center, if there is problems with
//  the leaderboard, be sure to check this class

//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import "GCHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";

@implementation GCHelper {
    BOOL _enableGameCenter;
}

@synthesize gameCenterAvailable;

#pragma mark Initialization

//Adding shared helper
+ (instancetype)sharedGameKitHelper
{
    static GCHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GCHelper alloc] init];
    });
    return sharedGameKitHelper;
}

//Checking to see if Game Center is available for this device
- (BOOL)isGameCenterAvailable {
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


//initializing gchelper class
- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

#pragma mark User functions

//Authenticating user

- (void)authenticateLocalPlayer
{
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        [self setLastError:error];
        
        if(viewController != nil) {
            //4
            //[self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            _enableGameCenter = YES;
        } else {
            //6
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

#pragma mark - leaderboard

//Reporting leaderboard score, the identifier specifies which leaderboard to post to
+ (void) reportScore: (Float64) score forIdentifier: (NSString*) identifier
{
    GKScore* highScore = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    highScore.value = score;
    [GKScore reportScores:@[highScore] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Error in reporting scores: %@", error);
        }
    }];
}

@end
