//
//  BrowserViewController.m
//  Chats
//
//  Created by Charles Northup on 4/21/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()<MCSessionDelegate, MCNearbyServiceBrowserDelegate>
{
    MCPeerID* devicePeerID;
    MCSession* mySession;
    MCNearbyServiceBrowser* nearbyServiceBrowser;
}

@end

@implementation BrowserViewController

- (void)viewDidLoad
{
    devicePeerID = [[MCPeerID alloc] initWithDisplayName:@"Wheatley"];
//    mySession = [[MCSession alloc] initWithPeer:devicePeerID];
//    mySession.delegate = self;
    nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:devicePeerID serviceType:@"chat-txtchat"];
    nearbyServiceBrowser.delegate = self;

    [super viewDidLoad];
    
    
    
}

#pragma mark -- Browser

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Session Manager found peer: %@", peerID);
    [nearbyServiceBrowser invitePeer:peerID toSession:mySession withContext:nil timeout:20];
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Session Manager lost peer: %@", peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Did not start browsing for peers: %@", error);
}

#pragma mark -- Session

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    NSLog(@"Did receive certificate");
    certificateHandler(true);
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Did receive data.");
    
    /// Receive the string here.
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Message: %@",message);
    
    
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

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected: {
            
            NSLog(@"Connected to %@", peerID);
            NSError *error;
            [mySession sendData:[@"text" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
            
            break;
        } case MCSessionStateConnecting: {
            NSLog(@"Connecting to %@", peerID);
            
            break;
        } case MCSessionStateNotConnected: {
            break;
        }
    }
    
}

//- (void)start
//{
//    [serviceAdvertiser startAdvertisingPeer];
//    [nearbyServiceBrowser startBrowsingForPeers];
//}
//
//- (void)stop
//{
//    [serviceAdvertiser stopAdvertisingPeer];
//    [nearbyServiceBrowser stopBrowsingForPeers];
//}

@end
