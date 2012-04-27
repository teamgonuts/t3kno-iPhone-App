//
//  YoutubeView.m
//  t3kno
//
//  Created by Me on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YoutubeView.h"

@implementation YoutubeView
- (YoutubeView *)initWithYouTubeCode:(NSString *)ytcode
{
    if (self = [super init]) 
    {        
        // HTML to embed YouTube video
        NSString *playerHTML = [[NSString alloc] initWithFormat:@"<html><head>\
                                <body style=\"margin:0\">\
                                <embed id=\"yt\" src=\"http://www.youtube.com/watch?v=%@\" type=\"application/x-shockwave-flash\" width=\"50\" height=\"50\"></embed>\
                                </body></html>", ytcode];

        // Load the html into the webview
        [self loadHTMLString:playerHTML baseURL:nil];
    }
    return self;  
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc 
{
    [super dealloc];
}

@end
