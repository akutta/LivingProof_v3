//
//  AgesViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AgesViewController.h"
#import "YouTubeInterface.h"
#import "VideoGridCell.h"
#import "VideoSelectionViewController.h"


#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


@interface AgesViewController ()

@end

@implementation AgesViewController

@synthesize gridView = _gridView, myTableView = _myTableView;

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
    self.myTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];    
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:26.0/255.0 green:32.0/255.0 blue:133.0/255.0 alpha:1.0]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(goHome:)];
    self.navigationItem.rightBarButtonItem = homeButton;
    self.navigationItem.title = @"Living Proof";
    
    
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
       
        self.gridView.backgroundColor = [UIColor clearColor];
        // Enable GridView
        self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.gridView.autoresizesSubviews = YES;
        self.gridView.delegate = self;
        self.gridView.dataSource = self;
    } else {
        NSLog(@"iPhone/iPod");
    }
    
    youTube = [YouTubeInterface iYouTube];
    if ( [youTube getFinished] == NO ) {
        NSLog(@"How did you even get here?");
        return;
    }
    
    _ages = [[youTube getArrayOfSurvivorsFromYoutube:NO] copy];
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
    // Prevent iPhone orientation rotation
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        if ( interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            return YES;
        }
        return NO;
    }
}

#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AgeTableCellIdentifier = @"CustomTableCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AgeTableCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AgeTableCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    NSDictionary *video = [_ages objectAtIndex:indexPath.row];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *thumbnailURL = [video objectForKey:@"thumbnailURL"];
    UIImage *cachedImage = [manager imageWithURL:thumbnailURL];
    
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else
        [cell.imageView setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [cell.textLabel setText:[video objectForKey:@"name"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //VideoGridCell *cell = [(VideoGridCell*)[gridView cellForItemAtIndex:index] autorelease];
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    VideoSelectionViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoSelectionViewController"];
    
    [nextView setFilter:cell.textLabel.text];
    NSLog(@"Set Filter:  %@",cell.textLabel.text);
    [nextView setNavBackText:@"Ages"];
    
    // Oddly enough, this is the backButton for the nextView 
    // Wierd stuff going on here
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Ages" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:nextView animated:YES];
}



#pragma mark AQGridView

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView {
    return [_ages count]; 
}

// Defines the size of the grid cell
// modify for use with iPhone
- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(250.0, 305.0);
}


- (AQGridViewCell *) gridView: (AQGridView *)aGridView cellForItemAtIndex: (NSUInteger) index {    
    static NSString *AgeGridCellIdentifier = @"AgeGridCellIdentifier";
    
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:AgeGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 240.0, 285.0) reuseIdentifier:AgeGridCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *video = [_ages objectAtIndex:index];
    
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


- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    //VideoGridCell *cell = [(VideoGridCell*)[gridView cellForItemAtIndex:index] autorelease];
    VideoGridCell *cell = (VideoGridCell*)[gridView cellForItemAtIndex:index];
    VideoSelectionViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoSelectionViewController"];
    
    [nextView setFilter:cell.title.text];
    [nextView setNavBackText:@"Ages"];
    
    // Oddly enough, this is the backButton for the nextView 
    // Wierd stuff going on here
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Ages" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [gridView deselectItemAtIndex:index animated:NO];
    [self.navigationController pushViewController:nextView animated:YES];
}


@end
