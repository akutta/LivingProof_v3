//
//  MainScreenViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScreenViewController.h"
//#import "CategoriesViewController.h"
//#import "AgesViewController.h"
#import "YouTubeInterface.h"
#import <QuartzCore/QuartzCore.h>


#define iPhone_ButtonBorderWidth 2.0
#define iPhone_ButtonRadius 12.0

#define iPad_ButtonBorderWidth 2.0
#define iPad_ButtonRadius 12.0


@interface MainScreenViewController (Private)
@end

@implementation MainScreenViewController

// Uses initWithCoder instead of nibname since it is done through storyboard
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        sortAge.hidden = YES;
        sortCategory.hidden = YES;
        
        loadingLabel.hidden = NO;
        activityView.hidden = NO;
        [activityView startAnimating];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(finishedLoadingYoutube:) 
                                                     name:@"FinishedLoadingYoutube" object:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sortAge.hidden = YES;
        sortCategory.hidden = YES;
        
        loadingLabel.hidden = NO;
        activityView.hidden = NO;
        [activityView startAnimating];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(finishedLoadingYoutube:) 
                                                     name:@"FinishedLoadingYoutube" object:nil];
    }
    return self;
}

- (void)dealloc
{
    /*[landscapeBackgroundImage release];
     [portraitBackgroundImage release];
     [lightPink release];
     [super dealloc];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)finishedLoadingYoutube:(id)sender
{
    sortAge.hidden = NO;
    sortCategory.hidden = NO;
    
    [activityView stopAnimating];
    activityView.hidden = YES;
    loadingLabel.hidden = YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{   
    if ( toInterfaceOrientation == UIInterfaceOrientationPortrait || 
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self displayPortrait];
    }
    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
             toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        
        [self displayLandscape];
    }
}

#pragma mark - View lifecycle

- (UIImage*)imageFromColor:(UIColor*)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setButtonLook_iPhone:(UIButton*)button {
    [button.layer setBorderWidth:iPhone_ButtonBorderWidth];
    [button.layer setCornerRadius:iPhone_ButtonRadius];
}

- (void)setButtonLook_iPad:(UIButton*)button {
    [button.layer setBorderWidth:iPad_ButtonBorderWidth];
    [button.layer setCornerRadius:iPad_ButtonRadius];
}

- (void)setButtonLook:(UIButton*)button {
    if ( [[[UIDevice currentDevice] name] hasPrefix:@"iPhone"] ) {
        [self setButtonLook_iPhone:button];
    } else {
        [self setButtonLook_iPad:button];
    }
    
    [button.layer setMasksToBounds:YES];
    [button setBackgroundColor:button.currentTitleColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setBorderColor:[lightPink CGColor]];
    
    [button setTitleColor:button.backgroundColor forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self imageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
}


- (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)setupImages {
    
    CGSize rotatedSize = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
    
    UIImage *originalImage = [UIImage imageNamed:@"WelcomeScreen.png"];
    UIImage *originalRotatedImage = [UIImage imageNamed:@"WelcomeScreenRotated.png"];
    
    NSLog(@"%fx%f ->  %fx%f",originalRotatedImage.size.width,originalRotatedImage.size.height,
          rotatedSize.width,rotatedSize.height);
    
    UIImage *imageRotated = [self imageWithImage:originalRotatedImage
                                    scaledToSize:rotatedSize];
    
    UIImage *scaledImage = [self imageWithImage:originalImage
                                   scaledToSize:self.view.frame.size];
    
    landscapeBackgroundImage = [[UIColor alloc] initWithPatternImage:imageRotated];
    portraitBackgroundImage = [[UIColor alloc] initWithPatternImage:scaledImage];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    
    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ) {
        [self displayPortrait];
    } else
        [self displayLandscape];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    
    
    [self setupImages];
    
    
    lightPink = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
    strongPink = sortCategory.currentTitleColor;
    
    
    self.view.backgroundColor = portraitBackgroundImage;
    [self setButtonLook:sortAge];
    [self setButtonLook:sortCategory];
    
    /* ensure buttons appear if the feed has already been fetched */   
    
    if ( [[YouTubeInterface iYouTube] getFinished] ) 
        [self finishedLoadingYoutube:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView setAnimationsEnabled:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    [UIView setAnimationsEnabled:NO];
    
    //[self delegate].curOrientation = interfaceOrientation;
    return YES;
}

//
// Private Implementations 
//
 
//
// Portrait Orientations of the Buttons and Background
//
- (void)displayPortrait_iPhone {
    sortAge.frame = CGRectMake(20, 294, 140, 60 );    
    sortCategory.frame = CGRectMake(160, 294, 140, 60);
    loadingLabel.frame = (CGRect){ CGPointMake(129, 333) ,loadingLabel.frame.size };
    activityView.frame = (CGRect){ CGPointMake(150, 305), activityView.frame.size };
}

- (void)displayPortrait_iPad {
    sortAge.frame = CGRectMake(170, 807, 210, 93 );    
    sortCategory.frame = CGRectMake(390, 807, 210, 93);
    loadingLabel.frame = (CGRect){ CGPointMake(364, 878) ,loadingLabel.frame.size };;
    activityView.frame = (CGRect){ CGPointMake(384, 849), activityView.frame.size };;
}

-(void)displayPortrait {
     if ( [[[UIDevice currentDevice] name] hasPrefix:@"iPhone"] ) {
         NSLog(@"displayPortrait iPhone");
         [self displayPortrait_iPhone];
     } else {
         NSLog(@"displayPortrait iPad");
         [self displayPortrait_iPad];
     }
    self.view.backgroundColor = portraitBackgroundImage;
}

//
// Landscape Orientations of the Buttons and Background
//
-(void)displayLandscape_iPhone {
    sortAge.frame = CGRectMake(100, 255, 130, 30 );    
    sortCategory.frame = CGRectMake(240, 255, 130, 30);
    loadingLabel.frame = (CGRect){ CGPointMake(209, 255) ,loadingLabel.frame.size };
    activityView.frame = (CGRect){ CGPointMake(230, 237), activityView.frame.size };
}

- (void)displayLandscape_iPad {
    sortAge.frame = CGRectMake(150, 573, 360, 90);
    sortCategory.frame = CGRectMake(516, 573, 360, 90);
    loadingLabel.frame = (CGRect){ CGPointMake(480, 630) ,loadingLabel.frame.size };;
    activityView.frame = (CGRect){ CGPointMake(500, 600), activityView.frame.size };;
    
}

- (void)displayLandscape {    
    if ( [[[UIDevice currentDevice] name] hasPrefix:@"iPhone"] ) {
        NSLog(@"displayLandscape iPhone");
        [self displayLandscape_iPhone];
    } else {
        NSLog(@"displayLandscape iPad");
        [self displayLandscape_iPad];
    }
    self.view.backgroundColor = landscapeBackgroundImage;
}

@end
