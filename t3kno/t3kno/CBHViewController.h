//
//  CBHViewController.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHViewController : UIViewController 
    <UIPickerViewDelegate, UIPickerViewDataSource>
- (IBAction)loadTableView:(id)sender;
- (IBAction)openGenreOptions:(id)sender;
- (IBAction)openTopOfOptions:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *tableTitle;
@property (retain, nonatomic) IBOutlet UIToolbar *topOfToolbar;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIPickerView *genrePicker;
@property (strong, nonatomic) NSArray *genrePickerData;

@property (retain, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSData *receivedData;
@property (strong, nonatomic) NSString *genreFilter; 
@property (strong, nonatomic) NSString *timeFilter; 


@end
