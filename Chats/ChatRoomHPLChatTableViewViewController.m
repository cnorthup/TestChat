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
@property NSMutableArray* messages;
@property (weak, nonatomic) IBOutlet UITableView *myChatTableView;

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
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSError *error;
    [self.session sendData:[self.myMessageTextField.text dataUsingEncoding:NSUTF8StringEncoding] toPeers:self.peers withMode:MCSessionSendDataReliable error:&error];
    [self.myChatTableView reloadData];
    [self.myMessageTextField endEditing:YES];
    NSLog(@"%@: %@", self.deviceID.displayName, self.myMessageTextField.text);
    self.myMessageTextField.text = @"";
    return YES;
}

@end
