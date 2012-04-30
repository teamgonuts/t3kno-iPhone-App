//
//  Song.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject{
    @public
    NSString *ytcode; ///<song's unique video code
    NSString *title;///<song's title
    NSString *artist;///<song's artist
    NSString *genre;///<song's genre
    NSString *score;///<song's score
    NSString *user;///<user that uploaded the song
}


- (Song *) initWithDictionary: (NSDictionary *) songDictionary;///<initializes the song object with an NSMutableDictionary

- (NSString *) cleanString: (NSString *)dirtyString; ///<cleans the string of any weird characters before displaying

@end
