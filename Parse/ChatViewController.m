//
//  ChatViewController.m
//  Parse
//
//  Created by Taomin Chang on 9/25/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>


@interface ChatViewController ()
@property (strong, nonatomic) IBOutlet UITextView *chatField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITableView *chatBoard;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true);

    self.chatBoard.delegate = self;
    self.chatBoard.dataSource = self;
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
//    [NSTimer scheduledTimerWithTimeInterval:5 invocation:@selector(onTimer) repeats:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    NSDictionary *dic = self.messages[indexPath.row];
    cell.textLabel.text = dic[@"text"];
//    cell.text = self.messages[indexPath.row].text;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message"];
    chatMessage[@"text"] = self.chatField.text;
    [chatMessage saveInBackground];
}

- (void)onTimer {
    // Add code to be run periodically
    NSLog(@"timer called");
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
//    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld scores.", [objects count]);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object);
            }
            self.messages = objects;
            [self.chatBoard reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
