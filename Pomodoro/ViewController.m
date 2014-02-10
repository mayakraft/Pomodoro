//
//  ViewController.m
//  Pomodoro
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//
//  musicbyboys.com

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#define TIME 1500 // 1500 = 25 minutes

@interface ViewController (){
    UIView *view, *slider;
    NSInteger seconds;
    UITapGestureRecognizer *tap;
    NSDate *beginTime;
    NSTimer *timer;
    NSArray *sounds;
    SystemSoundID alert;
    UILocalNotification* localNotification;
}

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;  // disable sleep mode
    sounds = @[@"Fazer",@"Marbles",@"Plunk Hi",@"Soft Ring",@"Poseidon"];
    view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    slider = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:view];
    [self.view addSubview:slider];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)];
    [view addGestureRecognizer:tap];
    [self start];
}

-(void)start{
    [tap setEnabled:NO];
    NSString *soundPath =  [[NSBundle mainBundle] pathForResource:sounds[arc4random()%sounds.count] ofType:@"m4r"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &alert);
    beginTime = [NSDate date];
    [self scheduleLocalNotification];
    [self theInfiniteLoop];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/1
                                             target:self selector:@selector(theInfiniteLoop) userInfo:nil repeats:YES];
}

-(void) theInfiniteLoop{
    seconds = -[beginTime timeIntervalSinceNow];
    [self updateShapes];
    if(seconds == (TIME)){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(alert);
        [self end];
    }
    else if (seconds > TIME){  // app was in the background
        seconds = TIME;
        [self updateShapes];
        [self end];
    }
}

-(void) end{
    [slider setBackgroundColor:[UIColor colorWithRed:0.6 green:0.08 blue:0.03 alpha:1.0]];
    [timer invalidate];
    [tap setEnabled:YES];
}

-(void) updateShapes{
    [view setBackgroundColor:[UIColor colorWithWhite:(float)seconds/TIME alpha:1.0]];
    [slider setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:(float)seconds/TIME]];
    [slider setCenter:CGPointMake(view.center.x, view.center.y+(1-(float)seconds/TIME)*view.bounds.size.height)];
}

- (void)scheduleLocalNotification {
//    NSString *emoji = @"🍎🍏🍊🍋🍒🍇🍉🍓🍑🍈🍌🍐🍍🍠🍆🍅🌽";
    localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:TIME];
    localNotification.alertBody = @"🍅";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
