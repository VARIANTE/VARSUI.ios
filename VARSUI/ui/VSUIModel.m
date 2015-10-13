/**
 *  VARSUI
 *  (c) VARIANTE <http://variante.io>
 *
 *  This software is released under the MIT License:
 *  http://www.opensource.org/licenses/mit-license.php
 */

#import "VSUIModel.h"

@implementation VSUIModel

#pragma mark Lifecycle

- (id)init {
    self = [super init];

    if (self) {
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

}

@end
