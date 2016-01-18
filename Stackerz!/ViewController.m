//
//  ViewController.m
//  Stackerz!
//
//  Created by Admin on 8/24/14.
//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import "ViewController.h"
#import "BlockEngine.h"
#import "GCHelper.h"

@implementation ViewController

//Once the ViewController has loaded, this method will be called
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    //If you would like to debug and show status updates uncomment these lines
    
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [BlockEngine sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showAuthenticationViewController)
     name:PresentAuthenticationViewController
     object:nil];
    
    [[GCHelper sharedGameKitHelper]
     authenticateLocalPlayer];
}

- (void)showAuthenticationViewController
{
    GCHelper *gameKitHelper =
    [GCHelper sharedGameKitHelper];
    
    [self.view.window.rootViewController presentViewController:
     gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark adding IAds

-(void) addIAd:(id) sender {
    
    // Putting the iAd Banner Onto The Screen
    if (!_bannerView) {
        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    
        _bannerView.frame = CGRectMake(0, self.view.frame.size.height - _bannerView.frame.size.height, self.view.frame.size.width, _bannerView.frame.size.height);
    
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
        _bannerView.delegate = self;
    
        //Adding the banner to the view
        [self.view addSubview:_bannerView];
    
        _bannerView.hidden = YES;
    } else {
        _bannerView.hidden = NO;
    }
    
    if (_gadBannerView) {
        _gadBannerView.hidden = NO;
    }
    
}

-(void) hideIAd:(id) sender {
    if (!_bannerView.hidden) {
        _bannerView.hidden = YES;
    }
    
    if (!_gadBannerView.hidden) {
        _gadBannerView.hidden = YES;
    }
    
}

//Since the view controller is a delegate for iAd we must implement these methods
#pragma mark - iAd Methods

//If the banner view loaded an ad, unhide
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    _bannerView.hidden = NO;
}

//If there was no content, hide ad
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    _bannerView.hidden = YES;
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    _gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    // Specify the ad unit ID.
    _gadBannerView.adUnitID = GOOGLE_AD_ID;
    
    _gadBannerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - (_gadBannerView.frame.size.height / 2));
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _gadBannerView.rootViewController = self;
    
    [self.view addSubview:_gadBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_gadBannerView loadRequest:[GADRequest request]];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

//Setting selectors to be called from varying classes

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(addIAd:)
     name:@"ShowBannerAds"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hideIAd:)
     name:@"HideBannerAds"
     object:nil];
}

@end
