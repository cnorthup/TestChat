//
//  ChatViewController.m
//  Chats
//
//  Created by Charles Northup on 4/21/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendMessage];
    // Do any additional setup after loading the view.
}

- (void)sendMessage {
    id <BORChatMessage> message = [[BORChatMessage alloc] init];
    message.text = @"this works";
    message.sentByCurrentUser = YES;
    message.date = [NSDate date];
    [self addMessage:message scrollToMessage:YES];
}

@end
