//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "DemoTableController.h"


@interface DemoTableController ()

@end

@implementation DemoTableController
@synthesize delegate=_delegate;

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Popover Title";
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString *strAddr = @"";
    
    if (self.isAddressSelected)
    {
        strAddr = [NSString stringWithFormat:@"%@, %@, %@",[[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"aname"] capitalizedString], [[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"ad"],[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"zip"]];
    }
    else
    {
        strAddr = [[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"maskednumber"];
    }
    
    cell.textLabel.text = strAddr;
    cell.textLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:10.0];
    
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(didSelectFromList:AtIndex:)])
    {
        NSString *strAddr;
        
        if (self.isAddressSelected)
        {
            strAddr = [NSString stringWithFormat:@"%@, %@, %@",[[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"aname"] capitalizedString], [[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"ad"],[[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"zip"]];
        }
        else
        {
            strAddr = [[self.arrayList objectAtIndex:indexPath.row] objectForKey:@"maskednumber"];
        }
        
        [self.delegate didSelectFromList:strAddr AtIndex:indexPath.row];
    }
}




@end
