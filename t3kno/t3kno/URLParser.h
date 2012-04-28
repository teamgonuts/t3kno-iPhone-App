//
//  URLParser.h
//  t3kno
//
//  Created by Me on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//CREDITS FOR THIS CLASS: http://dev.doukasd.com/2011/03/get-values-from-parameters-in-an-nsurl-string/

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end
