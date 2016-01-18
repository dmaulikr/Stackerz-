//
//  Block.h
//  Stackerz
//
//  Created by Admin on 7/22/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import "ViewController.h"
#import "GameOverMenu.h"
#import "UpgradeMenu.h"

@import AVFoundation;

@interface BlockEngine : SKScene

//Music Player
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

//Game Started boolean that is set to true on user's first tap
@property BOOL gameStarted;

//Master Timer that updates the entire game
@property NSTimer * masterTimer;

//The block array and each block and space
@property NSMutableArray *blockArray;
@property NSNumber *block;
@property NSNumber *space;

//Number of blocks you would like the user to have
@property int numberOfBlocks;

//The Current Row the user is on
@property int currentRowIndex;

//The number of rows and columns you would like the user to have
@property int numOfColumns;
@property int numOfRows;

//The direction the block is in
@property NSString *blockDirection;

//determines how fast the blocks are moving
@property double delayDuration;

//The rendered space and block variable
@property SKSpriteNode *renderSpace;
@property SKSpriteNode *renderBlock;

//The texture the rendered space and block variable are pulling from
@property SKTexture *spaceTexture;
@property SKTexture *blockTexture;

//The stack the user has built
@property int stackHeight;
@property SKLabelNode * stackHeightText;

//Determines if master timer is scheduled or not
@property BOOL isScheduled;

//The two outside clases 
@property UpgradeMenu *upgradeMenu;
@property GameOverMenu *gameOverMenu;

-(id)initWithSize:(CGSize)size;

-(void) createBlockArray;
-(void) createBlockSet;
-(void) moveBlocks;
-(void) saveBlockArrayRows;
-(void) compareBlockArrayRows;
-(void) timerUpdate:(CFTimeInterval) delta;
-(void) setupGame;

@end
