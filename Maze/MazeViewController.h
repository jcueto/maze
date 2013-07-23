//
//  MazeViewController.h
//  Maze
//
//  Created by Jorge Carlos Cueto Barnett on 7/22/13.
//  Copyright (c) 2013 Jorge Carlos Cueto Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval (1.0f /60.0f)

@interface MazeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *dexter;
@property (strong, nonatomic) IBOutlet UIImageView *bug1;
@property (strong, nonatomic) IBOutlet UIImageView *bug2;
@property (strong, nonatomic) IBOutlet UIImageView *bug3;
@property (strong, nonatomic) IBOutlet UIImageView *mac;

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CGFloat dexterXVelocity;
@property (assign, nonatomic) CGFloat dexterYVelocity;
@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CMAcceleration acceleration;
@property (strong, nonatomic) CMMotionManager  *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSDate *lastUpdateTime;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *wall;

@end
