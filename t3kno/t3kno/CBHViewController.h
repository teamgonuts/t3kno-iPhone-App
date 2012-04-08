//
//  CBHViewController.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHViewController : UIViewController
- (IBAction)loadTableView:(id)sender;
- (IBAction)openGenreOptions:(id)sender;
- (IBAction)openTopOfOptions:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *tableTitle;
@property (retain, nonatomic) IBOutlet UIToolbar *topOfToolbar;

@property (strong, nonatomic) NSArray *songs;

@end
