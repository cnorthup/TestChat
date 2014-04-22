//
//  ChatRoomHPLChatTableViewViewController.m
//  Chats
//
//  Created by Charles Northup on 4/21/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//


@class ViewController;

#import "ChatRoomHPLChatTableViewViewController.h"

@interface ChatRoomHPLChatTableViewViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myMessageTextField;
@property (weak, nonatomic) IBOutlet UITableView *myChatTableView;
@property NSMutableArray* messages;

@end

@implementation ChatRoomHPLChatTableViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messages = [NSMutableArray new];
    NSLog(@"%@", self.deviceID);
    NSLog(@"%@", self.session);
    NSLog(@"%@", self.peers);
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageReuseCellID"];
    NSDictionary* cellDictionary = [self.messages objectAtIndex:indexPath.row];
    if ([cellDictionary objectForKey:@"sender"] == self.deviceID) {
        cell.textLabel.text = cellDictionary[@"message"];
        cell.backgroundColor = [UIColor grayColor];
    }
    else{
        cell.textLabel.text = cellDictionary[@"message"];
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSError *error;
    [self.session sendData:[self.myMessageTextField.text dataUsingEncoding:NSUTF8StringEncoding] toPeers:self.peers withMode:MCSessionSendDataReliable error:&error];
    [self.myMessageTextField endEditing:YES];
    
    NSDictionary* sentMessage = @{@"sender": self.deviceID, @"message": self.myMessageTextField.text};
    [self gotMessage:sentMessage];
    NSLog(@"%@: %@", self.deviceID.displayName, self.myMessageTextField.text);
    self.myMessageTextField.text = @"";
    return YES;
}

-(void)gotMessage:(NSDictionary*)message{
    [self.messages addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myChatTableView reloadData];

        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.messages.count -1 inSection:0];
        [self.myChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });

}

@end
