//
//  CategoriesViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesViewController.h"
#import "YouTubeInterface.h"
#import "VideoGridCell.h"


#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface CategoriesViewController ()

@end

@implementation CategoriesViewController


@synthesize gridView = _gridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
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
    
    youTube = [YouTubeInterface iYouTube];
    if ( [youTube getFinished] == NO ) {
        NSLog(@"How did you even get here?");
        return;
    }
    
    _categories = [[youTube getArrayOfSurvivorsFromYoutube:YES] copy];
    [_gridView reloadData];
}

-(IBAction)goHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark AQGridView

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView {
    return [_categories count]; 
}

// Defines the size of the grid cell
// modify for use with iPhone
- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(250.0, 305.0);
}


- (AQGridViewCell *) gridView: (AQGridView *)aGridView cellForItemAtIndex: (NSUInteger) index {
    static NSString *CategoryGridCellIdentifier = @"CategoryGridCellIdentifier";
    
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:CategoryGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 240.0, 285.0) reuseIdentifier:CategoryGridCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    NSDictionary *video = [_categories objectAtIndex:index];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *thumbnailURL = [video objectForKey:@"thumbnailURL"];
    UIImage *cachedImage = [manager imageWithURL:thumbnailURL];
    
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else
        [cell.imageView setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [cell.title setText:[video objectForKey:@"name"]];
    //    cell.title = [video objectForKey:@"name"];// tmp.name;
    
    return cell;
}

@end