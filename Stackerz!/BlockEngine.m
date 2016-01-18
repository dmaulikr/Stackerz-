//
//  Block.m
//  Stackerz
//
//  Created by Admin on 7/22/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import "BlockEngine.h"
#define IS_IPHONE5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation BlockEngine {
    SKSpriteNode *introLogo;
    SKLabelNode *tapToStartText;
    NSURL * backgroundMusicURL;
}

#pragma mark Initialization

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
        [self setupGame];
    }
    
    return self;
}

//Setting up the game
-(void) setupGame {
    // Initializing blocks and spaces
    _gameStarted = NO;
    
    _blockArray = [[NSMutableArray alloc] init];
    
    _space = [NSNumber numberWithInt:0];
    _block = [NSNumber numberWithInt:1];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"space_save"]) {
        [[NSUserDefaults standardUserDefaults] setObject:FIRST_SPACE_IMAGE_NAME forKey:@"space_save"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"block_save"]) {
        [[NSUserDefaults standardUserDefaults] setObject:FIRST_BLOCK_IMAGE_NAME forKey:@"block_save"];
    }
    
    _spaceTexture = [SKTexture textureWithImageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"space_save"]];
    _blockTexture = [SKTexture textureWithImageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"block_save"]];
    
    _currentRowIndex = 0;
    
    //Initializing the number of columns and the number of rows
    //It is set up to fill the screen with blocks and spaces
    //make sure the size of your blocks are divisible by the screen size
    
    _numOfColumns = NUMBER_OF_COLUMNS;
    
    if (IS_IPHONE) {
        _numOfRows = NUMBER_OF_ROWS_IPHONE;
    } else {
        _numOfRows = NUMBER_OF_ROWS_IPAD;
    }
    
    //determining how many number of blocks you would like to play with
    _numberOfBlocks = NUMBER_OF_BLOCKS;
    
    _stackHeight = 0;
    
    //determines what direction would you like the blocks to start going
    _blockDirection = @"right";
    
    //the initial duration you would like the blocks to move at
    _delayDuration = STARTING_DELAY_DURATION;
    _isScheduled = NO;
    
    [self createBlockArray];
    [self createStackHeightText];
    
    //This has to do with adding the intro logo and "tap to start stacking" text to the screen and making it float up and down
    introLogo = [SKSpriteNode spriteNodeWithImageNamed:@"StackerzLogo.png"];
    
    tapToStartText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    introLogo.position = CGPointMake(self.size.width/2, self.size.height + 10);
    
    [introLogo setScale:.55];
    
    SKAction *moveIntroLogo;
    
    if (IS_IPHONE) {
       introLogo.position = CGPointMake(self.size.width/2, self.size.height - 120);
    } else {
        introLogo.position = CGPointMake(self.size.width/2, self.size.height - 300);
    }
    
    //this is here so that the user has to wait a little bit before he/she can start playing, delaying the user interaction enablement
    [self performSelector:@selector(enableInteraction:) withObject:self afterDelay:.5];
    
    //Initializing the tap to start text and position
    tapToStartText.text = @"Tap to start stacking!";
    
    tapToStartText.fontColor = [UIColor whiteColor];
    
    tapToStartText.position = CGPointMake(self.size.width/2, self.size.height + 10);
    
    tapToStartText.fontSize = 24.0f;
    
    if (IS_IPHONE) {
        moveIntroLogo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height - 200) duration:0.5];
        
        if (IS_IPHONE5) {
            moveIntroLogo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height - 200) duration:0.5];
        }
    } else {
        moveIntroLogo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height - 400) duration:0.5];
    }
    
    [tapToStartText runAction:moveIntroLogo];
    
    if (IS_IPAD) {
        [introLogo setScale:1.25];
        [tapToStartText setScale:1.25];
    }
    
    self.userInteractionEnabled = NO;
    
    [self setupAudio];
}

-(void) setupAudio {
    NSError *error;
    
    backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"blockpop" withExtension:@"mp3"];
    
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    
    self.backgroundMusicPlayer.numberOfLoops = 0;
    
    [self.backgroundMusicPlayer prepareToPlay];
}

//enabling user interaction
-(void) enableInteraction:(id) sender {
    
    self.userInteractionEnabled = YES;
    
    [self floatButton:introLogo];
}

//floating the logo up and down
-(void) floatButton:(SKSpriteNode *) logo {
    [logo runAction:[SKAction moveTo:CGPointMake(logo.position.x, logo.position.y - 10) duration:1]];
    [self performSelector:@selector(floatButtonBack:) withObject:logo afterDelay:1.10];
}

-(void) floatButtonBack:(SKSpriteNode *) sender {
    [sender runAction:[SKAction moveTo:CGPointMake(sender.position.x, sender.position.y + 10) duration:1]];
    [self performSelector:@selector(floatButton:) withObject:sender afterDelay:1.10];
}

// Creating the text that tells the user how many blocks they've stacked
-(void) createStackHeightText {
    _stackHeightText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    _stackHeightText.fontSize = 34.0f;
    
    _stackHeightText.text = [NSString stringWithFormat:@"%i", _stackHeight];
    
    _stackHeightText.fontColor = [SKColor blackColor];
    
    [self renderStackHeightText];
}

-(void) updateStackHeight {
    _stackHeightText.text = [NSString stringWithFormat:@"%i", _stackHeight];
}

#pragma mark creating block array properties and instatiating

//creating the entire block array
-(void)createBlockArray {
    for (int i = _currentRowIndex; i < _numOfRows; i++) {
        
       NSMutableArray *_blockArrayColumn = [[NSMutableArray alloc] init];
        
        for (int k = 0; k < _numOfColumns; k++) {
            
            [_blockArrayColumn insertObject:_space atIndex:k];
        }
        
        [_blockArray insertObject:_blockArrayColumn atIndex:i];
    }
    
    [self renderBlockArray];
    [self createBlockSet];
}

//creating the tiles that move left and right
-(void)createBlockSet {
    
    for (int i = 0; i < _numberOfBlocks; i++) {
        
        [_blockArray[_currentRowIndex] replaceObjectAtIndex:[_blockArray[_currentRowIndex] count] / 2 + i withObject:_block];
    }
    _isScheduled = NO;
    
    if (!_isScheduled) {
        
        _masterTimer = [NSTimer scheduledTimerWithTimeInterval:_delayDuration target:self selector:@selector(timerUpdate:)userInfo:nil repeats:YES];
    }
    
}

#pragma mark Block Array Methods

//Actually moving the tiles left and right
-(void)moveBlocks {
    
    if ((int) _blockArray[_currentRowIndex][0] == (int) _block) {
        
#pragma mark Audio Settings
        
        //this is where the audio settings can be found, if you are trying to change the mp3's remember to rename the url for resource and wth extension
        // if applicable
        
        [self.backgroundMusicPlayer play];
        
        _blockDirection = @"right";
        
    } else if ((int) _blockArray[_currentRowIndex][[_blockArray[_currentRowIndex] count] - 1] == (int) _block) {
        
        [self.backgroundMusicPlayer play];
        _blockDirection = @"left";
        
    }
    
    if ([_blockDirection isEqualToString:@"right"]) {
        
        int x = (int) [_blockArray[_currentRowIndex] count] - 1;
        
        for (int i = x; i >= 0; i--) {
            
            if ((int) _blockArray[_currentRowIndex][i] == (int) _block) {
                
                if (i > 0) {
                    if ((int) _blockArray[_currentRowIndex][i - 1] == (int) _space) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i withObject:_space];
                    }
                    
                    if (i - 1 == 0) {
                        
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i - 1 withObject:_space];
                    }
                    
                    if (i + 1 <= [_blockArray[_currentRowIndex] count] - 1) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i + 1 withObject:_block];
                    }
                } else {
                    if (_numberOfBlocks == 1) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i + 1 withObject:_block];
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i withObject:_space];
                    }
                }
            }
        }
    } else if ([_blockDirection isEqualToString:@"left"]) {
        
        int x = (int) [_blockArray[_currentRowIndex] count] - 1;
        
        for (int i = 0; i <= x; i++) {
            
            if ((int) _blockArray[_currentRowIndex][i] == (int) _block) {
                
                if (i < x) {
                    if ((int) _blockArray[_currentRowIndex][i + 1] == (int) _space) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i withObject:_space];
                    }
                    
                    if (i + 1 == [_blockArray[_currentRowIndex] count] - 1) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i + 1 withObject:_space];
                    }
                    
                    if (i - 1 >= 0) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i - 1 withObject:_block];
                    }
                } else {
                    if (_numberOfBlocks == 1) {
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i - 1 withObject:_block];
                        [_blockArray[_currentRowIndex] replaceObjectAtIndex:i withObject:_space];
                    }
                }
                
            }
        }
    }
    
    //CCLOG(@"%@", _blockArray[_currentRowIndex]);
}

//Saving the current row you were on and moving to the next row, this also compares whether or not you matched blocks together
-(void)saveBlockArrayRows {
    [_masterTimer invalidate];
    
    if (_currentRowIndex > 0 && _currentRowIndex <= _numOfRows) {
        [self compareBlockArrayRows];
    }
    
    if (_currentRowIndex < _numOfRows) {
            _currentRowIndex++;
    }
    
    //if (_delayDuration - .04 > 0) {
      //  _delayDuration -= .04;
    //}
    
    [self createBlockSet];
}

//Creating the comparison of block array rows
-(void)compareBlockArrayRows {
    for (int i = 0; i <= [_blockArray[_currentRowIndex] count] - 1; i++) {
        
        if ((int) _blockArray[_currentRowIndex][i] == (int) _block &&
            (int) _blockArray[_currentRowIndex - 1][i] != (int) _block) {
            
            [_blockArray[_currentRowIndex] replaceObjectAtIndex:i withObject:_space];
            
            _numberOfBlocks--;
        }
    }
}


#pragma mark Timer Method

//Once the user has reached the top of the entire block array, this method moves all the blocks down to the bottom
-(void) sendTopRowToDown {
    [_blockArray replaceObjectAtIndex:0 withObject:_blockArray[_currentRowIndex]];
    
    [self renderBlockArray];
    
    [_masterTimer invalidate];
}

//Every timer update, this method is called which basically renders everything
-(void) timerUpdate:(CFTimeInterval) delta {
    _isScheduled = YES;
    [self moveBlocks];
    [self removeAllChildren];
    [self renderBlockArray];
    [self renderStackHeightText];
    
    if (!_gameStarted) {
        [self addChild:introLogo];
        [self addChild:tapToStartText];
    }
}

#pragma mark User Input

//This method is on the watch for user input
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_gameStarted) {
        _gameStarted = YES;
        
        [tapToStartText removeFromParent];
        [introLogo removeFromParent];
    }
    if (_currentRowIndex + 1 >= _numOfRows) {
        [self compareBlockArrayRows];
        [self sendTopRowToDown];
        _currentRowIndex = 1;
        [self createBlockArray];
    } else {
        [self saveBlockArrayRows];
    }
    
    if (_delayDuration >= .075) {
        _delayDuration -= .005;
    }
    
    if (_numberOfBlocks == 0) {
        [self gameOver];
    } else {
        _stackHeight++;
        [self updateStackHeight];
    }
}

//This checks for any activity outside of the BlockEngine class
-(void)update:(CFTimeInterval)currentTime {
    if (_gameOverMenu.retryClick) {
        [self setupGame];
        [_gameOverMenu setRetryClick:NO];
    }
    if (_gameOverMenu.doUpgrade) {
        _upgradeMenu = [[UpgradeMenu alloc] initWithScore:[_gameOverMenu getScore] total:[_gameOverMenu getTotalScore] theSize:self.size theScene:self];
        _upgradeMenu.zPosition = 1;
        [self addChild:_upgradeMenu];
        [_gameOverMenu setAlpha:0];
        [_gameOverMenu setDoUpgrade:NO];
    }
    if (_upgradeMenu.newUpgrade) {
        
        for (SKSpriteNode *block in self.children) {
            if ([block.texture isEqual:_blockTexture]) {
                [block removeFromParent];
            } else if([block.texture isEqual:_spaceTexture]) {
                [block removeFromParent];
            }
        }
        
        if ([_upgradeMenu getBlockColor]){
            _blockTexture = [SKTexture textureWithImageNamed:[_upgradeMenu getBlockColor]];
        }
        
        if ([_upgradeMenu getSpaceColor]) {
            _spaceTexture = [SKTexture textureWithImageNamed:[_upgradeMenu getSpaceColor]];
        }
        
        [self renderBlockArray];
        
        [_upgradeMenu setNewUpgrade:NO];
    }
    
    if (_upgradeMenu.toMenu) {
        [_upgradeMenu setToMenu:NO];
        [_upgradeMenu removeFromParent];
        [_gameOverMenu setAlpha:1];
        _gameOverMenu.zPosition = 1;
    }
}

#pragma mark Game Over Method
//called when the game is over
-(void)gameOver {
    self.userInteractionEnabled = NO;
    
    [self renderBlockArray];
    
    [_masterTimer invalidate];
    
    _gameOverMenu = [[GameOverMenu alloc] initWithScore:_stackHeight theSize:self.size theScene:self];
    
    [_stackHeightText removeFromParent];
    
    [self addChild:_gameOverMenu];
}

#pragma mark rendering Graphics
//this actually renders the block array
-(void) renderBlockArray {
    
    for (int i = 0; i < _numOfRows; i++) {
        
        for (int k = 0; k < _numOfColumns; k++) {
            
            if ((int) _blockArray[i][k] == (int) _block) {
                
                _renderBlock = [SKSpriteNode spriteNodeWithTexture:_blockTexture];
                
                [self addChild:_renderBlock];
                
                [_renderBlock setAnchorPoint:CGPointMake(0, 0)];
                
                _renderBlock.position = CGPointMake(_renderBlock.size.width * k, _renderBlock.size.height * i);
                
                
            } else if ((int) _blockArray[i][k] == (int) _space) {
                
                _renderSpace = [SKSpriteNode spriteNodeWithTexture:_spaceTexture];
                
                [self addChild:_renderSpace];
                
                [_renderSpace setAnchorPoint:CGPointMake(0, 0)];
                
                _renderSpace.position = CGPointMake(_renderSpace.size.width * k, _renderSpace.size.height * i);
            }
        }
    }
}

//this renders the stack height text
-(void) renderStackHeightText {
    if (IS_IPHONE) {
        _stackHeightText.position = CGPointMake(self.size.width / 2, self.size.height - 55);
        
        if (IS_IPHONE5) {
           _stackHeightText.position = CGPointMake(self.size.width / 2, self.size.height - 70);
        }
    } else if (IS_IPAD) {
        _stackHeightText.position = CGPointMake(self.size.width / 2, self.size.height - 80);
        [_stackHeightText setScale:1.25];
    }
    
    [self addChild:_stackHeightText];
}

@end
