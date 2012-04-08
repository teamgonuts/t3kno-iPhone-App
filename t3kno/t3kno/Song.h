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
        NSString *ytcode;
        NSString *title;
        NSString *artist;
        NSString *genre;
        NSString *score;
}

- (Song *) initWithTitle: (NSString *) title_i
               andArtist: artist_i
                andGenre: genre_i
                andScore: score_i;


@end