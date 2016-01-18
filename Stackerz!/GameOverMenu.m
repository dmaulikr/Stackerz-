//
//  GameOverMenu.m
//  Stackerz
//
//  Created by Admin on 8/13/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//
//
//  GameOverMenu.m
//  Color Game
//  This is the game over menu screen
//
//  Created by Admin on 7/30/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//
#define IS_IPHONE5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#import "GameOverMenu.h"

@implementation GameOverMenu

#pragma mark Initialize

-(id)initWithScore:(int)score theSize:(CGSize) size theScene:(SKScene *) scene {
    
    self = [super init];
    
    if(!self) return (nil);
    
    _playerScore = score;
    
    [self setHighscore:_playerScore];
    
    _myScene = scene;
    
    _winSize = size;
    
    _doUpgrade = NO;
    
    [self buildMenu];
    
    [self render];
    
    [self assignAchievement];
    
    self.userInteractionEnabled = YES;
    
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    // Must be called every time your app becomes active.
    [Chartboost startWithAppId:CHARTBOOST_APP_ID appSignature:CHARTBOOST_APP_SIGNATURE delegate:self];
    
    [[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBannerAds" object:self];
    
    return self;
}
-(int)getScore {
    return _playerScore;
}

-(int) getTotalScore {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"total_score_key"];
}

#pragma mark setting high score

//setting the high score for the user
-(void) setHighscore: (int) scr {
    if (scr > (long) [[NSUserDefaults standardUserDefaults] integerForKey:@"score_key"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:scr forKey:@"score_key"];
        _brandNewScoreReached = YES;
    }
        
    int totalint = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"total_score_key"] + scr;
    
    [[NSUserDefaults standardUserDefaults] setInteger:totalint forKey:@"total_score_key"];
    
    _savedHighscore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"score_key"];
}

-(void) assignAchievement {
    if (_playerScore >= 20 && _playerScore <= 30) {
        _medal = [SKSpriteNode spriteNodeWithImageNamed:@"BronzeMedal.png"];
        
        [self addChild:_medal];
    } else if (_playerScore >= 30 && _playerScore <= 40) {
        _medal = [SKSpriteNode spriteNodeWithImageNamed:@"SilverMedal.png"];
        
        [self addChild:_medal];
    } else if (_playerScore >= 40) {
        _medal = [SKSpriteNode spriteNodeWithImageNamed:@"GoldMedal.png"];
        
        [self addChild:_medal];
    }
    
    if (_medal) {
        [_medal setScale:1.25];
        _medal.position = CGPointMake(_resultsOutput.position.x + 80, _resultsOutput.position.y - 15);
    }
}

#pragma mark building menus

//building the menu for the game over screen
-(void) buildMenu {
    
    _gameOverText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    _gameOverText.text = @"GAME OVER";
    
    _gameOverText.fontSize = 45.0f;
    
    _gameOverText.fontColor = [SKColor blackColor];
    
    _scoreText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    _scoreText.fontColor  = [SKColor blackColor];
    
    _scoreText.text = [NSString stringWithFormat:@"SCORE: %i", _playerScore];
    
    _scoreText.fontSize = 30.0f;
    
    _bestScoreText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    _bestScoreText.text = [NSString stringWithFormat:@"BEST: %i", _savedHighscore];
    
    _bestScoreText.fontSize = 30.0f;
    
    _bestScoreText.fontColor = [SKColor blackColor];
    
    if (_brandNewScoreReached) {
        
        _brandNewScoreText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
        
        _brandNewScoreText.text = @"NEW!";
        
        _brandNewScoreText.fontSize = 12.0f;
        
        _brandNewScoreText.fontColor = [SKColor redColor];
        
        _brandNewScoreReached = NO;
    }
    _rewardText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    _rewardText.text = @"REWARD";
    
    _rewardText.fontSize = 20.0f;
    
    _rewardText.fontColor = [SKColor blackColor];
    
    _resultsOutput = [SKSpriteNode spriteNodeWithImageNamed:RESULTS_OUTPUT_IMAGE];
    
    _retryButton = [SKSpriteNode spriteNodeWithImageNamed:RETRY_BUTTON_IMAGE];
    
    _retryButton.name = @"retry button";
    
    _upgradeButton = [SKSpriteNode spriteNodeWithImageNamed:UPGRADE_BUTTON_IMAGE];
    
    _upgradeButton.name = @"upgrade button";
    
    _shareButton = [SKSpriteNode spriteNodeWithImageNamed:SHARE_BUTTON_IMAGE];
    
    _shareButton.name = @"share button";
    
    _leaderboardButton = [SKSpriteNode spriteNodeWithImageNamed:LEADERBOARD_BUTTON_IMAGE];
    
    _leaderboardButton.name = @"leaderboard button";
    
    
    if (IS_IPHONE5) {
        
        _resultsOutput.position = CGPointMake(_winSize.width/2, _winSize.height - 180);
        [_resultsOutput setScale:0.6f];
        
        _retryButton.position = CGPointMake(_winSize.width/2 - 70, _winSize.height - 320);
        [_retryButton setScale:0.25f];
        
        _upgradeButton.position = CGPointMake(_winSize.width/2 + 70, _winSize.height - 320);
        [_upgradeButton setScale:0.25f];
        
        _shareButton.position = CGPointMake(_winSize.width/2 + 70, _winSize.height - 400);
        [_shareButton setScale:0.25f];
        
        _leaderboardButton.position = CGPointMake(_winSize.width/2 - 70, _winSize.height - 400);
        [_leaderboardButton setScale:0.25f];
        
        _gameOverText.position = CGPointMake(_winSize.width/2, _winSize.height - 65);
        _scoreText.position = CGPointMake(_resultsOutput.position.x - 70, _resultsOutput.position.y + 10);
        _bestScoreText.position = CGPointMake(_resultsOutput.position.x - 70, _resultsOutput.position.y - 40);
        _brandNewScoreText.position = CGPointMake(_bestScoreText.position.x + 65, _bestScoreText.position.y + 22);
        _rewardText.position = CGPointMake(_resultsOutput.position.x + 80, _resultsOutput.position.y + 20);
        
        
    } else if (IS_IPHONE) {
        
        _resultsOutput.position = CGPointMake(_winSize.width/2, _winSize.height - 180);
        [_resultsOutput setScale:0.6f];
        
        _retryButton.position = CGPointMake(_winSize.width/2 - 70, _winSize.height - 320);
        [_retryButton setScale:0.25f];
        
        _upgradeButton.position = CGPointMake(_winSize.width/2 + 70, _winSize.height - 320);
        [_upgradeButton setScale:0.25f];
        
        _shareButton.position = CGPointMake(_winSize.width/2 + 70, _winSize.height - 400);
        [_shareButton setScale:0.25f];
        
        _leaderboardButton.position = CGPointMake(_winSize.width/2 - 70, _winSize.height - 400);
        [_leaderboardButton setScale:0.25f];
        
        _gameOverText.position = CGPointMake(_winSize.width/2, _winSize.height - 65);
        _scoreText.position = CGPointMake(_resultsOutput.position.x - 70, _resultsOutput.position.y + 10);
        _bestScoreText.position = CGPointMake(_resultsOutput.position.x - 70, _resultsOutput.position.y - 40);
        _brandNewScoreText.position = CGPointMake(_bestScoreText.position.x + 65, _bestScoreText.position.y + 22);
        _rewardText.position = CGPointMake(_resultsOutput.position.x + 80, _resultsOutput.position.y + 20);
        
    } else {
        
        _resultsOutput.position = CGPointMake(_winSize.width/2, _winSize.height - 300);
        [_resultsOutput setScale:1.15];
        
        _retryButton.position = CGPointMake(_winSize.width/2 - 150, _winSize.height - 550);
        [_retryButton setScale:0.45f];
        
        _upgradeButton.position = CGPointMake(_winSize.width/2 + 150, _winSize.height - 550);
        [_upgradeButton setScale:0.45f];
        
        _shareButton.position = CGPointMake(_winSize.width/2 + 150, _winSize.height - 750);
        [_shareButton setScale:0.45f];
        
        _leaderboardButton.position = CGPointMake(_winSize.width/2 - 150, _winSize.height - 750);
        [_leaderboardButton setScale:0.45f];
        
        _gameOverText.position = CGPointMake(_winSize.width/2, _winSize.height - 125);
        _gameOverText.fontSize = 100.0f;
        
        _scoreText.position = CGPointMake(_resultsOutput.position.x - 130, _resultsOutput.position.y + 30);
        _scoreText.fontSize = 60.0f;
        
        _bestScoreText.position = CGPointMake(_resultsOutput.position.x - 130, _resultsOutput.position.y - 70);
        _bestScoreText.fontSize = 60.0f;

        _brandNewScoreText.position = CGPointMake(_bestScoreText.position.x + 65, _bestScoreText.position.y + 22);
        _brandNewScoreText.fontSize = 48.0f;
        
        _rewardText.position = CGPointMake(_resultsOutput.position.x + 150, _resultsOutput.position.y + 55);
        _rewardText.fontSize = 60.0f;
    }
}

#pragma mark Rendering graphics
-(void) render {
    
    [self addChild:_resultsOutput];
    [self addChild:_gameOverText];
    [self addChild:_scoreText];
    [self addChild:_bestScoreText];
    [self addChild:_retryButton];
    [self addChild:_upgradeButton];
    [self addChild:_shareButton];
    [self addChild:_leaderboardButton];
    [self addChild:_rewardText];
    
    if (_brandNewScoreText) {
        [self addChild:_brandNewScoreText];
    }
}

#pragma mark User Input

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"tapclick" withExtension:@"wav"]
    ;
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    
    self.backgroundMusicPlayer.numberOfLoops = 0;
    
    [self.backgroundMusicPlayer prepareToPlay];
    
    if ([node.name isEqualToString:@"retry button"]) {
        [self retryLevel];
        
        [self.backgroundMusicPlayer play];
    } else if ([node.name isEqualToString:@"share button"]) {
        [self shareScore];
        [self.backgroundMusicPlayer play];
    } else if ([node.name isEqualToString:@"leaderboard button"]) {
        [self postToLeaderboard];
        [self.backgroundMusicPlayer play];
    } else if ([node.name isEqualToString:@"upgrade button"]) {
        [self upgradeFeatures];
        [self.backgroundMusicPlayer play];
    }
}

-(void)retryLevel {
    [self removeFromParent];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBannerAds" object:self];
    _retryClick = YES;
}

-(void)shareScore {
    NSString *shareText = [NSString stringWithFormat:EMAIL_TEXT, _playerScore];
    
    NSArray *itemsToShare = @[shareText];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard];
    
    [rootViewController presentViewController:activityVC animated:YES completion:nil];
}

-(void)postToLeaderboard {
    
    [GCHelper reportScore:_playerScore forIdentifier:LEADERBOARD_ID];
    
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController: gameCenterController animated: YES completion:nil];
    }
}

-(void)upgradeFeatures {
    _doUpgrade = YES;
    
}

#pragma mark delegate methods

//Once the player has actually finished looking at the leaderboard
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc dismissViewControllerAnimated:YES completion:nil];
}


/*
 * Chartboost Delegate Methods
 *
 */


/*
 * shouldDisplayInterstitial
 *
 * This is used to control when an interstitial should or should not be displayed
 * The default is YES, and that will let an interstitial display as normal
 * If it's not okay to display an interstitial, return NO
 *
 * For example: during gameplay, return NO.
 *
 * Is fired on:
 * -Interstitial is loaded & ready to display
 */

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return YES;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
}

/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: (BOOL)hasCachedInterstitial:(NSString *)location;
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
}

/*
 * didFailToLoadMoreApps
 *
 * This is called when the more apps page has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No more apps page has been created (add a more apps page in the dashboard)
 * - No publishing campaign matches for that user (add more campaigns to your more apps page)
 *  -Find this inside the App > Edit page in the Chartboost dashboard
 */

- (void)didFailToLoadMoreApps:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load More Apps, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load More Apps, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load More Apps, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load More Apps, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load More Apps, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load More Apps, first session !");
        } break;
        case CBLoadErrorNoAdFound: {
            NSLog(@"Failed to load More Apps, Apps not found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        default: {
            NSLog(@"Failed to load More Apps, unknown error !");
        }
    }
}

/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache interstitials
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
    [[Chartboost sharedChartboost] cacheInterstitial:location];
}

/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 * #Pro Tip: Use the delegate method below to immediately re-cache the more apps page
 */

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    [[Chartboost sharedChartboost] cacheMoreApps:CBLocationHomeScreen];
}

/*
 * shouldRequestInterstitialsInFirstSession
 *
 * This sets logic to prevent interstitials from being displayed until the second startSession call
 *
 * The default is YES, meaning that it will always request & display interstitials.
 * If your app displays interstitials before the first time the user plays the game, implement this method to return NO.
 */

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return YES;
}

@end