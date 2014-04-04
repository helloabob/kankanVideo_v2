//
//  KKMoviePlayerViewController.m
//  kankanVideo_v2
//
//  Created by wangbo-ms on 13-3-6.
//  Copyright (c) 2013年 wangbo. All rights reserved.
//

#import "KKMoviePlayerViewController.h"

@interface KKMoviePlayerViewController ()

@end

@implementation KKMoviePlayerViewController
@synthesize url = _url;
@synthesize playerController = _playerController;
@synthesize backgroundView = _backgroundView;

- (id)initWithVideoUrl:(NSString *)theUrl {
    self = [super init];
    if (self) {
        self.url = theUrl;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _playerController = [[MPMoviePlayerController alloc] init];
    
    [self installMovieNotificationObservers];
    
    self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width)] autorelease];
    self.backgroundView.backgroundColor = [UIColor redColor];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_backgroundView];
    
    _playerController.contentURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"MOV"]];
    
//    _playerController.contentURL = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"];
//    _playerController.contentURL = [NSURL URLWithString:self.url];
    //NSLog(@"%@",self.url);
    [_playerController prepareToPlay];
    [_playerController.view setFrame:self.view.bounds];
    _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    _playerController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width);
    
    _playerController.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:_playerController.view];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    [_playerController play];

    UIView *btnTouch = [[UIView alloc] initWithFrame:self.view.bounds];
    btnTouch.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    btnTouch.backgroundColor = [UIColor clearColor];
//    btnTouch.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)];
    [btnTouch addGestureRecognizer:tap];
    [tap release];
//    [btnTouch addTarget:self action:@selector(screenTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTouch];
    [btnTouch release];
    
//    NSLog(@"%@",_url);
//    NSLog(@"=========================");
//    for (UIView *view in _playerController.view.subviews) {
//        NSLog(@"view:%@",view);
//    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"toucheBegan");
}

- (void)screenTapped {
    NSLog(@"screen_tapped");
    self.playerController.currentPlaybackTime = 1.0f;
}


/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = [self playerController];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = [self playerController];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

/* Delete the movie player object, and remove the movie notification observers. */
-(void)deletePlayerAndNotificationObservers
{
    [self.backgroundView removeFromSuperview];
    MPMoviePlayerController *player = [self playerController];
    [player.view removeFromSuperview];
    [self removeMovieNotificationHandlers];
    //        [self dismissModalViewControllerAnimated:YES];
//    if (![self isBeingDismissed]||![self isBeingPresented]) {
    [self performSelector:@selector(dismissDelay) withObject:nil afterDelay:0.5f];
//    }
}

- (void)dismissDelay {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    self.backgroundView = nil;
    self.playerController = nil;
    self.url = nil;
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma adjust orientation

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)displayError:(NSDictionary *)userInfo {
    NSLog(@"userInfo:%@", userInfo);
}

#pragma mark Movie Notification Handlers

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    NSLog(@"moviePlayBackDidFinish:%d", [reason intValue]);
    
	switch ([reason integerValue])
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            [self deletePlayerAndNotificationObservers];
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
//            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
//                                waitUntilDone:NO];
//            [self removeMovieViewFromViewHierarchy];
//            [self removeOverlayView];
            [self deletePlayerAndNotificationObservers];
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
//            [self removeMovieViewFromViewHierarchy];
//            [self removeOverlayView];
            [self deletePlayerAndNotificationObservers];
			break;
            
		default:
			break;
	}
}

/* Handle movie load state changes. */
- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
    NSLog(@"loadStateDidChange:%d", loadState);
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
//        [self.overlayController setLoadStateDisplayString:@"n/a"];
//        
//        [overlayController setLoadStateDisplayString:@"unknown"];
	}
	
	/* The buffer has enough data that playback can begin, but it
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
//        [overlayController setLoadStateDisplayString:@"playable"];
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        // Add an overlay view on top of the movie view
//        [self addOverlayView];
        
//        [overlayController setLoadStateDisplayString:@"playthrough ok"];
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
//        [overlayController setLoadStateDisplayString:@"stalled"];
	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
    NSLog(@"moviePlayBackStateDidChange:%d", player.playbackState);
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
//        [overlayController setPlaybackStateDisplayString:@"stopped"];
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
//        [overlayController setPlaybackStateDisplayString:@"playing"];
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
//        [overlayController setPlaybackStateDisplayString:@"paused"];
	}
	/* Playback is temporarily interrupted, perhaps because the buffer
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
//        [overlayController setPlaybackStateDisplayString:@"interrupted"];
	}
}

/* Notifies observers of a change in the prepared-to-play state of an object
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
	// Add an overlay view on top of the movie view
//    [self addOverlayView];
    NSLog(@"mediaIsPreparedToPlayDidChange");
}

@end
