//
//  GameOverMenu.h
//  Stackerz
//
//  Created by Admin on 8/13/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import "GCHelper.h"
#import "UpgradeMenu.h"
#import "Chartboost.h"

@import AVFoundation;

@interface GameOverMenu : SKSpriteNode <GKGameCenterControllerDelegate, ChartboostDelegate>

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property SKSpriteNode *resultsOutput;
@property SKSpriteNode *retryButton;
@property SKSpriteNode *shareButton;
@property SKSpriteNode *leaderboardButton;
@property SKSpriteNode *upgradeButton;

@property SKLabelNode *gameOverText;
@property SKLabelNode *scoreText;
@property SKLabelNode *bestScoreText;
@property SKLabelNode *brandNewScoreText;
@property SKLabelNode *rewardText;

@property BOOL retryClick;
@property BOOL doUpgrade;

@property SKSpriteNode *medal;

@property int savedHighscore;
@property BOOL brandNewScoreReached;
@property int playerScore;
@property int totalPlayerScore;
@property CGSize winSize;
@property id myScene;

@property UpgradeMenu *upgradeMenu;

-(id)initWithScore:(int)score theSize:(CGSize) size theScene:(SKScene *) scene;
-(int) getScore;
-(int) getTotalScore;

@end