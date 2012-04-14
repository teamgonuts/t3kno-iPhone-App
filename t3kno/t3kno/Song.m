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
    title = [songDictionary objectForKey:@"title"];
    artist = [songDictionary objectForKey:@"artist"];
    genre = [songDictionary objectForKey:@"genre"];
    score = [songDictionary objectForKey:@"score"];
    ytcode = [songDictionary objectForKey:@"ytcode"];
    
    return (self);
}
@end
