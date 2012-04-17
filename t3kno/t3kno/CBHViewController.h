//
//  CBHViewController.h
//  t3kno
//
//  Created by Me on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBHViewController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate>{
    bool pageControlBeingUsed;
}

- (IBAction)loadTableView:(id)sender;
- (IBAction)openGenreOptions:(id)sender;
- (IBAction)openTimePicker:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *tableTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIPickerView *genrePicker;
@property (strong, nonatomic) NSArray *genrePickerData;
@property (retain, nonatomic) IBOutlet UIPickerView *timePicker;
@property (strong, nonatomic) NSArray * timePickerData;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *timeButton;
- (IBAction)showSearchBar:(id)sender;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)openSearchBar:(id)sender;

@property (retain, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSData *receivedData;
@property (strong, nonatomic) NSString *genreFilter; 
@property (strong, nonatomic) NSString *timeFilter;
//scroll view 
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *filterView;



//bottom bar
@property (retain, nonatomic) IBOutlet UIBarButtonItem *playButton;
- (IBAction)playButtonPressed:(id)sender;

//page control
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

//custom methods
- (NSString *) refreshTitle;
- (void) playSong:(NSString *)ytcode;
- (IBAction)changePage:(id)sender;

@end
