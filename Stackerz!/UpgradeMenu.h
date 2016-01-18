//
//  UpgradeMenu.h
//  Stackerz
//
//  Created by Admin on 8/13/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@import AVFoundation;

@interface UpgradeMenu : SKSpriteNode

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property int playerScore;
@property int totalScore;

@property CGSize winSize;
@property SKScene *myScene;

@property SKSpriteNode *upgradeWindow;

@property SKSpriteNode *nextPageButton;
@property SKSpriteNode *previousPageButton;
@property SKSpriteNode *menuButton;

@property SKLabelNode *upgradeText;
@property SKLabelNode *totalStackText;
@property SKLabelNode *yourTotalStackText;

@property int pageNumber;
@property NSString *blockSelected;
@property NSString *spaceSelected;

@property BOOL newUpgrade;
@property BOOL canUpgrade;
@property BOOL toMenu;

-(id)initWithScore:(int)score total:(int)totalScore theSize:(CGSize) size theScene:(SKScene *) scene;
-(NSString *) getBlockColor;
-(NSString *) getSpaceColor;


@end
