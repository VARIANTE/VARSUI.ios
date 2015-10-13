/**
 *  VARSUI
 *  (c) VARIANTE <http://variante.io>
 *
 *  This software is released under the MIT License:
 *  http://www.opensource.org/licenses/mit-license.php
 */

#import <VARS/VARS.h>

#import "VSUIDirtyType.h"
#import "VSUINotifications.h"
#import "VSUIViewController.h"
#import "VSUIView.h"
#import "VSUIViewUpdate.h"

@interface VSUIViewController () {
@private
    NSString *_cachedLocaleIdentifier;
}

@end

#pragma mark -

@implementation VSUIViewController

@synthesize model = _model;

#pragma mark Lifecycle

- (id)init {
    self = [super init];

    if (self) {
        [self loadModel];
        [self willInit];
        [self didInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self loadModel];
        [self willInit];
        [self didInit];
    }

    return self;
}

- (void)dealloc {
    [self willDealloc];

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)willInit {

}

- (void)didInit {

}

- (void)willDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    vs_dealloc(_model);
}

- (void)loadModel {

}

#pragma mark Event Handling

- (void)viewDidLoad {
    [super viewDidLoad];

    _cachedLocaleIdentifier = [NSLocale currentLocale].localeIdentifier;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onCurrentLocaleDidChange:) name:NSCurrentLocaleDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onViewConfigDidChange:) name:VSUIConfigDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onViewStyleDidChange:) name:VSUIStyleDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)currentLocaleDidChange:(NSDictionary *)context {
    if ([self.view conformsToProtocol:@protocol(VSUIViewUpdateDelegate)]) {
        VSUIViewUpdate *viewUpdateDelegate = ((id<VSUIViewUpdateDelegate>)self.view).updateDelegate;

        [viewUpdateDelegate setDirty:VSUIDirtyTypeLocale];
    }
}

- (void)applicationDidBecomeActive:(NSDictionary *)context {
    if ([self.view conformsToProtocol:@protocol(VSUIViewUpdateDelegate)]) {
        VSUIViewUpdate *viewUpdateDelegate = ((id<VSUIViewUpdateDelegate>)self.view).updateDelegate;

        [viewUpdateDelegate setDirty:VSUIDirtyTypeDepth];
    }
}

- (void)viewConfigDidChange:(NSDictionary *)context {
    if ([self.view conformsToProtocol:@protocol(VSUIViewUpdateDelegate)]) {
        VSUIViewUpdate *viewUpdateDelegate = ((id<VSUIViewUpdateDelegate>)self.view).updateDelegate;

        [viewUpdateDelegate setDirty:VSUIDirtyTypeConfig];
    }
}

- (void)viewStyleDidChange:(NSDictionary *)context {
    if ([self.view conformsToProtocol:@protocol(VSUIViewUpdateDelegate)]) {
        VSUIViewUpdate *viewUpdateDelegate = ((id<VSUIViewUpdateDelegate>)self.view).updateDelegate;

        [viewUpdateDelegate setDirty:VSUIDirtyTypeStyle];
    }
}

/**
 *  @private
 *
 *  NSNotificationCenter selector invoked when NSCurrentLocale did change.
 *
 *  @param note
 */
- (void)_onCurrentLocaleDidChange:(NSNotification *)note {
    NSString *oldLocaleIdentifier = _cachedLocaleIdentifier;
    NSString *newLocaleIdentifier = [NSLocale currentLocale].localeIdentifier;
    NSDictionary *context = @{ @"oldLocaleIdentifier": oldLocaleIdentifier, @"newLocaleIdentifier": newLocaleIdentifier };

    _cachedLocaleIdentifier = newLocaleIdentifier;

    [self currentLocaleDidChange:context];
}

/**
 *  @private
 *
 *  NSNotificationCenter selector invoked when application did become active.
 *
 *  @param note
 */
- (void)_onApplicationDidBecomeActive:(NSNotification *)note {
    [self applicationDidBecomeActive:note.userInfo];
}

/**
 *  @private
 *
 *  NSNotificationCenter selector invoked when UI config did change.
 *
 *  @param note
 */
- (void)_onViewConfigDidChange:(NSNotification *)note {
    [self viewConfigDidChange:note.userInfo];
}

/**
 *  @private
 *
 *  NSNotificationCenter selector invoked when UI style did change.
 *
 *  @param note
 */
- (void)_onViewStyleDidChange:(NSNotification *)note {
    [self viewStyleDidChange:note.userInfo];
}

@end
