//
//  YouTubeInterface.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/21/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataYouTube.h"

@interface YouTubeInterface : NSObject { 
    
    @private GDataFeedYouTubeVideo *mEntriesFeed;
    @private GDataServiceTicket *mEntriesFetchTicket;
    @private NSError *mEntriesFetchError;
    @private NSString *mEntryImageURLString;
    @private NSMutableArray *YouTubeArray;  
    @private NSMutableArray *categories;
    @private NSMutableArray *ages;
    @private BOOL internetConnected;
    
    NSNumber *finished;
}

+(YouTubeInterface*)iYouTube;

-(BOOL)isInternetConnected;

-(NSArray*)getYouTubeArray:(NSString*)filter;
-(NSArray*)getArrayOfSurvivorsFromYoutube:(BOOL)getCategories;

-(NSArray*)getCategories;
-(NSArray*)getAges;

-(void)setFinished:(BOOL)value;
-(BOOL)getFinished;
-(void)loadVideoFeed;
@end
