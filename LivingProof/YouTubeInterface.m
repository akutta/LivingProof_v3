//
//  YouTubeInterface.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/21/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Parse/Parse.h>
#import "YouTubeInterface.h"

//#import "Video.h"
//#import "Keys.h"

#import "GDataYouTube.h"
#import "GDataEntryYouTubeVideo.h"

#import "GDataServiceGoogleYouTube.h"

#import "GDataEntryPhoto.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"

#import "GDataMedia.h"
#import "GDataMediaGroup.h"
#import "GDataMediaThumbnail.h"

//#import "LivingProofAppDelegate.h"

#import "SVProgressHUD.h"

// old key
//#define YouTube_devKey @"AI39si73rPI3lBhtbSwjwML_FPEUeg7th7VQgaN3QplOaA5j9C7r-MbrP8LHwQ3ncIfMgIcevYzNpE83ynB69Uy2v-1aoq4PbQ"

#define YouTube_devKey @"AI39si4tflpH_h0PP98MlTGmgf1VrjB4XIbmDmG-lcHyixlq1U12eTdkPlJtD0LEjakZwFnJ4nChx6m-0edvXt82usacAYyzyQ"


@interface YouTubeInterface (Private)

//- (LivingProofAppDelegate*)delegate;
- (NSArray*)getAges;
- (NSArray*)getCategories;

- (void)setFinished:(BOOL)value;
- (BOOL)getFinished;

- (BOOL)isInternetConnected;

- (void)loadVideoFeed;
- (void)addToAges:(NSString*)newAge;
- (void) addToCategories:(NSString*)newCategory;
- (NSString*) replaceSymbols:(NSString*)input;
- (NSString*) safeGetValue:(NSArray*)input index:(NSInteger)index;
//- (Keys*) parseKeys:(NSArray*)unparsed;

- (GDataServiceGoogleYouTube *)youTubeService;
- (void) parseVideos;

- (GDataServiceTicket *)entriesFetchTicket;
- (void)setEntriesFetchTicket:(GDataServiceTicket *)ticket;

- (GDataFeedBase *)entriesFeed;
- (void)setEntriesFeed:(GDataFeedBase *)feed;

- (NSError *)entryFetchError;
- (void)setEntriesFetchError:(NSError *)error;

@end


@implementation YouTubeInterface

+(YouTubeInterface*)iYouTube {
    static YouTubeInterface* sharedInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInterface = [[self alloc] init];
    });
    
    return sharedInterface;
}

NSInteger compareLargestNumber(NSString *firstTitle, NSString *secondTitle, void *context)
{
    NSArray *firstTitleChunks = [firstTitle componentsSeparatedByString:@" "];
    NSArray *secondTitleChunks = [secondTitle componentsSeparatedByString:@" "];
    
    NSInteger firstMaxAge = 0;
    NSInteger secondMaxAge = 0;
    
    // Find the largest number in the first chunk
    for ( NSString* entry in firstTitleChunks ) {
        if ( [entry integerValue] > firstMaxAge ) { // a non number is converted to a 0
            firstMaxAge = [entry integerValue];
        }
        //NSLog(@"%@ -> %i",entry, [entry integerValue]);
    }
    
    for ( NSString* entry in secondTitleChunks ) {
        if ( [entry integerValue] > secondMaxAge ) {
            secondMaxAge = [entry integerValue];
        }
    }
    
    if ( firstMaxAge < secondMaxAge )
        return NSOrderedAscending;
    else if ( firstMaxAge > secondMaxAge )
        return NSOrderedDescending;
    
    return NSOrderedSame;
}

NSInteger compareViewCount(NSDictionary *firstVideo, NSDictionary *secondVideo, void *context)
{
    //NSLog(@"Comparing %@ with %@",[firstVideo viewCount], [secondVideo viewCount]);
    NSNumber *viewCount1 = [firstVideo objectForKey:@"viewCount"];
    NSNumber *viewCount2 = [secondVideo objectForKey:@"viewCount"];
    
    if ( viewCount1.intValue < viewCount2.intValue )
        return NSOrderedDescending;
    else if ( viewCount1.intValue > viewCount2.intValue ) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

- (NSArray*)getAges {
    //return [[ages copy] autorelease];
    return [ages copy];
}

- (NSArray*)getCategories {
    //return [[categories copy] autorelease];
    return [categories copy];
}

- (void)setFinished:(BOOL)value {
    finished = [NSNumber numberWithBool:value];
}

- (BOOL)getFinished {
    return [finished boolValue];
}

- (BOOL)isInternetConnected {
    return internetConnected;
}

- (void)loadVideoFeed
{
    NSLog(@"loadVideoFeed");
    //[SVProgressHUD showWithStatus:@"Loading"];

    // Ensure we initialize this
    finished = [NSNumber numberWithBool:NO];

    // get the youtube service
    GDataServiceGoogleYouTube *service = [self youTubeService];
    
    GDataServiceTicket *ticket;
    
    // construct the feed url
    NSURL *feedURL = [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/livingproofapp/uploads"];
    
    // MODIFICATION:
    //      Improves network time by increasing the number of results per page
    //      Overall improvement of network speed
    GDataQueryYouTube *query = [GDataQueryYouTube youTubeQueryWithFeedURL:feedURL];
    
    // 'next' Pages Used Reduced from 8 to 4.  Supposedly supports more but always
    // returns an error when attempted >50.
    [query setMaxResults:50]; // IMPORTANT:  set to 50 for full testing.
    
    // Replaces api call below
    // to increase number of queries per request
    //
    //  Increases effeciency
    ticket = [service fetchFeedWithQuery:query
                                delegate:self
                       didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:error:)];
    
    [self setEntriesFetchTicket:ticket];
}

//
// This is used to display the error that the application won't be able to load
//
-(void)displayYoutubeError {
  
    NSLog(@"displayError");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We're Sorry!" message:@"Unfortunately the LivingProof system is temporarily down.  Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark -
#pragma mark UIAlertViewDeletage

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Was considering force exiting but I will leave it for now.
}

#pragma mark -
#pragma mark gData

// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService
{  
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES]; // IMPORTANT:  When doing more testing set to YES
        [service setIsServiceRetryEnabled:YES];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* password = (NSString*)[defaults objectForKey:@"key"];
    if ( password == nil ) {
        NSLog(@"No Password Located\n\tUsing Default Password");
        password = @"fdsa8134CSIfdsSDF";
    } else {
        NSLog(@"Pass:  %@",password);
    }
    
	[service setUserCredentialsWithUsername:@"livingproofapp" password:password];
    [service setYouTubeDeveloperKey:YouTube_devKey];
    
    return service;
}

/*
 * entryListFetchTicket:finishedWithFeed:error
 * Last Modified: Summer2011
 * - Drew
 * 
 * When gData is finished downloading the youtube data, the mEntriesFeed is set
 * to the passed value, the items are then traversed in a for loop as a
 * GDataEntryYouTubevideo item, and assigned associated values to a YouTubeVideo model.
 * The object is then added to the YouTubeArray.
 * 
 */
- (void)entryListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedBase *)feed
                       error:(NSError *)error
{
    
    static int numTries = 0;
    
	[self setEntriesFeed:feed];
	[self setEntriesFetchError:error];
	[self setEntriesFetchTicket:nil];
 	
	if ( error != nil ) {
        if ( [(NSString*)[[error userInfo] objectForKey:@"error"] isEqual:@"BadAuthentication"] ) {
            // Only one attempt at pulling pass from parse.
            if ( numTries == 0 ) {
                PFQuery *query = [PFQuery queryWithClassName:@"youtube"];
                [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        numTries++;
                        NSString* newPass = [object objectForKey:@"password"];
                        NSLog(@"New Password:  %@",newPass);
                        [[NSUserDefaults standardUserDefaults] setObject:newPass forKey:@"key"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self loadVideoFeed];
                    }
                }];
                
                return;
            }
        } else
            NSLog(@"Error: %@",[error localizedDescription]);
        
        // Display Error
        [self displayYoutubeError];
        
        // Not able to connect to internet
        internetConnected = NO;
        return;
	}
    
    internetConnected = YES;
        
    // Create Mutable Arrays
    if ( YouTubeArray == nil )
        YouTubeArray = [[NSMutableArray alloc] init];
    
    if ( categories == nil )
        categories = [[NSMutableArray alloc] init];
 
    if ( ages == nil ) 
        ages = [[NSMutableArray alloc] init];
        
    // Explore all entries downloaded from YouTube
    NSArray *entries = [mEntriesFeed entries];
    for ( GDataEntryYouTubeVideo *entry in entries )
    {
        
        //<iframe width="420" height="315" src="http://www.youtube.com/embed/lnhJkZXJJjk" frameborder="0" allowfullscreen></iframe>
        NSString *url = @"http://www.youtube.com/embed/";
        [url stringByAppendingString:[entry mediaGroup].videoID];
        
        // Store necessary information about youtube Videos
        NSMutableDictionary *youtubeVideo = [[NSMutableDictionary alloc] initWithCapacity:10];
        [youtubeVideo setObject:[[entry title] stringValue] forKey:@"title"];
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0) {
            NSString *url = @"http://www.youtube.com/v/";
            [url stringByAppendingString:[entry mediaGroup].videoID];
        } else {
            [youtubeVideo setObject:[[[entry links] objectAtIndex:0] valueForKey:@"href"] forKey:@"url"];
        }
        [youtubeVideo setObject:[entry mediaGroup].mediaDescription.stringValue forKey:@"category"];
        [youtubeVideo setObject:[entry mediaGroup].duration forKey:@"time"];
        [youtubeVideo setObject:[entry mediaGroup].mediaDescription.stringValue forKey:@"category"];
        [youtubeVideo setObject:[NSURL URLWithString:[[entry.mediaGroup.mediaThumbnails objectAtIndex:0] URLString]] forKey:@"thumbnailURL"];
        
        // Handle case when viewCount isn't passed, which will crash the app
        if ([[entry statistics] viewCount] != nil )
            [youtubeVideo setObject:[[entry statistics] viewCount] forKey:@"viewCount"];
        else {
            [youtubeVideo setObject:[[NSNumber alloc] initWithInt:0] forKey:@"viewCount"];
        }
        
        // Dynamically update the categories that can be selected from
        [self addToCategories:[youtubeVideo objectForKey:@"category"]];
        
        // Store Raw Keywords from YouTube
        [youtubeVideo setObject:[[[entry mediaGroup] mediaKeywords] keywords] forKey:@"keysArray"]; // Used for filter matching
        
        // Parse keys into own NSDictionary
        [youtubeVideo setObject:[self parseKeys:[youtubeVideo objectForKey:@"keysArray"]] forKey:@"parsedKeys"];
            
        // Dynamically update ages that can be selected from
        [self addToAges:[(NSDictionary*)[youtubeVideo objectForKey:@"parsedKeys"] objectForKey:@"age"]];
            
        // Append to Mutable Array
        [YouTubeArray addObject:youtubeVideo];
    }
    
    [ages sortUsingFunction:compareLargestNumber context:NULL];
    [YouTubeArray sortUsingFunction:compareViewCount context:NULL];
        
    // if asked tell them we are finished
    [self setFinished:YES];
    
    // Done loading
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedLoadingYoutube" object:nil];
}

#pragma mark -
#pragma mark Get & Set

- (void)setEntriesFetchTicket:(GDataServiceTicket *)ticket
{
    mEntriesFetchTicket = ticket;
}

- (NSError *)entryFetchError
{
    return mEntriesFetchError; 
}

- (GDataFeedBase *)entriesFeed
{
    return mEntriesFeed; 
}

- (void)setEntriesFeed:(GDataFeedBase *)feed
{
    mEntriesFeed = (GDataFeedYouTubeVideo*)(feed);
}

- (void)setEntriesFetchError:(NSError *)error
{
    mEntriesFetchError = error;
}

- (GDataServiceTicket *)entriesFetchTicket
{
    return mEntriesFetchTicket; 
}


-(NSArray*)getYouTubeArray:(NSString*)filter {
    if ( [self isInternetConnected] == NO )
        [self loadVideoFeed];
    
    // Only retrieve if we have finished downloading list from youtube
    if ( [self getFinished] == NO ) {
        return 0;
    }
    
    // if there isn't a filter send back full array
    // This removes any unnecessary memory usage
    if ( filter == nil ) {
        return [YouTubeArray copy];
    }

    
    // Create Mutable Array
    //NSMutableArray *tmpValue = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *tmpValue = [[NSMutableArray alloc] init];
    
    // Sort by categories, ages, and name here
    for ( NSDictionary* videoInfo in YouTubeArray ) {
        if ( [[videoInfo objectForKey:@"category"] caseInsensitiveCompare:filter] == NSOrderedSame ) {
            [tmpValue addObject:videoInfo];
        } else if ( [[(NSDictionary*)[videoInfo objectForKey:@"parsedKeys"] objectForKey:@"age"] caseInsensitiveCompare:filter] == NSOrderedSame ) {
            [tmpValue addObject:videoInfo];
        } else if ( [[((NSDictionary*)[videoInfo objectForKey:@"parsedKeys"]) objectForKey:@"name"] caseInsensitiveCompare:filter] == NSOrderedSame ) {
            [tmpValue addObject:videoInfo];
        }

    }
    
    return [tmpValue copy];
}

#pragma mark - 
#pragma mark Parsing of Categories

// Check if the age exists, if not add to mutable array
-(void)addToAges:(NSString*)newAge {
    if ( newAge == nil ) {
        newAge = @""; // There is an error in the ages
    }
    
    BOOL bFound = NO;
    for ( id objects in ages ) {
        if ( [objects isKindOfClass:[NSString class]] ) {
            NSString* curObject = objects;
            if ( ![curObject compare:newAge] ) 
                bFound = YES;
        }
    }
    if ( !bFound ) {
        [ages addObject:newAge];
    }
}


// Check if the category exists, if not add to mutable array
- (void) addToCategories:(NSString*)newCategory {
    BOOL bFound = NO;
    for ( id objects in categories ) {
        if ( [objects isKindOfClass:[NSString class]] )
        {
            NSString *curObject = objects;
            if ( ![curObject compare:newCategory] )
                bFound = YES;
        }
    }
    if ( !bFound ) {
        [categories addObject:newCategory];
    }
    
}

-(NSString*) replaceSymbols:(NSString*)input {
    NSMutableString *output = [[NSMutableString alloc] initWithString:input];
    
    [output replaceOccurrencesOfString:@"_" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
    
    return output;
}

-(NSString*) safeGetValue:(NSArray*)input index:(NSInteger)index {
    if ( index >= [input count] - 1 )
        return @"Unavailable";
    
    return [self replaceSymbols:[input objectAtIndex:(index+1)]];
}

- (NSDictionary*) parseKeys:(NSArray*)unparsed {
    //Keys *tmp = [[[Keys alloc] init] autorelease];
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithCapacity:7];
    
    NSInteger index = 0;
    for ( NSString* key in unparsed ) 
    {
        if ( ![key caseInsensitiveCompare:@"name"] ) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"name"];
        } else if ( ![key caseInsensitiveCompare:@"age"] ) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"age"];
        } else if ( ![key caseInsensitiveCompare:@"survivor"] ) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"survivorshipLength"];
        } else if ( ![key caseInsensitiveCompare:@"treatment"]) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"treatment"];
        } else if ( ![key caseInsensitiveCompare:@"relationship"]) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"maritalStatus"];
        } else if ( ![key caseInsensitiveCompare:@"jobstatus"]) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"employmentStatus"];
        } else if ( ![key caseInsensitiveCompare:@"kids"]) {
            [tmp setObject:[self safeGetValue:unparsed index:index] forKey:@"childrenStatus"];
        }
        index++;
    }
    
    return [tmp copy];
}


-(NSArray*)getArrayOfSurvivorsFromYoutube:(BOOL)getCategories {
    
    NSMutableArray* survivors = [[NSMutableArray alloc] init];
//    NSMutableArray* _survivorImages = [[NSMutableArray alloc] init];
    NSArray* _Names;
    NSArray* videos;
    
    // YouTube isn't finished downloading yet so don't continue here
    if ([self getFinished] == NO ) {
        NSLog(@"YouTube Not Finished");
        return [survivors copy];
    }
    
    if ( getCategories == YES )
        _Names = [self getCategories];
    else {
        _Names = [self getAges];
    }
    
    
    for ( NSString* name in _Names ) {
        videos = [self getYouTubeArray:name];
        for ( NSDictionary* curVideo in videos )
        {
            BOOL bFound = NO;
            NSString *survivorName = [[curVideo objectForKey:@"parsedKeys"] objectForKey:@"name"];
            for ( NSDictionary* survivor in survivors )
            {
                if ( [(NSString*)[[curVideo objectForKey:@"parsedKeys"] objectForKey:@"name"] compare:survivorName] ) {
                    bFound = YES;
                }
            }
            
            if ( !bFound ) {
                NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithCapacity:2];
                NSURL *url = [curVideo objectForKey:@"thumbnailURL"];
                [tmp setValue:name forKey:@"name"];
                [tmp setValue:url forKey:@"thumbnailURL"];
                [survivors addObject:[tmp copy]];
                break;
            }
        }
    }
    
    return [survivors copy];
}


@end
