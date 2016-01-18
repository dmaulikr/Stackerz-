//
//  UpgradeMenu.m
//  Stackerz
//
//  Created by Admin on 8/13/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import "UpgradeMenu.h"
#import "BlockEngine.h"

#define IS_IPHONE5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation UpgradeMenu {
    NSArray *spacesArray;
    NSArray *blocksArray;
    NSArray *averageHeight;
    NSArray *topHeight;
    SKSpriteNode *block;
    SKSpriteNode *space;
}

#pragma mark Initialization 

-(id)initWithScore:(int)score total:(int)totalScore theSize:(CGSize) size theScene:(SKScene *) scene {
    
    self = [super init];
    
    if(!self) return (nil);
    
    _playerScore = score;
    
    _totalScore = totalScore;
        
    _myScene = scene;
    
    _winSize = size;
    
    _pageNumber = 0;
    
    [self buildMenu];
    
    [self render];
    
    [self populateUpgradeFeature];
    
    _newUpgrade = NO;
    
    _canUpgrade = YES;
    
    self.userInteractionEnabled = YES;
    
    return self;
}

#pragma mark building menu

-(void)buildMenu {
    _upgradeWindow = [SKSpriteNode spriteNodeWithImageNamed:RESULTS_OUTPUT_IMAGE];
    _nextPageButton = [SKSpriteNode spriteNodeWithImageNamed:NEXT_PAGE_BUTTON_IMAGE];
    _previousPageButton = [SKSpriteNode spriteNodeWithImageNamed:NEXT_PAGE_BUTTON_IMAGE];
    _yourTotalStackText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
    
    _yourTotalStackText.text = [NSString stringWithFormat:@"YOUR TOTAL STACK: %i", _totalScore];
    _yourTotalStackText.fontColor = [UIColor redColor];
    _yourTotalStackText.zPosition = 1;
    
    _nextPageButton.name = @"next page";
    _previousPageButton.name = @"previous page";
    
    if (IS_IPHONE5) {
        
        _upgradeWindow.position = CGPointMake(_winSize.width/2, _winSize.height - 220);
        [_upgradeWindow setScale:0.6f];
        
        _nextPageButton.position = CGPointMake(_winSize.width/2 + 70, _winSize.height - 400);
        [_nextPageButton setScale:0.25f];
        
        _previousPageButton.position = CGPointMake(_winSize.width/2 - 70, _winSize.height - 400);
        [_previousPageButton setScale:0.25f];
        _previousPageButton.xScale = -.25;
        
        _yourTotalStackText.position = CGPointMake(_winSize.width/2, _winSize.height - 170);
        [_yourTotalStackText setScale:.5];
        
        
    } else if (IS_IPHONE) {
        
        _upgradeWindow.position = CGPointMake(_winSize.width/2, _winSize.height - 220);
        [_upgradeWindow setScale:0.6f];
        
        _nextPageButton.position = CGPointMake(_winSize.width/2 + 70, _winSize.height - 400);
        [_nextPageButton setScale:0.25f];
        
        _previousPageButton.position = CGPointMake(_winSize.width/2 - 70, _winSize.height - 400);
        [_previousPageButton setScale:0.25f];
        _previousPageButton.xScale = -.25;
        
        _yourTotalStackText.position = CGPointMake(_winSize.width/2, _winSize.height - 170);
        [_yourTotalStackText setScale:.5];
        
    } else {
        
        _upgradeWindow.position = CGPointMake(_winSize.width/2, _winSize.height - 420);
        [_upgradeWindow setScale:1.15];
        
        _nextPageButton.position = CGPointMake(_winSize.width/2 + 170, _winSize.height - 650);
        [_nextPageButton setScale:0.45f];
        
        _previousPageButton.position = CGPointMake(_winSize.width/2 - 170, _winSize.height - 650);
        [_previousPageButton setScale:0.45f];
        _previousPageButton.xScale = -.45;
        
        _yourTotalStackText.position = CGPointMake(_winSize.width/2, _winSize.height - 330);
        [_yourTotalStackText setScale:1.25];
    }
}

#pragma mark populating the block and spaces


//All of this information is populated through the UpgradBlocks.plist
-(void)populateUpgradeFeature {
    
    NSDictionary *mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UpgradeBlocks" ofType:@"plist"]];
    
    spacesArray = [mainDictionary objectForKey:@"Spaces"];
    
    blocksArray = [mainDictionary objectForKey:@"Blocks"];
    
    topHeight = [mainDictionary objectForKey:@"TopMax"];
    
    averageHeight = [mainDictionary objectForKey:@"AverageHeights"];
    
    if (_pageNumber == 0) {
        _menuButton = [SKSpriteNode spriteNodeWithImageNamed:MENU_BUTTON_IMAGE];
        _menuButton.position = _previousPageButton.position;
        _menuButton.name = @"menu page";
        
        if (IS_IPHONE) {
           [_menuButton setScale:.25];
        } else {
            [_menuButton setScale:.45];
        }
        
        [_previousPageButton removeFromParent];
        
        [self addChild:_menuButton];
    } else {
        if (![_previousPageButton parent]) {
            [_menuButton removeFromParent];
            [self addChild:_previousPageButton];
        }
    }
    
    if (_pageNumber == blocksArray.count - 1) {
        [_nextPageButton setAlpha:0];
        
        if (IS_IPHONE) {
            _previousPageButton.position = CGPointMake(_winSize.width/2, _winSize.height - 400);
        } else {
            _previousPageButton.position = CGPointMake(_winSize.width/2, _winSize.height - 650);
        }
        
    } else {
        [_nextPageButton setAlpha:1];
        
        if (IS_IPHONE) {
            _previousPageButton.position = CGPointMake(_winSize.width/2 -70, _winSize.height - 400);
        } else {
            _previousPageButton.position = CGPointMake(_winSize.width/2 - 170, _winSize.height - 650);
        }
        
        
    }
    
    block = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@", blocksArray[_pageNumber]]];
    space = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@", spacesArray[_pageNumber]]];
    
    block.name = @"block";
    space.name = @"space";
    
    block.zPosition = 1;
    space.zPosition = 1;
    
    if (IS_IPHONE) {
        [block setPosition:CGPointMake(_upgradeWindow.position.x - 60, _upgradeWindow.position.y + 20)];
        [space setPosition:CGPointMake(_upgradeWindow.position.x + 60, _upgradeWindow.position.y + 20)];
    
        [block setScale:1.25];
        [space setScale:1.25];
    } else {
        [block setPosition:CGPointMake(_upgradeWindow.position.x - 160, _upgradeWindow.position.y + 20)];
        [space setPosition:CGPointMake(_upgradeWindow.position.x + 160, _upgradeWindow.position.y + 20)];
        
        [block setScale:2.5];
        [space setScale:2.5];
    }
    
    [self addChild:block];
    [self addChild:space];
    
    NSNumber * holderint = topHeight[_pageNumber];
    NSNumber * secondholderint = averageHeight[_pageNumber];
    
    if (self.playerScore >= [holderint integerValue] || self.totalScore >= [secondholderint integerValue]) {
        _canUpgrade = YES;
        
        if (!_upgradeText) {
            _upgradeText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
            _totalStackText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
            
            [_upgradeWindow addChild:_upgradeText];
            [_upgradeWindow addChild:_totalStackText];
        }
        
        if (IS_IPHONE5) {
            _upgradeText.position = CGPointMake(_upgradeText.position.x, _upgradeWindow.position.y - 420);
            _totalStackText.position = CGPointMake(_totalStackText.position.x, _upgradeWindow.position.y - 420);
        } else if (IS_IPHONE) {
            _upgradeText.position = CGPointMake(_upgradeText.position.x, _upgradeWindow.position.y - 330);
            _totalStackText.position = CGPointMake(_totalStackText.position.x, _upgradeWindow.position.y - 380);
        } else if (IS_IPAD) {
            _upgradeText.position = CGPointMake(_upgradeText.position.x, _upgradeWindow.position.y - 690);
            _totalStackText.position = CGPointMake(_totalStackText.position.x, _upgradeWindow.position.y - 690);
        }
        
        _upgradeText.text = [NSString stringWithFormat:@"Tap Block to Activate"];
        _totalStackText.text = @"";
        
    } else {
        _canUpgrade = NO;
        
        if (!_upgradeText) {
            _upgradeText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
            _totalStackText = [SKLabelNode labelNodeWithFontNamed:@"04b_19"];
            
            [_upgradeWindow addChild:_upgradeText];
            [_upgradeWindow addChild:_totalStackText];
        }
        
        if (IS_IPHONE5) {
            _upgradeText.position = CGPointMake(_upgradeText.position.x, _upgradeWindow.position.y - 390);
            _totalStackText.position = CGPointMake(_totalStackText.position.x, _upgradeWindow.position.y - 435);
        } else if (IS_IPHONE) {
            _upgradeText.position = CGPointMake(_upgradeText.position.x, _upgradeWindow.position.y - 300);
            _totalStackText.position = CGPointMake(_totalStackText.position.x, _upgradeWindow.position.y - 345);
        } else if (IS_IPAD) {
            _upgradeText.position = CGPointMake(_upgradeText.position.x, _upgradeWindow.position.y - 660);
            _totalStackText.position = CGPointMake(_totalStackText.position.x, _upgradeWindow.position.y - 700);
        }
        
        _upgradeText.text = [NSString stringWithFormat:@"Stack Height: %i", [holderint integerValue]];
        _totalStackText.text = [NSString stringWithFormat:@"Total Stack: %i", [secondholderint integerValue]];
    }
}

#pragma mark User Input

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    NSError *error;
    
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"tapclick" withExtension:@"wav"];
    
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    
    self.backgroundMusicPlayer.numberOfLoops = 0;
    
    [self.backgroundMusicPlayer prepareToPlay];
    
    if ([node.name isEqualToString:@"next page"]) {
        [self gotoNextPage];
        [self.backgroundMusicPlayer play];
    } else if ([node.name isEqualToString:@"previous page"]) {
        [self gotoPreviousPage];
        [self.backgroundMusicPlayer play];
    } if ([node.name isEqualToString:@"block"]) {
        [self selectBlock];
        [self.backgroundMusicPlayer play];
    } else if ([node.name isEqualToString:@"space"]) {
        [self selectSpace];
        [self.backgroundMusicPlayer play];
    } else if ([node.name isEqualToString:@"menu page"]) {
        [self gotoMenuPage];
        [self.backgroundMusicPlayer play];
    }
}

#pragma mark selecting the blocks and the spaces

-(void) selectBlock {
    if (_canUpgrade) {
        _blockSelected = [NSString stringWithFormat:@"%@", blocksArray[_pageNumber]];
        [[NSUserDefaults standardUserDefaults] setObject:_blockSelected forKey:@"block_save"];
    }
    
    _newUpgrade = YES;
}

-(void) selectSpace {
    if (_canUpgrade) {
       _spaceSelected = [NSString stringWithFormat:@"%@", spacesArray[_pageNumber]];
        [[NSUserDefaults standardUserDefaults] setObject:_spaceSelected forKey:@"space_save"];
    }
    _newUpgrade = YES;
}

#pragma mark moving pages

-(void) gotoPreviousPage {
    if (_pageNumber - 1 >= 0) {
        _pageNumber--;
        
        [block removeFromParent];
        [space removeFromParent];
        
        [self populateUpgradeFeature];
    }
}

-(void) gotoNextPage {
    if (_pageNumber + 1 <= blocksArray.count - 1) {
        _pageNumber++;
        
        [block removeFromParent];
        [space removeFromParent];
        
        [self populateUpgradeFeature];
    }
}

-(void) gotoMenuPage {
    _toMenu = YES;
}

#pragma  mark render graphics

-(void)render {
    [self addChild:_upgradeWindow];
    [self addChild:_nextPageButton];
    [self addChild:_previousPageButton];
    [self addChild:_yourTotalStackText];
}

#pragma mark getter methods
//returns the current block color
-(NSString *) getBlockColor {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"block_save"];
}

//returns the current space color
-(NSString *) getSpaceColor {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"space_save"];
}

@end
