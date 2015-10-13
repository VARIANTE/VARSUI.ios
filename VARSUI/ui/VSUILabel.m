/**
 *  VARSUI
 *  (c) VARIANTE <http://variante.io>
 *
 *  This software is released under the MIT License:
 *  http://www.opensource.org/licenses/mit-license.php
 */

#import <VARS/VARS.h>

#import "VSUILabel.h"

/**
 *  Default UUID.
 */
static const int DEFAULT_UUID = -1;

#pragma mark -

@interface VSUILabel() {
@private
    VSUIViewUpdate *_updateDelegate;
}

@end

#pragma mark -

@implementation VSUILabel VS_UPDATE_ON_DRAWRECT

#pragma mark VSUIViewUpdateDelegate

/**
 *  @inheritDoc VSUIViewUpdateDelegate
 */
@dynamic updateDelegate;

- (VSUIViewUpdate *)updateDelegate {
    if (_updateDelegate != nil) return _updateDelegate;

    _updateDelegate = [[VSUIViewUpdate alloc] init];
    [_updateDelegate setDelegate:self];

    return _updateDelegate;
}

#pragma mark UILabel

/**
 *  @inheritDoc UILabel
 */
- (void)setText:(NSString *)text {
    [super setText:text];
    [self.updateDelegate setDirty:VSUIDirtyTypeData];
}

#pragma mark Identifiers

@synthesize UUID = _uUID;

#pragma mark Behaviors

@synthesize shouldRedirectTouchesToNextResponder = _shouldRedirectTouchesToNextResponder;

#pragma mark Context Menu

@synthesize menuEnabled = _menuEnabled;

- (void)setMenuEnabled:(BOOL)menuEnabled {
    _menuEnabled = menuEnabled;

    [self setUserInteractionEnabled:YES];
}

@synthesize menuGesturesEnabled = _menuGesturesEnabled;

#pragma mark Styles

@synthesize textEdgeInsets = _textEdgeInsets;

/**
 *  @inheritDoc VSUIViewUpdateDelegate
 */
- (void)update {
    [self.updateDelegate viewDidUpdate];
}

/**
 *  @inheritDoc VSUIViewUpdateDelegate
 */
- (BOOL)isDirty:(VSUIDirtyType)dirtyType {
    return [self.updateDelegate isDirty:dirtyType];
}

#pragma mark Lifecycle

/**
 *  @inheritDoc UIView
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setUUID:DEFAULT_UUID];
        [self willInit];
        [self didInit];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame UUID:(int)UUID {
    self = [super initWithFrame:frame];

    if (self) {
        [self setUUID:UUID];
        [self willInit];
        [self didInit];
    }

    return self;
}

- (id)initWithUUID:(int)UUID {
    self = [self initWithFrame:CGRectZero UUID:UUID];

    return self;
}

/**
 *  @inheritDoc NSObject
 */
- (void)dealloc {
    [self willDealloc];

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)willInit {
    [self setTextEdgeInsets:UIEdgeInsetsZero];
    [self setShouldRedirectTouchesToNextResponder:NO];
    [self setMenuGesturesEnabled:YES];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_onRevealMenu:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
    vs_dealloc(longPressGestureRecognizer);

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onHideMenu:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapGestureRecognizer];
    vs_dealloc(singleTapGestureRecognizer);
}

- (void)didInit {
    [self.updateDelegate viewDidInit];
}

- (void)willDealloc {
    vs_dealloc(_updateDelegate);
}

#pragma mark Drawing

/**
 *  @inheritDoc UIView
 */
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.updateDelegate setDirty:VSUIDirtyTypeLayout];
}

/**
 *  @inheritDoc UILabel
 */
- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInsets)];
}

#pragma mark Behaviors

/**
 *  @inheritDoc UIResponder
 */
- (BOOL)canBecomeFirstResponder {
    return self.menuEnabled;
}

#pragma mark Context Menu

/**
 *  @inheritDoc UIResponder
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.menuEnabled) {
        return (action == @selector(copy:) || action == @selector(paste:));
    }
    else {
        return NO;
    }
}

/**
 *  @inheritDoc UIResponder
 */
- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.text];
}

/**
 *  @inheritDoc UIResponder
 */
- (void)paste:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [self setText:pasteboard.string];
}

- (void)revealMenu {
    if (!self.menuEnabled) return;

    [self becomeFirstResponder];

    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

- (void)hideMenu {
    if (!self.menuEnabled) return;

    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];

    [self resignFirstResponder];
}

/**
 *  @private
 *
 *  Handler invoked when the menu should be revealed.
 *
 *  @param gestureRecognizer
 */
- (void)_onRevealMenu:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.menuGesturesEnabled) return;

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self revealMenu];
    }
}

/**
 *  @private
 *
 *  Handler invoked when the menu should be hidden.
 *
 *  @param gestureRecognizer
 */
- (void)_onHideMenu:(UIGestureRecognizer *)gestureRecognizer {
    [self hideMenu];
}

#pragma mark Event Handling

/**
 *  @inheritDoc UIResponder
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.shouldRedirectTouchesToNextResponder) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}

/**
 *  @inheritDoc UIResponder
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.shouldRedirectTouchesToNextResponder) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
    else {
        [super touchesMoved:touches withEvent:event];
    }
}

/**
 *  @inheritDoc UIResponder
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.shouldRedirectTouchesToNextResponder) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

/**
 *  @inheritDoc UIResponder
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.menuGesturesEnabled) return;

    if (self.shouldRedirectTouchesToNextResponder) {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
    else {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end
