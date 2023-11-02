#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "pattern" asset catalog image resource.
static NSString * const ACImageNamePattern AC_SWIFT_PRIVATE = @"pattern";

/// The "treehouse" asset catalog image resource.
static NSString * const ACImageNameTreehouse AC_SWIFT_PRIVATE = @"treehouse";

#undef AC_SWIFT_PRIVATE