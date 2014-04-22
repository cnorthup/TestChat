//
//  ViewController.m
//  Chats
//
//  Created by Charles Northup on 4/20/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
{
    MCPeerID* stevePeerID;
    __weak IBOutlet UITextField *messageTextField;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    devicePeerID = [[MCPeerID alloc] initWithDisplayName:@"Steve"];

    mySession = [[MCSession alloc] initWithPeer:devicePeerID];
    mySession.delegate = self;
    advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-txtchat" discoveryInfo:nil session:mySession];
    [advertiserAssistant start];
    advertiserAssistant.delegate = self;
    messageTextField.hidden = YES;
    [super viewDidLoad];
    
    
    
}
- (IBAction)onStartButtonPressed:(id)sender {
    
        MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:@"chat-txtchat" session:mySession];
        
        browserViewController.delegate = self;
        browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
        browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;
        
        [self presentViewController:browserViewController animated:YES completion:nil];
    
}


#pragma mark -- Browser

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        messageTextField.hidden = NO;
    }];
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Session Manager found peer: %@", peerID);
    [browser invitePeer:peerID toSession:mySession withContext:nil timeout:20];
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Session Manager lost peer: %@", peerID);
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Did not start browsing for peers: %@", error);
}



#pragma mark -- Advertiser


-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    NSLog(@"invitation received");
    invitationHandler(YES, mySession);
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"Did not start advertising error: %@", error);
}

- (void)advertiserAssitantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant
{
    NSLog(@"Wanna Chat");
}

#pragma mark -- Session

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    messageTextField.hidden = NO;
    certificateHandler(true);
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    /// Receive the string here.
        NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@: %@", peerID.displayName, message);
    
    
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
            stevePeerID = peerID;
            break;
        } case MCSessionStateConnecting: {
            NSLog(@"Connecting to %@", peerID);
            
            break;
        } case MCSessionStateNotConnected: {
            break;
        }
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSError *error;
    [messageTextField endEditing:YES];
    [mySession sendData:[messageTextField.text dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:stevePeerID] withMode:MCSessionSendDataReliable error:&error];
    NSLog(@"%@: %@", devicePeerID.displayName, messageTextField.text);
    messageTextField.text = @"";
    return YES;
}


@end