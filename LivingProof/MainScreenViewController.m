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
//    if ( toInterfaceOrientation == UIInterfaceOrientationPortrait || 
//        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        [self displayPortrait];
//    }
//    else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
//             toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
//    {
//        
//        [self displayLandscape];
//    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView setAnimationsEnabled:YES];
    if ( !(fromInterfaceOrientation == UIInterfaceOrientationPortrait || 
        fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        [self displayPortrait];
    }
    else if ( !(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
             fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight ))
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
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        [self setButtonLook_iPad:button];
    } else {
        [self setButtonLook_iPhone:button];
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
    
    
//    if ( UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ) {
//        [self displayPortrait];
//    } else
//        [self displayLandscape];
}

-(void)viewDidAppear:(BOOL)animated {
    
    buttonPlate.backgroundColor = [UIColor clearColor];
    
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

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [UIView setAnimationsEnabled:YES];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   
    // Return YES for supported orientations
    [UIView setAnimationsEnabled:NO];
    
    //[self delegate].curOrientation = interfaceOrientation;
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        return YES;
    } else {
        if ( interfaceOrientation == UIInterfaceOrientationPortrait )
        {
            return YES;
        }
        return NO;
    }
}

//
// Portrait Orientations of the Buttons and Background
//
- (void)displayPortrait_iPhone {
    sortAge.frame = CGRectMake(20, 294, 140, 60 );    
    sortCategory.frame = CGRectMake(160, 294, 140, 60);
    loadingLabel.frame = (CGRect){ CGPointMake(129, 333) ,loadingLabel.frame.size };
    activityView.frame = (CGRect){ CGPointMake(150, 305), activityView.frame.size };
    
    CGRect frame = washULogo.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width - 10;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
    washULogo.frame = frame;
    
}

- (void)displayPortrait_iPad {
    sortAge.frame = CGRectMake(170, 707, 210, 93 );    
    sortCategory.frame = CGRectMake(390, 707, 210, 93);
    loadingLabel.frame = (CGRect){ CGPointMake(364, 878) ,loadingLabel.frame.size };
    activityView.frame = (CGRect){ CGPointMake(384, 849), activityView.frame.size };
    
    CGRect frame = washULogo.frame;
    frame.origin.x = self.view.frame.size.width - frame.size.width - 10;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
    washULogo.frame = frame;
    
    
    frame = buttonPlate.frame;
    frame.origin.y = sortAge.frame.origin.y + sortAge.frame.size.height;
    float buttonWidth = buttonPlate.frame.size.width;
    frame.origin.x = (self.view.frame.size.width - buttonWidth)/2;
    buttonPlate.frame = frame;
}

-(void)displayPortrait {
    NSLog(@"%@",[UIDevice currentDevice].model);
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        NSLog(@"displayPortrait iPad");
        [self displayPortrait_iPad];
    } else {
        NSLog(@"displayPortrait iPhone");
        [self displayPortrait_iPhone];
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
    sortAge.frame = CGRectMake(150, 523, 360, 90);
    sortCategory.frame = CGRectMake(516, 523, 360, 90);
    loadingLabel.frame = (CGRect){ CGPointMake(480, 630) ,loadingLabel.frame.size };;
    activityView.frame = (CGRect){ CGPointMake(500, 600), activityView.frame.size };;
    
    CGRect frame = washULogo.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) - 10;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
    washULogo.frame = frame;
    
    frame = buttonPlate.frame;
    
    frame.origin.y = sortAge.frame.origin.y + sortAge.frame.size.height;
    float buttonWidth = buttonPlate.frame.size.width;
    frame.origin.x = (self.view.frame.size.width - buttonWidth)/2;
    buttonPlate.frame = frame;
}

- (void)displayLandscape {    
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        NSLog(@"displayLandscape iPad");
        [self displayLandscape_iPad];
        self.view.backgroundColor = landscapeBackgroundImage;
    } else {
        // Only portrait enabled in iPhone
        NSLog(@"displayPortrait iPhone (old Landscape)");
        [self displayPortrait_iPhone];
    }
}

-(void)displayAlertViewWithText:(NSString*)text title:(NSString*)title {
    
    av = [[UIAlertView alloc]initWithTitle:title message:@"\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [[av class] setAnimationsEnabled:NO];

    
    
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        [myTextView setFont:[UIFont systemFontOfSize:20.0]];
        myTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 50, 520, 142)];
    } else {
        [myTextView setFont:[UIFont systemFontOfSize:15.0]];
        myTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 50, 260, 142)];
    }
    
    
    [myTextView setTextAlignment:UITextAlignmentLeft];
    [myTextView setEditable:NO];
    
    myTextView.layer.borderWidth = 2.0f;
    myTextView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    myTextView.layer.cornerRadius = 13;
    myTextView.clipsToBounds = YES ;
    
    av.delegate = self;
    
    [myTextView setText:text];
    
    [av addSubview:myTextView];
    [av setTag:1];
    [av show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        CGRect frame = alertView.frame;
        frame.size.width += 260;
        frame.origin.x -= 130;
        alertView.frame = frame;
        
        UILabel *tempTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,20,350, 20)];
        tempTitle.backgroundColor = [UIColor clearColor];
        tempTitle.textColor = [UIColor whiteColor];
        tempTitle.textAlignment = UITextAlignmentCenter;
        tempTitle.numberOfLines = 1;
        tempTitle.font = [UIFont boldSystemFontOfSize:18];
        tempTitle.text = alertView.title;
        alertView.title = @"";
        [alertView addSubview:tempTitle];
        
        // iterate through the subviews in order to find the button and resize it
        for( UIView *view in alertView.subviews)
        {
            if([[view class] isSubclassOfClass:[UIControl class]])
            {
                CGRect buttonFrame = view.frame;
                buttonFrame.origin.x += 2;
                buttonFrame.size.width = frame.size.width - 25;
                view.frame = buttonFrame;
            }
        }
    }
}

-(IBAction)disclaimerPushed:(id)sender {
    
    
    
    NSString* disclaimer = @""
        "Disclaimer and Limitation of Liability\n\n"
        "This mobile application (\"app\") and all intellectual property rights related thereto are the property of The Washington University (\"WU\").\n"
        "\n\n"
        "Living Proof is an educational tool of Washington University in St. Louis and is intended for informational purposes only. It does not provide medical advice or services. Do not use the content to make a diagnosis, treat a health problem, or replace a doctor's judgment.\n"
        "\n\n"
        "The information in Living Proof is a summary intended to provide a broad understanding of disease information. WU MAKES NO WARRANTY OF ANY KIND REGARDING THIS APP AND/OR ANY MATERIALS PROVIDED IN THIS APP, ALL OF WHICH ARE PROVIDED ON AN “AS IS” BASIS.  WU DOES NOT WARRANT THE ACCURACY, COMPLETENESS, CURRENCY OR RELIABILITY OF ANY OF THE CONTENT OR DATA FOUND IN THIS APP AND WU EXPRESSLY DISCLAIMS ALL WARRANTIES AND CONDITIONS, INCLUDING IMPLIED WARRANTIES AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT, AND THOSE ARISING BY STATUTE OR OTHERWISE IN LAW OR FROM A COURSE OF DEALING OR USAGE OF TRADE.\n"
        "\n"
        "The WU is not responsible for any damages or losses that result from use of Living Proof.\n"
        "\n"
        "You may email/share, print, or download information for non-commercial purposes only. Permission to reproduce, transmit, distribute or display the content for any other purpose requires prior written consent from Washington University in St. Louis.\n"
        "\n"
        "All content in this app is protected by copyright law, © 2012 The Washington University.";
    [self displayAlertViewWithText:disclaimer title:@"Disclaimer"];
}

-(IBAction)privacyPushed:(id)sender {
    NSString* privacy = @"Privacy\n\
    \n\
    WU respects the privacy of users of Living Proof.\n\
    \n\
    WU will not share, sell, rent, or lease any of the information you enter on Living Proof. Your personal contact information will only be used to provide notice of website updates and improvements.\n\
    \n\
    Anonymous, aggregated data may occasionally be gathered for internal purposes of improving how Living Proof works and to better serve its users.  No personally identifiable information will be included in these data.\n\
    \n\
    WU reserves the right to collect, maintain, and use information that your web browser provides to WU’s web server, including without limitation the website from which you linked to the website, the identity of your Internet Service Provider, or the type of browser you are using.  WU may use such information in an aggregated form, such as to measure the usefulness and popularity of the website.";
    [self displayAlertViewWithText:privacy title:@"Privacy"];
}
@end
