//
//  VideoPlayerViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "VideoGridCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

@synthesize videoView, gridView = _gridView, curVideo, relatedVideos;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.gridView.backgroundColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:26.0/255.0 green:32.0/255.0 blue:133.0/255.0 alpha:1.0]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"backgroundVideoDetail.png"]];
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    [self updateLabels];
    [self setupGridView_iPad];
    [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
    
    [self.gridView reloadData];
    
    CGRect frame = _gridView.frame;
    frame.size = CGSizeMake(617, 195);
    _gridView.frame = frame;
}

-(void)setupGridView_iPad {
    
    // Remove the ability to scroll up and down in related videos
    // Use horizontal scrolling
    self.gridView.usesPagedHorizontalScrolling = YES;
    [self.gridView setShowsVerticalScrollIndicator:NO];
    self.gridView.scrollsToTop = NO;
    self.gridView.bounces = NO;
    self.gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    
    [self.gridView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.gridView.layer setMasksToBounds:YES];
    [self.gridView.layer setBorderWidth:2];
    [self.gridView.layer setCornerRadius:12.0];

    
    int i = 0;
    for (NSDictionary* video in relatedVideos ) {
        if ( video == curVideo ) {
            //NSLog(@"Found Video @ index:  %d",i);
            [self.gridView selectItemAtIndex:i animated:NO scrollPosition:AQGridViewScrollPositionNone];
            break;
        }
        i++;
    }
//    [gridView deselectItemAtIndex:index animated:NO];
}

-(void)setupGridView {
    [self setupGridView_iPad];
}

- (void)updateLabels
{
    name.text =     [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"name"];
    age.text =      [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"age"];
    survivorshipLength.text = [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"survivorshipLength"];
    treatment.text = [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"treatment"];
    maritalStatus.text = [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"maritalStatus"];
    employmentStatus.text = [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"employmentStatus"];
    childrenStatus.text = [(NSDictionary*)[curVideo objectForKey:@"parsedKeys"] objectForKey:@"childrenStatus"];
    videoTitle.text = [curVideo objectForKey:@"title"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)updateYoutubeVideo_iPad:(UIInterfaceOrientation)orientation {
    if ( UIInterfaceOrientationIsPortrait(orientation) ) {
        [self embedYouTube:[curVideo objectForKey:@"url"] frame:CGRectMake(106, 199-45, 556, 364)];
    } else {
        [self embedYouTube:[curVideo objectForKey:@"url"] frame:CGRectMake(63, 198-45, 451, 351)];
    }
}

-(void) updateYoutubeVideo:(UIInterfaceOrientation)orientation {
    [self updateYoutubeVideo_iPad:orientation];
}


- (void)rotateYouTube:(CGRect)frame {
    videoView.frame = frame;
}

-(void) updateYoutubePosition:(UIInterfaceOrientation)orientation {
    if ( videoView == nil ) {
        [self updateYoutubeVideo:orientation];
        return;
    }
    
    if ( UIInterfaceOrientationIsPortrait(orientation) )
        [self rotateYouTube:CGRectMake(106,199-45,556,364)];
    //[self embedYouTube:curVideo.url frame:CGRectMake(106, 199, 556, 364)];
    else  {
        [self rotateYouTube:CGRectMake(63, 198-45, 451, 351)];
        //[self embedYouTube:curVideo.url frame:CGRectMake(63, 198, 451, 351)]; 
    }
}


-(void) setTextPositions_iPad:(CGFloat)x y:(CGFloat)y {
    CGRect frame = name.frame;
    
    // name
    frame.origin = CGPointMake(x,y);
    name.frame = frame;
    nameLabel.frame = CGRectMake(frame.origin.x - 95, frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height); // -95
    
    // age
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    age.frame = frame;
    ageLabel.frame = CGRectMake(frame.origin.x - 82, frame.origin.y, ageLabel.frame.size.width, ageLabel.frame.size.height);    // -82
    
    // treatment
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    treatment.frame = frame;
    treatmentLabel.frame = CGRectMake(frame.origin.x - 127, frame.origin.y, treatmentLabel.frame.size.width, treatmentLabel.frame.size.height); // -127
    
    // etc...
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    maritalStatus.frame = frame;
    maritalStatusLabel.frame = CGRectMake(frame.origin.x - 154, frame.origin.y, maritalStatusLabel.frame.size.width, maritalStatusLabel.frame.size.height); // -154
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    childrenStatus.frame = frame;
    childrenLabel.frame = CGRectMake(frame.origin.x - 112, frame.origin.y, childrenLabel.frame.size.width, childrenLabel.frame.size.height); // -112
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    employmentStatus.frame = frame;
    employentLabel.frame = CGRectMake(frame.origin.x - 197, frame.origin.y, employentLabel.frame.size.width, employentLabel.frame.size.height); // -197
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    survivorshipLength.frame = frame;
    survivorshipLabel.frame = CGRectMake(frame.origin.x - 222, frame.origin.y, survivorshipLabel.frame.size.width, survivorshipLabel.frame.size.height); // -222
    
}

-(void) setTextPositions:(CGFloat)x y:(CGFloat)y{
    [self setTextPositions_iPad:x y:y];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}

-(void) updateLayout:(UIInterfaceOrientation)orientation {
    //NSLog(@"updateLayout:  %@",orientation);
    if ( UIInterfaceOrientationIsPortrait(orientation) ) {
        CGRect frame = videoTitle.frame;
        frame.origin = CGPointMake(243, frame.origin.y);
        videoTitle.frame = frame;
        
        [self setTextPositions:408 y:(613-45)];
        
        // setup new frame
        frame = _gridView.frame;
        frame.origin = CGPointMake(76, 790);
        _gridView.frame = frame;
    } else {
        CGRect frame = videoTitle.frame;
        frame.origin = CGPointMake(371, frame.origin.y);
        videoTitle.frame = frame;
        
        [self setTextPositions:759 y:(236 - 45)];
        
        // setup gridview
//        _gridView.frame = CGRectMake(204, (534-45), 617, 195);
        frame = _gridView.frame;
        frame.origin = CGPointMake(204, 534);
        _gridView.frame = frame;
    }
    
    CGRect frame = _gridView.frame;
    frame.size = CGSizeMake(617, 150);
    _gridView.frame = frame;
    
    // just changes the position of the video.  allows to continue playing the video \
    // with updateYoutubeVideo it replaces the video when you change views starting the video over.
    [self updateYoutubePosition:orientation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void)embedYouTube:(NSURL*)url frame:(CGRect)frame {
    NSString* embedHTML = @""
    "<html><head>"
    "<style type=\"text/css\">"
    "body {" 
    "background-color: transparent;"
    "color: white;"
    "}" 
    "</style>"
    "</head><body style=\"margin:0\">" 
    "</param><embed src=\"%@&autoplay=1\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed></object>"
    "</body></html>"; 
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
        videoView.mediaPlaybackRequiresUserAction = NO;
        [self.view addSubview:videoView];
    }
    
    videoView.frame = frame;
    [videoView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [videoView.layer setMasksToBounds:YES];
    [videoView.layer setBorderWidth:2];
    [videoView.layer setCornerRadius:12.0];
    [videoView loadHTMLString:html baseURL:nil];
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView {
    return [relatedVideos count];
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(130.0, 150.0);
}


- (AQGridViewCell *) gridView: (AQGridView *)aGridView cellForItemAtIndex: (NSUInteger) index {
    static NSString *VideoGridCellIdentifier = @"VideoPlayerGridCellIdentifier";
    
    NSDictionary *video = [relatedVideos objectAtIndex:index];
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:VideoGridCellIdentifier];
    
    if ( cell == nil ) {
        cell = [[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 120.0, 140.0) reuseIdentifier:VideoGridCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        cell.title.font = [UIFont boldSystemFontOfSize: 8.0];
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *thumbnailURL = [video objectForKey:@"thumbnailURL"];
    UIImage *cachedImage = [manager imageWithURL:thumbnailURL];
    
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else
        [cell.imageView setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [cell.title setText:[video objectForKey:@"title"]];
    return cell;

}

- (void)gridView:(AQGridView *)aGidView didSelectItemAtIndex:(NSUInteger)index
{  
    NSDictionary *video = [relatedVideos objectAtIndex:index];
    
    // log current video
//    NSDictionary* video_dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                ytv.title, @"title", ytv.url, @"url", nil];
//    [FlurryAnalytics logEvent:@"Video" withParameters:video_dict];
    
    curVideo = video;
    [self updateLabels];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    // Call this since we are replacing what video is being displayed
    [self updateYoutubeVideo:application.statusBarOrientation];
}


@end
