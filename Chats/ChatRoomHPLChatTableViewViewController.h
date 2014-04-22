//
//  ChatRoomHPLChatTableViewViewController.h
//  Chats
//
//  Created by Charles Northup on 4/21/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface ChatRoomHPLChatTableViewViewController : UIViewController

@property MCSession* session;
@property MCPeerID* deviceID;
@property NSArray* peers;

@end
