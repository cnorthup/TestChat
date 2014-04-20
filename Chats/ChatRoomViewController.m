//
//  ChatRoomViewController.m
//  Chats
//
//  Created by Charles Northup on 4/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ChatRoomViewController.h"

@interface ChatRoomViewController ()

@end

@implementation ChatRoomViewController

- (void)viewDidLoad
{
    devicePeerID = [[MCPeerID alloc] initWithDisplayName:@"Chat Room"];
    session = [[MCSession alloc] initWithPeer:devicePeerID];
    session.delegate = self;
    serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:devicePeerID discoveryInfo:nil serviceType:@"hey"
    serviceAdvertiser.delegate = self;
    [super viewDidLoad];

    
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    
}

@end
