//
//  ViewController.h
//  Stackerz!
//

//  Copyright (c) 2014 Caleb Keitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"

@interface ViewController : UIViewController <ADBannerViewDelegate, GADBannerViewDelegate>

//iAd Banner View
@property (nonatomic) ADBannerView *bannerView;
@property GADBannerView *gadBannerView;

@end
