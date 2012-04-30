//
//  YoutubeView.h
//  t3kno
//
//  Created by Me on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeView : UIWebView
- (YoutubeView *)initWithYouTubeCode:(NSString *)ytcode; ///<embedds the youtube video with a video code 'ytcode' into the UIWebView

@end
