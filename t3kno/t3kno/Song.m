//
//  Song.m
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Song.h"

@implementation Song
- (Song *) initWithTitle:(NSString *)title_i 
               andArtist:(id)artist_i
                andGenre:(id)genre_i 
                andScore:(id)score_i{
    title = title_i;
    artist = artist_i;
    genre = genre_i;
    score = score_i;
    return (self);
}

- (Song *) initWithDictionary:(NSDictionary *)songDictionary{
    title = [self cleanString:[songDictionary objectForKey:@"title"]];
    artist = [self cleanString:[songDictionary objectForKey:@"artist"]];
    genre = [self cleanString:[songDictionary objectForKey:@"genre"]];
    score = [self cleanString:[songDictionary objectForKey:@"score"]];
    ytcode = [self cleanString:[songDictionary objectForKey:@"ytcode"]];
    
    return (self);
}

//cleans the string to be displayed in the table view
- (NSString *) cleanString:(NSString *)dirtyString{
    NSString *tempString = dirtyString;
    
    //remove escapes from SQL
    //tempString = [tempString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    

    
    return tempString;
}
@end
