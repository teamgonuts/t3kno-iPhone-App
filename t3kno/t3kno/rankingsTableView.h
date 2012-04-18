//
//  RankingsTableView.h
//  t3kno
//
//  Created by Me on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingsTableView : UITableView

- (NSInteger) numberOfRowsInSection:(NSInteger)section;

- (NSInteger) numberOfSectionsInTableView:(UITableView *)songTableView;

- (NSInteger)tableView:(UITableView *)songTableView
 numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)songTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)tableView:(UITableView *)songTableView
titleForHeaderInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)inputTableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView: (UITableView *)songTableView 
didSelectRowAtIndexPath: (NSIndexPath *)indexPath;


@end
