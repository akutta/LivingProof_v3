//
//  VideoSelectionViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "VideoSelectionViewController.h"
#import "VideoGridCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface VideoSelectionViewController ()

@end

@implementation VideoSelectionViewController

@synthesize gridView, navBackText, filter;

- (void)filterVideos {
    if ( navBackText != @"Ages" ) return;
    NSMutableArray* filteredVideos = [[NSMutableArray alloc] init];
    for ( NSDictionary* video in videos ) {
        NSString* name = [(NSDictionary*)[video objectForKey:@"parsedKeys"] objectForKey:@"name"];
        BOOL bFound = NO;
        for ( NSDictionary* filteredVideo in filteredVideos ) {
            NSString* nameFiltered = [(NSDictionary*)[filteredVideo objectForKey:@"parsedKeys"] objectForKey:@"name"];
            if ( [nameFiltered caseInsensitiveCompare:name] == NSOrderedSame ) {
                bFound = YES;
                break;
            }
        }
        if ( !bFound ) {
            [filteredVideos addObject:video];
        }
    }
    videos = [filteredVideos copy];
}

- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];    
    
    self.gridView.backgroundColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:26.0/255.0 green:32.0/255.0 blue:133.0/255.0 alpha:1.0]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goHome:)];
    self.navigationItem.rightBarButtonItem = homeButton;
    self.navigationItem.title = @"Living Proof";
    
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    // Populate the videos
    youTube = [YouTubeInterface iYouTube];
    
    videos = [youTube getYouTubeArray:filter];
    [self filterVideos];
    
    // Reload the gridview
    [self.gridView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Prevent iPhone orientation rotation
    if ( [[[UIDevice currentDevice] name] hasPrefix:@"iPhone"] ) {
        if ( interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            return YES;
        }
        return NO;
    }
    return YES;
}


- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView {
    return [videos count];
}


// Defines the size of the grid cell
// modify for use with iPhone
- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(250.0, 305.0);
}

- (AQGridViewCell *) gridView: (AQGridView *)aGridView cellForItemAtIndex: (NSUInteger) index {
    static NSString *VideoSelectionGridCellIdentifier = @"VideoSelectionGridCellIdentifier";
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:VideoSelectionGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 240.0, 285.0) reuseIdentifier:VideoSelectionGridCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    NSDictionary *video = [videos objectAtIndex:index];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *thumbnailURL = [video objectForKey:@"thumbnailURL"];
    UIImage *cachedImage = [manager imageWithURL:thumbnailURL];
    
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else
        [cell.imageView setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    if ( navBackText == @"Ages" ) {
        [cell.title setText:[(NSDictionary*)[video objectForKey:@"parsedKeys"] objectForKey:@"name"]];
    } else {
        [cell.title setText:[video objectForKey:@"title"]];
    }
    
    return cell;
}


- (void)gridView:(AQGridView *)aGridView didSelectItemAtIndex:(NSUInteger)index
{
    //VideoGridCell *cell = [(VideoGridCell*)[gridView cellForItemAtIndex:index] autorelease];
    VideoGridCell *cell = (VideoGridCell*)[aGridView cellForItemAtIndex:index];
    
    if ( navBackText == @"Ages" ) {
        VideoSelectionViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoSelectionViewController"];
    
        [nextView setFilter:cell.title.text];
        [nextView setNavBackText:@"Back"];
    
        // Oddly enough, this is the backButton for the nextView 
        // Wierd stuff going on here
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        [gridView deselectItemAtIndex:index animated:NO];
        [self.navigationController pushViewController:nextView animated:YES];
    } else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        VideoPlayerViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];        
        [nextView setCurVideo:[videos objectAtIndex:index]];
        [nextView setRelatedVideos:videos];
        
        [gridView deselectItemAtIndex:index animated:NO];
        [self.navigationController pushViewController:nextView animated:NO];
    }
}



@end
