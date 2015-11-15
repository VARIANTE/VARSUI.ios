/**
 *  VARSUI
 *  (c) VARIANTE <http://variante.io>
 *
 *  This software is released under the MIT License:
 *  http://www.opensource.org/licenses/mit-license.php
 */

#import <VARS/VARS.h>

#import "VSUITextField.h"

/**
 *  Default UUID.
 */
static const int DEFAULT_UUID = -1;

#pragma mark -

@interface VSUITextField() {
@private
    VSUIViewUpdate *_updateDelegate;
}

#pragma mark Private Accessors.

@property (nonatomic) int UUID;

@end

#pragma mark -

@implementation VSUITextField

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

#pragma mark Identifiers

@synthesize UUID = _uUID;

#pragma mark Data

/**
 *  @inheritDoc UITextField
 */
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];

    [self.updateDelegate setDirty:VSUIDirtyTypeData];
}

/**
 *  @inheritDoc UITextField
 */
- (void)setText:(NSString *)text {
    [super setText:text];

    [self.updateDelegate setDirty:VSUIDirtyTypeData];
}

- (NSRange)selectedRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;

    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];

    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];

    [self setSelectedTextRange:selectionRange];
}

#pragma mark Behaviors

@synthesize shouldRedirectTouchesToNextResponder = _shouldRedirectTouchesToNextResponder;

#pragma mark Styles

@synthesize shouldHideKeyboard = _shouldHideKeyboard;

- (void)setShouldHideKeyboard:(BOOL)shouldHideKeyboard {
    _shouldHideKeyboard = shouldHideKeyboard;

    if (shouldHideKeyboard) {
        UIView *dummyKeyboard = [[UIView alloc] initWithFrame:CGRectZero];
        [self setInputView:dummyKeyboard];
        vs_dealloc(dummyKeyboard);

        if ([self respondsToSelector:NSSelectorFromString(@"inputAssistantItem")]) {
            UITextInputAssistantItem *item = [self inputAssistantItem];
            [item setLeadingBarButtonGroups:@[]];
            [item setTrailingBarButtonGroups:@[]];
        }
    }
}

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
    [self setShouldRedirectTouchesToNextResponder:NO];
}

- (void)didInit {
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
