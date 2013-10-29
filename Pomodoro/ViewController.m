//
//  ViewController.m
//  Pomodoro
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define TIME 1500 // 25 minutes

@interface ViewController (){
    UIView *view;
    UIView *slider;
    NSInteger timer;
    UITapGestureRecognizer *tap;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
    view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    slider = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    [self.view addSubview:slider];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)];
    [view addGestureRecognizer:tap];
    [self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) pause{
    [slider setBackgroundColor:[UIColor colorWithRed:0.18 green:0.3 blue:0.7 alpha:1.0]];
    [tap setEnabled:YES];
}

-(void)start{
    timer = 0;
    [tap setEnabled:NO];
    [self theInfiniteLoop];
}

-(void) theInfiniteLoop{
    timer++;
    [self updateShapes];
    if(timer >= (TIME)){
        [self pause];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else
        [self performSelector:@selector(theInfiniteLoop) withObject:Nil afterDelay:1.0];
}

-(void) updateShapes{
    [view setBackgroundColor:[UIColor colorWithWhite:(float)timer/TIME alpha:1.0]];
    [slider setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:(float)timer/TIME]];
    [slider setCenter:CGPointMake(view.center.x, view.center.y+(1-(float)timer/TIME)*view.bounds.size.height)];
}

@end
