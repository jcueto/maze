//
//  MazeViewController.m
//  Maze
//
//  Created by Jorge Carlos Cueto Barnett on 7/22/13.
//  Copyright (c) 2013 Jorge Carlos Cueto Barnett. All rights reserved.
//

#import "MazeViewController.h"

@interface MazeViewController ()

@end

@implementation MazeViewController

- (void)viewDidLoad
{
    
    CGPoint origin1 = self.bug1.center;
    CGPoint target1 = CGPointMake(self.bug1.center.x, self.bug1.center.y+124);
    CABasicAnimation *bounce1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce1.fromValue = [NSNumber numberWithInt:target1.y];
    bounce1.toValue = [NSNumber numberWithInt:origin1.y];
    bounce1.duration = 2;
    bounce1.repeatCount = HUGE_VALF;
    bounce1.autoreverses = YES;
    
    [self.bug1.layer addAnimation:bounce1 forKey:@"position"];
    
    CGPoint origin2 = self.bug2.center;
    CGPoint target2 = CGPointMake(self.bug2.center.x, self.bug2.center.y+284);
    CABasicAnimation *bounce2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce2.fromValue = [NSNumber numberWithInt:origin2.y];
    bounce2.toValue = [NSNumber numberWithInt:target2.y];
    bounce2.duration = 2;
    bounce2.repeatCount = HUGE_VALF;
    bounce2.autoreverses = YES;
    
    [self.bug2.layer addAnimation:bounce2 forKey:@"position"];

    CGPoint origin3 = self.bug3.center;
    CGPoint target3 = CGPointMake(self.bug3.center.x, self.bug3.center.y+200);
    CABasicAnimation *bounce3 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce3.fromValue = [NSNumber numberWithInt:target3.y];
    bounce3.toValue = [NSNumber numberWithInt:origin3.y];
    bounce3.duration = 2;
    bounce3.repeatCount = HUGE_VALF;
    bounce3.autoreverses = YES;
    
    [self.bug3.layer addAnimation:bounce3 forKey:@"position"];
    
    self.lastUpdateTime = [[NSDate alloc] init];
    
    self.currentPoint  = CGPointMake(0, 144);
    self.motionManager = [[CMMotionManager alloc]  init];
    self.queue         = [[NSOperationQueue alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
    
    [self.motionManager startAccelerometerUpdatesToQueue:self.queue withHandler:
     ^(CMAccelerometerData *accelerometerData, NSError *error) {
         [(id) self setAcceleration:accelerometerData.acceleration];
         [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    
    NSTimeInterval secondsSinceLastDraw = -([self.lastUpdateTime timeIntervalSinceNow]);
    
    self.dexterYVelocity = self.dexterYVelocity - (self.acceleration.x * secondsSinceLastDraw);
    self.dexterXVelocity = self.dexterXVelocity - (self.acceleration.y * secondsSinceLastDraw);
    
    CGFloat xDelta = secondsSinceLastDraw * self.dexterXVelocity * 500;
    CGFloat yDelta = secondsSinceLastDraw * self.dexterYVelocity * 500;
    
    self.currentPoint = CGPointMake(self.currentPoint.x + xDelta,
                                    self.currentPoint.y + yDelta);
    
    [self moveDexter];
    
    self.lastUpdateTime = [NSDate date];
}

- (void)moveDexter {
    
    [self collisionWithExit];
    [self collisionWithBugs];
    [self collisionWithWalls];
    [self collisionWithBoundaries];
    
    self.previousPoint = self.currentPoint;
    
    CGRect frame = self.dexter.frame;
    frame.origin.x = self.currentPoint.x;
    frame.origin.y = self.currentPoint.y;
    
    self.dexter.frame = frame;
    
    CGFloat newAngle = (self.dexterXVelocity + self.dexterYVelocity) * M_PI * 4;
    self.angle += newAngle * kUpdateInterval;
    
    CABasicAnimation *rotate;
    rotate                     = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue           = [NSNumber numberWithFloat:0];
    rotate.toValue             = [NSNumber numberWithFloat:self.angle];
    rotate.duration            = kUpdateInterval;
    rotate.repeatCount         = 1;
    rotate.removedOnCompletion = NO;
    rotate.fillMode            = kCAFillModeForwards;
    [self.dexter.layer addAnimation:rotate forKey:@"10"];
}

- (void)collisionWithBoundaries {
    
    if (self.currentPoint.x < 0) {
        _currentPoint.x = 0;
        self.dexterXVelocity = -(self.dexterXVelocity / 2.0);
    }
    
    if (self.currentPoint.y < 0) {
        _currentPoint.y = 0;
        self.dexterYVelocity = -(self.dexterYVelocity / 2.0);
    }
    
    if (self.currentPoint.x > self.view.bounds.size.width - self.dexter.image.size.width) {
        _currentPoint.x = self.view.bounds.size.width - self.dexter.image.size.width;
        self.dexterXVelocity = -(self.dexterXVelocity / 2.0);
    }
    
    if (self.currentPoint.y > self.view.bounds.size.height - self.dexter.image.size.height) {
        _currentPoint.y = self.view.bounds.size.height - self.dexter.image.size.height;
        self.dexterYVelocity = -(self.dexterYVelocity / 2.0);
    }
    
}

- (void)collisionWithExit {
    
    if (CGRectIntersectsRect(self.dexter.frame, self.mac.frame)) {
        
        [self.motionManager stopAccelerometerUpdates];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                        message:@"You helped Dexter find his Macbook Pro :)"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void)collisionWithBugs {
    
    CALayer *bugLayer1 = [self.bug1.layer presentationLayer];
    CALayer *bugLayer2 = [self.bug2.layer presentationLayer];
    CALayer *bugLayer3 = [self.bug3.layer presentationLayer];
    
    if (CGRectIntersectsRect(self.dexter.frame, bugLayer1.frame)
        || CGRectIntersectsRect(self.dexter.frame, bugLayer2.frame)
        || CGRectIntersectsRect(self.dexter.frame, bugLayer3.frame) ) {
        
        self.currentPoint  = CGPointMake(0, 144);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Mission Failed!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}


- (void)collisionWithWalls {
    
    CGRect frame = self.dexter.frame;
    frame.origin.x = self.currentPoint.x;
    frame.origin.y = self.currentPoint.y;
    
    for (UIImageView *image in self.wall) {
        
        if (CGRectIntersectsRect(frame, image.frame)) {
            
            CGPoint dexterCenter = CGPointMake(frame.origin.x + (frame.size.width / 2),
                                               frame.origin.y + (frame.size.height / 2));
            CGPoint imageCenter  = CGPointMake(image.frame.origin.x + (image.frame.size.width / 2),
                                               image.frame.origin.y + (image.frame.size.height / 2));
            CGFloat angleX = dexterCenter.x - imageCenter.x;
            CGFloat angleY = dexterCenter.y - imageCenter.y;
            
            if (abs(angleX) > abs(angleY)) {
                _currentPoint.x = self.previousPoint.x;
                self.dexterXVelocity = -(self.dexterXVelocity / 2.0);
            } else {
                _currentPoint.y = self.previousPoint.y;
                self.dexterYVelocity = -(self.dexterYVelocity / 2.0);
            }
            
        }
        
    }
    
}

@end
