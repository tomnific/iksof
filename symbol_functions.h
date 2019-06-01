//
//  symbol_functions.h
//  iOS Kernel Symbol Offset Finder
//
//  Created by Tom Metzger on 5/27/19.
//  Copyright © 2019 Tom. All rights reserved.
//

#ifndef symbol_functions_h
#define symbol_functions_h


#import <Foundation/Foundation.h>





typedef struct {
	NSString *name;
	unsigned long long offset;
} symbol_t;




@interface NSValue (symbol_t)
+ (instancetype)valuewithSymbol:(symbol_t)value;
@property (readonly) symbol_t symbolValue;
@end


@implementation NSValue (symbol_t)
+ (instancetype)valuewithSymbol:(symbol_t)value
{
	return [self valueWithBytes:&value objCType:@encode(symbol_t)];
}


- (symbol_t) symbolValue
{
	symbol_t value;
	[self getValue:&value];
	return value;
}
@end



NSValue *getOffset_kernel_map(NSString *kernelcachePath);
NSValue *getOffset_kernel_task(NSString *kernelcachePath);
NSValue *getOffset_bzero(NSString *kernelcachePath);
NSValue *getOffset_bcopy(NSString *kernelcachePath);
NSValue *getOffset_copyin(NSString *kernelcachePath);
NSValue *getOffset_copyout(NSString *kernelcachePath);
NSValue *getOffset_rootvnode(NSString *kernelcachePath);
NSValue *getOffset_kauth_cred_ref(NSString *kernelcachePath);
NSValue *getOffset_ZNK12OSSerializer9serializeEP11OSSerialize(NSString *kernelcachePath);
NSValue *getOffset_address_host_priv_self(NSString *kernelcachePath);
NSValue *getOffset_ipc_port_alloc_special(NSString *kernelcachePath);
NSValue *getOffset_ipc_kobject_set(NSString *kernelcachePath);
NSValue *getOffset_ipc_port_make_send(NSString *kernelcachePath);
NSValue *getOffset_rop_add_x0_x0_0x10(NSString *kernelcachePath);
NSValue *getOffset_zone_map(NSString *kernelcachePath);
NSValue *getOffset_iosurfacerootuserclient_vtab(NSString *kernelcachePath, NSString *IOSurfaceKextPath);

#endif /* symbol_functions_h */
