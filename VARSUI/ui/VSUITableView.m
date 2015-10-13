/**
 *  VARSUI
 *  (c) VARIANTE <http://variante.io>
 *
 *  This software is released under the MIT License:
 *  http://www.opensource.org/licenses/mit-license.php
 */

#import <VARS/VARS.h>

#import "VSUITableView.h"

@interface VSUITableView() {
@private
    VSUIViewUpdate *_updateDelegate;
}

@end

#pragma mark -

@implementation VSUITableView

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

#pragma mark Behaviors

@synthesize shouldRedirectTouchesToNextResponder = _shouldRedirectTouchesToNextResponder;

#pragma mark VSUIViewUpdateDelegate

/**
 *  @inheritDoc VSUIViewUpdateDelegate
 */
- (void)setNeedsUpdate {
    [self update];
}

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
        [self willInit];
        [self didInit];
    }

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
    [self setShouldRedirectTouchesToNextResponder:NO];
}

- (void)didInit {
    [self setShouldRedirectTouchesToNextResponder:NO];

    [self.updateDelegate viewDidInit];
}

- (void)willDealloc {
    vs_dealloc(_updateDelegate);
}

#pragma mark Drawing

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.updateDelegate setDirty:VSUIDirtyTypeLayout];
}

#pragma mark Positioning

- (void)scrollToBottom {
    // HACK: Somehow contentSize is not immediately updated after the text is set, so we need an alternative way to calculate the content height.
    CGPoint offsetPoint = CGPointMake(0.0, fmax(0.0, [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)].height - self.frame.size.height));
    [self setContentOffset:offsetPoint animated:YES];
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
    if (self.shouldRedirectTouchesToNextResponder) {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
    else {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end
