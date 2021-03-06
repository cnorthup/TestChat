//
//  HPLChatTableViewCell.m
//
//  Created by Alex Barinov
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "HPLChatTableViewCell.h"
#import "HPLChatData.h"

@interface HPLChatTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIView *bubbleView;
@property (nonatomic, retain) UIView *avatarView;
@property (nonatomic, retain) UIView *statusImage;

- (void) setupInternalData;

@end

@implementation HPLChatTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleView = _bubbleView;
@synthesize showAvatar = _showAvatar;
@synthesize avatarView = _avatarView;
@synthesize statusImage = _statusImage;


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

- (void)setData:(HPLChatData *)data
{
    _data = data;
    if ( data.bubbleView ) {
        // unset current bubbleview so that setupInternalData will use the bubbleView from data. Otherwise an old bubbleView may be cached.
        self.bubbleView = nil;
    }
    [self setupInternalData];
}

- (void)setDataInternal:(HPLChatData *)value
{
	self.data = value;
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    HPLChatType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == ChatTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;

    if(!self.bubbleView) {

        if ( self.data.bubbleView ) {
            self.bubbleView = self.data.bubbleView;
        } else {
            self.bubbleView = [[UIView alloc] init];
            self.bubbleView.backgroundColor = [UIColor whiteColor];
        }
        [self addSubview:self.bubbleView];
    }
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarView removeFromSuperview];
        
        if ( self.data.avatarView == nil ) {
            self.avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"missingAvatar.png"]];
        } else {
            self.avatarView = self.data.avatarView;
        }
        
        // TODO: How do we want to handle avatars that are not 35x35?
        CGFloat avatarX = (type == ChatTypeSomeoneElse) ? 2 : self.frame.size.width - 45;
        CGFloat avatarY = self.frame.size.height - 35;
        
        self.avatarView.frame = CGRectMake(avatarX, avatarY, 35, 35);
        [self addSubview:self.avatarView];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == ChatTypeSomeoneElse) x += 54;
        if (type == ChatTypeMine) x -= 54;
    }

    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];

    [self.statusImage removeFromSuperview];
    self.statusImage = self.data.statusView;
    self.statusImage.frame = CGRectMake(self.customView.frame.origin.x - 35.0f, self.customView.frame.origin.y, 20.0f, 20.0f);
    [self.contentView addSubview:self.statusImage];

    self.bubbleView.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
    [self sendSubviewToBack:self.bubbleView];   // make sure it goes behind the text


    if ( !self.data.bubbleView ) {
        // custom styling for the default bubble view.
        // has to be applied after the bubbleview frame is calculated
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.bubbleView.frame.size.height-1, self.bubbleView.frame.size.width, 1.0f);

        bottomBorder.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.05].CGColor;
        [self.bubbleView.layer addSublayer:bottomBorder];
    }

    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:0.5];
    [self addGestureRecognizer:recognizer];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (BOOL) becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender {
    if ([_data.view isKindOfClass:[UILabel class]]) {
        UILabel * cellLabel = (UILabel*)_data.view;
        [[UIPasteboard generalPasteboard] setString:[cellLabel text]];
    } else if ([_data.view isKindOfClass:[UIImageView class]]) {
        UIImageView * cellImageView = (UIImageView*)_data.view;
        [[UIPasteboard generalPasteboard] setImage:cellImageView.image];
    } else if ([_data.view isKindOfClass:[UIImage class]]) {
        UIImage * cellImage = (UIImage*)_data.view;
        [[UIPasteboard generalPasteboard] setImage:cellImage];
    } else {
        [[UIPasteboard generalPasteboard] setString:@"Unknown cell type can't be copied."];
    }
    
    [self resignFirstResponder];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if ([self becomeFirstResponder] == NO)
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];

    // Create Rect

    CGPoint pressPoint = [longPressRecognizer locationInView:self];

    CGRect targetRect = CGRectMake(pressPoint.x - 50, pressPoint.y, 100, 100);
    [menu setTargetRect:targetRect inView:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillShow:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([self isFirstResponder] == NO)
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

- (void) menuWillHide:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void) menuWillShow:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

@end
