//
//  MasterViewController.m
//  Tea
//
//  Created by Moshe on 1/12/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "Tea.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

/**
 *  A progress bar.
 */

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.objects = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *object = self.objects[indexPath.row];
    
    NSString *name = object[@"name"];
    
    cell.textLabel.text = name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Data Load

- (IBAction)loadWithTea:(id)sender
{
    
    
    [[Tea tea] loadURL:self.urlToTest withCompletionHandler:^(BOOL success, NSData *data) {
    
        NSMutableArray *results = nil;
        
        if (data) {
            results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.objects = results;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.progress = 1.0;
                self.progressView.alpha = 0.0;
            }];
        });
    }];
}

- (IBAction)loadWithNSURLRequest:(id)sender {
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.urlToTest];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableArray *results = nil;
        
        if (data) {
            results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.objects = results;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - URL 
     
- (NSURL*)urlToTest {
    NSString *address = @"http://jsonplaceholder.typicode.com/comments";
    return [NSURL URLWithString:address];
}

@end
